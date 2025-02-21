//
//  LoginDestination.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

enum LoginDestination {
    case signIn(viewModel: SignInViewModel)
    case signUp(viewModel: SignUpViewModel)
}

extension LoginDestination: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }

    static func == (lhs: LoginDestination, rhs: LoginDestination) -> Bool {
        switch (lhs, rhs) {
        case let (.signIn(lhsVM), .signIn(rhsVM)):
            return lhsVM === rhsVM
        case let (.signUp(lhsViewModel), .signUp(rhsViewModel)):
            return lhsViewModel === rhsViewModel
        default:
            assertionFailure("Unhandled case in LoginDestination equality")
            return false
        }
    }
}

extension LoginDestination: View {
    var body: some View {
        switch self {
        case let .signIn(viewModel):
            SignInView(viewModel: viewModel)
        case let .signUp(viewModel):
            SignUpView(viewModel: viewModel)
        }
    }
}
