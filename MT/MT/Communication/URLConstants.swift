//
//  URLConstants.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Alamofire
import Foundation

protocol URLConvertible {
    var url: String { get }
}

protocol HTTPMethodConvertible {
    var method: HTTPMethod { get }
}

struct Constants { }

extension Constants {
    enum RequestEndpoint {
        case login
        case registration
        case getMyProfile
        case googleAuth
        case refreshToken
        case pushToken
        case getCategories
        case reportAnIssue
        case getIssues
        case continueAsGuest

        static var serverURL = "https://cotf.alexognyanov.xyz/api"
    }
}

extension Constants.RequestEndpoint: URLConvertible {
    var url: String {
        switch self {
        case .login:
            return Self.serverURL + "/auth/login"
        case  .registration:
            return Self.serverURL + "/auth/register"
        case .getMyProfile:
            return Self.serverURL + "/users/me"
        case .googleAuth:
            return Self.serverURL + "/auth/google-token-login"
        case .pushToken:
            return Self.serverURL + "/users/push-token"
        case .refreshToken:
            return Self.serverURL + "/auth/refresh"
        case .getCategories:
            return Self.serverURL + "/categories"
        case .reportAnIssue, .getIssues:
            return Self.serverURL + "/issues"
        case .continueAsGuest:
            return Self.serverURL + "/auth/register-guest"
        }
    }
}

extension Constants.RequestEndpoint: HTTPMethodConvertible {
    var method: HTTPMethod {
        switch self {
        case .login, .registration, .googleAuth, .refreshToken, .reportAnIssue, .continueAsGuest:
            return .post
        case .getMyProfile, .getCategories, .getIssues:
            return .get
        case .pushToken:
            return .patch
        }
    }
}
