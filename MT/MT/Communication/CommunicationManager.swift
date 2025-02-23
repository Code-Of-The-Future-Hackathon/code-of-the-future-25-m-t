//
//  CommunicationManager.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Alamofire
import Foundation

class CommunicationManager {
    private class var label: String {
        return "CommunicationManager"
    }

    private let dispatchQueue = DispatchQueue(label: label)

    let defaultHeaders: HTTPHeaders = ["Content-Type": "application/json",
                                       "Accept-Language": "en"]
    let sessionManager: Alamofire.Session

    public init(requestAdapter: RequestAdapter? = nil,
                requestRetrier: RequestRetrier? = nil) {
        var interceptor: Interceptor?

        let serverTrustManager: ServerTrustManager = {
            var evaluators: [String: ServerTrustEvaluating] = [:]

            let urlHost = URL(string: Constants.RequestEndpoint.serverURL)!.host()

            evaluators[urlHost!] = DisabledTrustEvaluator()

            return ServerTrustManager(evaluators: evaluators)
        }()

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary

        if let requestRetrier = requestRetrier,
           let requestAdapter = requestAdapter {
            interceptor = Interceptor(adapter: requestAdapter, retrier: requestRetrier)
        }

        sessionManager = Alamofire.Session(configuration: configuration,
                                           interceptor: interceptor,
                                           serverTrustManager: serverTrustManager)
    }

    struct EmptyResponseSerializer: ResponseSerializer {
        func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> EmptyResponse {
            if let error = error {
                throw error
            }
            return EmptyResponse()
        }
    }

