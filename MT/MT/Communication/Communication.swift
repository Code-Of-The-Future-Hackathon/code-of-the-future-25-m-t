//
//  Communication.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Foundation

protocol LoginCommunication {
    func login(email: String, password: String) async throws -> Tokens
}

protocol RegistrationCommunication {
    func register(email: String, password: String) async throws -> Tokens
}

protocol GoogleAuthCommunication {
    func googleAuth(token: String) async throws -> Tokens
}

protocol AuthMeCommunication {
    func getMyProfile() async throws -> User
}
