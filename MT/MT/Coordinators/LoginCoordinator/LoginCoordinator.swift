//
//  LoginCoordinator.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Foundation
import SwiftUI

typealias SignCommunication = LoginCommunication & RegistrationCommunication & AuthMeCommunication & GoogleAuthCommunication

class LoginCoordinator: Coordinator, ObservableObject {
    var childCoordinators = [Coordinator]()

    @Published var path = [LoginDestination]()
    var initialDestination: LoginDestination
    var communication: SignCommunication
    var userRepository: UserRepository

    var successfulLogin: Event?

    init(communication: SignCommunication, userRepository: UserRepository) {
        self.communication = communication
        self.userRepository = userRepository

        let signInViewModel = SignInViewModel()
        initialDestination = .signIn(viewModel: signInViewModel)

        signInViewModel.loginSuccessful = { [weak self] in
            self?.successfulLogin?()
        }
        signInViewModel.goToSignUp = showSignUp
    }


    func showSignUp() {
        let viewModel = SignUpViewModel()
        viewModel.registerSuccessful = { [weak self] in
            self?.successfulLogin?()
        }
        path.append(.signUp(viewModel: viewModel))
    }

    @ViewBuilder
    func start() -> AnyView {
        AnyView(LoginCoordinatorView(coordinator: self))
    }
}