    private func execute<A>(_ resource: Request<A>) async throws -> A {
        let response: DataResponse<A, AFError>
        if A.self is EmptyResponse.Type {
            let dataResponse = await sessionManager.request(resource.url,
                                                            method: resource.httpMethod,
                                                            parameters: resource.parameters,
                                                            encoding: resource.encoding,
                                                            headers: resource.headers,
                                                            interceptor: .retryPolicy)
                .cacheResponse(using: .cache)
                .redirect(using: .follow)
                .validate()
                .cURLDescription { description in
                    print("description: \(description)")
                }
                .serializingResponse(using: EmptyResponseSerializer())
                .response

            guard let typedResponse = dataResponse as? DataResponse<A, AFError> else {
                let failureText = "Failed to cast DataResponse to expected type"
                assertionFailure(failureText)
                throw CustomError.unrecognized(failureText)
            }

            response = typedResponse
        } else {
            response = await sessionManager.request(resource.url,
                                                    method: resource.httpMethod,
                                                    parameters: resource.parameters,
                                                    encoding: resource.encoding,
                                                    headers: resource.headers,
                                                    interceptor: .retryPolicy)
                .cacheResponse(using: .cache)
                .redirect(using: .follow)
                .validate()
                .cURLDescription { description in
                    print("description: \(description)")
                }
                .serializingDecodable(A.self)
                .response
        }

        print("Response: \(response)")
        switch response.result {
        case let .success(data):
            return data
        case let .failure(error):
            // request with retry
            if let alamofireError = error.asAFError {
                if case let .requestRetryFailed(_, originalError) = alamofireError {
                    if let afeError = originalError.asAFError {
                        if case let .requestRetryFailed(_, originalError2) = afeError {
                            if let afeErro2 = originalError2.asAFError {
                                if case let .responseValidationFailed(reason: validationError) = afeErro2,
                                   case let .unacceptableStatusCode(code: statusCode) = validationError {
                                    if let responseData = response.data {
                                        if let errorJSON = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
                                           let errorMessage = errorJSON["message"] as? String {
                                            if let backendError = BackendError(rawValue: errorMessage) {
                                                throw CustomError.backend(backendError)
                                            }
                                            throw CustomError.unrecognized(errorMessage)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // request without retry
            if case let .responseValidationFailed(reason: validationError) = error,
               case let .unacceptableStatusCode(code: statusCode) = validationError {
                if statusCode == 400 {
                    if let responseData = response.data {
                        if let errorJSON = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
                           let errorMessage = errorJSON["message"] as? String {
                            if let backendError = BackendError(rawValue: errorMessage) {
                                throw CustomError.backend(backendError)
                            }
                            throw CustomError.unrecognized(errorMessage)
                        }
                    }
                }
            }
            throw error
        }
    }
}

extension CommunicationManager {
    struct Request<A: Decodable> {
        let url: String
        let httpMethod: HTTPMethod
        let headers: HTTPHeaders?
        let parameters: Parameters?
        let parse: (Data) throws -> A
        let encoding: ParameterEncoding

        init(_ url: String,
             httpMethod: HTTPMethod = .get,
             headers: HTTPHeaders? = nil,
             parameters: Parameters? = nil,
             encoding: ParameterEncoding = URLEncoding.default,
             parse: @escaping (Data) throws -> A) {
            self.url = url
            self.httpMethod = httpMethod
            self.headers = headers
            self.parameters = parameters
            self.parse = parse
            self.encoding = encoding
        }
    }
}

extension CommunicationManager.Request where A: Decodable {
    init(_ url: URLConvertible & HTTPMethodConvertible,
         headers: HTTPHeaders? = nil,
         encoding: ParameterEncoding = URLEncoding.default,
         parameters: Parameters? = nil) {
        self.init(url.url,
                  httpMethod: url.method,
                  headers: headers,
                  parameters: parameters,
                  encoding: encoding) { data in
            if data.isEmpty && A.self is EmptyResponse.Type,
               let emptyResponse = EmptyResponse() as? A {
                return emptyResponse.self
            }

            let parsed = try JSONDecoder().decode(A.self, from: data)
            return parsed
        }
    }
}

extension CommunicationManager: LoginCommunication {
    func login(email: String, password: String) async throws -> Tokens {
        let endpoint = Constants.RequestEndpoint.login
        let parameters: Parameters = ["email": email.lowercased(),
                                      "password": password]

        return try await execute(Request(endpoint,
                                         headers: defaultHeaders,
                                         encoding: JSONEncoding.default,
                                         parameters: parameters))
    }
}

extension CommunicationManager: RegistrationCommunication {
    func register(email: String, password: String) async throws -> Tokens {
        let endpoint = Constants.RequestEndpoint.registration
        let parameters: Parameters = ["email": email.lowercased(),
                                      "password": password]

        return try await execute(Request(endpoint,
                                         headers: defaultHeaders,
                                         encoding: JSONEncoding.default,
                                         parameters: parameters))
    }
}

extension CommunicationManager: GoogleAuthCommunication {
    func googleAuth(token: String) async throws -> Tokens {
        let endpoint = Constants.RequestEndpoint.googleAuth
        let parameters: Parameters = ["token": token]

        return try await execute(Request(endpoint,
                                         headers: defaultHeaders,
                                         encoding: JSONEncoding.default,
                                         parameters: parameters))
    }
}

extension CommunicationManager: AuthMeCommunication {
    func getMyProfile() async throws -> User {
        let endpoint = Constants.RequestEndpoint.getMyProfile

        return try await execute(Request(endpoint,
                                         headers: defaultHeaders))
    }
}

extension CommunicationManager: CategoriesCommunication {
    func loadCategories() async throws -> [Category] {
        let endpoint = Constants.RequestEndpoint.getCategories

        return try await execute(Request(endpoint,
                                         headers: defaultHeaders))
    }
}

extension CommunicationManager: ReportIssueCommunication {
    func reportAnIssue(report: ReportBody) async throws -> ReportResponse {
        let endpoint = Constants.RequestEndpoint.reportAnIssue
        let headers: HTTPHeaders = defaultHeaders

        let response = await sessionManager.upload(
            multipartFormData: { multipartFormData in
                if let latData = "\(report.lat)".data(using: .utf8) {
                    multipartFormData.append(latData, withName: "lat")
                }
                if let lonData = "\(report.lon)".data(using: .utf8) {
                    multipartFormData.append(lonData, withName: "lon")
                }
                if let typeIdData = "\(report.typeId)".data(using: .utf8) {
                    multipartFormData.append(typeIdData, withName: "typeId")
                }
                if let description = report.description,
                   let descriptionData = description.data(using: .utf8) {
                    multipartFormData.append(descriptionData, withName: "description")
                }
                if let address = report.address,
                   let addressData = address.data(using: .utf8) {
                    multipartFormData.append(addressData, withName: "address")
                }

                if let file = report.file,
                   let imageData = file.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData,
                                             withName: "file",
                                             fileName: "report.jpg",
                                             mimeType: "image/jpeg")
                }
            },
            to: endpoint.url,
            method: .post,
            headers: headers
        )
        .redirect(using: .follow)
        .validate()
        .cURLDescription { description in
            print("description: \(description)")
        }
        .serializingDecodable(ReportResponse.self)
        .response

        if let error = response.error {
            throw error
        }
        return try response.result.get()
    }
}

extension CommunicationManager: PushTokenCommunication {
    func postPushToken(token: String) async throws -> EmptyResponse {
        let endpoint = Constants.RequestEndpoint.pushToken
        let parameters: Parameters = ["pushToken": token]

        return try await execute(Request(endpoint,
                                         headers: defaultHeaders,
                                         encoding: JSONEncoding.default,
                                         parameters: parameters))
    }
}

extension CommunicationManager: GetAllReportsCommunication {
    func getAllReports(report: ReportGetBody) async throws -> [ReportResponse] {
        let endpoint = Constants.RequestEndpoint.getIssues
        let headers: HTTPHeaders = defaultHeaders

        var parameters: Parameters = [
            "lat": report.lat,
            "lon": report.lon,
            "radius": report.radius,
        ]

        if let categoryId = report.categoryId {
            parameters["categoryId"] = categoryId
        }

        if let sort = report.sort {
            parameters["sort"] = sort
        }

        if let selff = report.selff {
            parameters["self"] = selff
        }

        if let resolvedByMe = report.resolvedByMe {
            parameters["resolvedByMe"] = resolvedByMe
        }

        return try await execute(
            Request(
                endpoint,
                headers: headers,
                encoding: URLEncoding.default,
                parameters: parameters
            )
        )
    }
}

extension CommunicationManager: UpdateIssueStatusCommunication {
    func updateIssueStatus(reportId: Int, status: ReportStatus) async throws -> EmptyResponse {
        let endpoint = Constants.RequestEndpoint.updateIssueStatus
        let parameters: Parameters = ["id": reportId,
                                      "status": status.rawValue]

        return try await execute(Request(endpoint,
                                         headers: defaultHeaders,
                                         encoding: JSONEncoding.default,
                                         parameters: parameters))
    }
}

extension CommunicationManager: ContinueAsGuestCommunication {
    func continueAsGuest() async throws -> Tokens {
        let endpoint = Constants.RequestEndpoint.continueAsGuest

        return try await execute(Request(endpoint,
                                         headers: defaultHeaders))
    }
}

extension CommunicationManager: GetAllActiveReportsCommunication {
    func getActiveIssues() async throws -> [ReportResponse] {
        let endpoint = Constants.RequestEndpoint.getIssuesActive
        let headers: HTTPHeaders = defaultHeaders

        return try await execute(Request(
            endpoint,
            headers: headers))
    }
}

extension CommunicationManager: GetAllResolvedReportsCommunication {
    func getResolvedIssues() async throws -> [ReportResponse] {
        let endpoint = Constants.RequestEndpoint.getIssuesResolved
        let headers: HTTPHeaders = defaultHeaders

        return try await execute(Request(
            endpoint,
            headers: headers))
    }
}

extension CommunicationManager: GetTitleMappingsCommunication {
    func getTitleMappings() async throws -> [TitleMapping] {
        let endpoint = Constants.RequestEndpoint.getTitleMappings
        let headers: HTTPHeaders = defaultHeaders

        return try await execute(Request(
            endpoint,
            headers: headers))
    }
}
