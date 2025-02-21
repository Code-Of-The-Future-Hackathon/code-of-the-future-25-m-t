//
//  OAuthAdapter.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Alamofire
import Foundation
import KeychainSwift

class OAuthAdapter: RequestInterceptor {
    typealias RequestRetryCompletion = (Alamofire.RetryResult) -> Void
    var didLogout: Event?

    private let lock = NSLock()
    private var isRefreshing = false
    private let userRepository: UserRepository
    private var requestsToRetry: [RequestRetryCompletion] = []
    var authToken: Tokens? {
        return userRepository.authToken
    }

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary

        return Session(configuration: configuration)
    }()

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let loginURL = Constants.RequestEndpoint.serverURL
        guard let absoluteURL = urlRequest.url?.absoluteString, absoluteURL != loginURL else {
            completion(.success(urlRequest))
            return
        }
        var urlRequest = urlRequest
        if let token = authToken?.accessToken {
            urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }

    func retry(_ request: Alamofire.Request, for session: Alamofire.Session, dueTo error: Error, completion: @escaping (Alamofire.RetryResult) -> Void) {
        lock.lock()

        defer {
            lock.unlock()
        }

        if let response = request.task?.response as? HTTPURLResponse,
           let token = authToken,
           response.statusCode == 401 {
            requestsToRetry.append(completion)

            if isRefreshing == false {
                isRefreshing = true
                Task {
                    do {
                        let newAuthToken = try await refreshTokens(with: token)
                        userRepository.authToken = Tokens(accessToken: newAuthToken.accessToken,
                                                          refreshToken: newAuthToken.refreshToken)
                        handleRequestsToRetry(shouldRetry: true)
                    } catch {
                        handleRequestsToRetry(shouldRetry: false)
                    }
                    isRefreshing = false
                }
            }
        } else if let responseData = (request as? DataRequest)?.data,
                  let errorJSON = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
                  let errorMessage = errorJSON["message"] as? String {
            if let backendError = BackendError(rawValue: errorMessage) {
                completion(.doNotRetryWithError(CustomError.backend(backendError)))
            } else {
                completion(.doNotRetryWithError(CustomError.unrecognized(errorMessage)))
            }
        } else {
            completion(.doNotRetryWithError(error))
        }
    }

    func refreshTokens(with token: Tokens) async throws -> Tokens {
        isRefreshing = true
        let urlString = Constants.RequestEndpoint.refreshToken.url

        let headers = HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json"),
                                   HTTPHeader(name: "Authorization", value: "Bearer" + " \(token.refreshToken)")])

        let response = await session.request(urlString,
                                             method: .post,
                                             encoding: JSONEncoding.default,
                                             headers: headers)
            .cacheResponse(using: .cache)
            .redirect(using: .follow)
            .validate()
            .serializingDecodable(Tokens.self)
            .response

        isRefreshing = false
        switch response.result {
        case let .success(refreshedToken):
            return refreshedToken
        case let .failure(error):
            throw error
        }
    }

    func handleRequestsToRetry(shouldRetry: Bool) {
        lock.lock()

        defer {
            lock.unlock()
        }

        if shouldRetry {
            requestsToRetry.forEach({ $0(.retry) })
        } else {
            requestsToRetry.forEach({ $0(.doNotRetry) })
            userRepository.logout()
            didLogout?()
        }

        requestsToRetry.removeAll()
    }
}
