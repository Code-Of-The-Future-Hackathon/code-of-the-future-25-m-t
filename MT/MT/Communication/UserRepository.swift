//
//  UserRepository.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Foundation
import Combine
import KeychainSwift

class UserRepository: ObservableObject {
    @Published var user: User?
    @Published var authToken: Tokens?
    var logout: Event

    private var cancellables = Set<AnyCancellable>()

    init(keychain: KeychainSwift) {
        user = keychain.profile
        authToken = keychain.authToken
        logout = keychain.logout
        $user
            .dropFirst()
            .sink { newUser in
                keychain.profile = newUser
            }
            .store(in: &cancellables)
        $authToken
            .dropFirst()
            .sink { newTokens in
                keychain.authToken = newTokens
            }
            .store(in: &cancellables)
    }
}
