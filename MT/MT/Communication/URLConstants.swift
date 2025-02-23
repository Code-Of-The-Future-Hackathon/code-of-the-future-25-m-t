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
        case appleAuth
        case refreshToken
        case pushToken
        case getCategories
        case reportAnIssue
        case getIssues
        case getIssuesActive
        case getIssuesResolved
        case updateIssueStatus
        case continueAsGuest
        case getTitleMappings

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
        case .appleAuth:
            return Self.serverURL + "/auth/apple-login"
        case .pushToken:
            return Self.serverURL + "/users/push-token"
        case .refreshToken:
            return Self.serverURL + "/auth/refresh"
        case .getCategories:
            return Self.serverURL + "/categories"
        case .reportAnIssue, .getIssues:
            return Self.serverURL + "/issues"
        case .updateIssueStatus:
            return Self.serverURL + "/issues/status"
        case .continueAsGuest:
            return Self.serverURL + "/auth/register-guest"
        case .getIssuesActive:
            return Self.serverURL + "/issues/active/self"
        case .getIssuesResolved:
            return Self.serverURL + "/issues/resolved/admin"
        case .getTitleMappings:
            return Self.serverURL + "/users/title-mappings"
        }
    }
}

extension Constants.RequestEndpoint: HTTPMethodConvertible {
    var method: HTTPMethod {
        switch self {
        case .login, .registration, .googleAuth, .refreshToken, .reportAnIssue, .continueAsGuest, .appleAuth:
            return .post
        case .getMyProfile, .getCategories, .getIssues, .getIssuesActive, .getIssuesResolved, .getTitleMappings:
            return .get
        case .pushToken, .updateIssueStatus:
            return .patch
        }
    }
}
