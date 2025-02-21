//
//  Authentication.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Foundation

struct EmptyResponse: Codable { }

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let googleId: String?
    let firstName: String?
    let lastName: String?
    let role: String
    let createdAt: String
    let updatedAt: String
}

struct Tokens: Codable {
    let accessToken: String
    let refreshToken: String
}
