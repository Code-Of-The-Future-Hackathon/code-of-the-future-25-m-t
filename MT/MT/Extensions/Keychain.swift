//
//  Keychain.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Foundation
import KeychainSwift

extension KeychainSwift {
    enum KeychainConstants: String {
        case token
        case profile
    }

    var authToken: Tokens? {
        get {
            guard let encodedValue = getData(KeychainConstants.token.rawValue),
                  let tokenInfo = try? JSONDecoder().decode(Tokens.self, from: encodedValue) else { return nil }

            return tokenInfo
        }
        set(value) {
            guard let encodedValue = try? JSONEncoder().encode(value) else {
                delete(KeychainConstants.token.rawValue)
                return
            }
            set(encodedValue, forKey: KeychainConstants.token.rawValue, withAccess: .accessibleAfterFirstUnlockThisDeviceOnly)
        }
    }

    var profile: User? {
        get {
            guard let encodedValue = getData(KeychainConstants.profile.rawValue),
                  let tokenInfo = try? JSONDecoder().decode(User.self, from: encodedValue) else { return nil }

            return tokenInfo
        }
        set(value) {
            guard let encodedValue = try? JSONEncoder().encode(value) else {
                delete(KeychainConstants.profile.rawValue)
                return
            }
            set(encodedValue, forKey: KeychainConstants.profile.rawValue, withAccess: .accessibleAfterFirstUnlockThisDeviceOnly)
        }
    }

    func logout() {
        self.authToken = nil
        self.profile = nil
    }
}
