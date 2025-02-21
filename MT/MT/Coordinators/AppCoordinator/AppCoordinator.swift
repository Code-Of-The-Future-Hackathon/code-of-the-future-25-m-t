//
//  AppCoordinator.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Combine
import SwiftUI
import KeychainSwift

typealias Event = () -> Void
typealias Communication = LoginCommunication & RegistrationCommunication & AuthMeCommunication & GoogleAuthCommunication
    & CategoriesCommunication

class AppCoordinator: Coordinator, ObservableObject {
    var childCoordinators = [Coordinator]()
    var communicationManager: Communication
    private let keychain = KeychainSwift()
    private var userRepository: UserRepository

    @Published var appState: AppDestination

    @MainActor
    init() {
        if UserDefaults.isFirstLaunch() {
            keychain.clear()
        }
        appState = .loading
        userRepository = UserRepository(keychain: keychain)
        let oauthAdapter = OAuthAdapter(userRepository: userRepository)
        communicationManager = CommunicationManager(requestAdapter: oauthAdapter, requestRetrier: oauthAdapter)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }

            self.startMainAppFlow()
        }
    }

    func start() -> AnyView {
        AnyView(AppCoordinatorView(coordinator: self))
    }

    private func startMainAppFlow() {
        if let profile = userRepository.user, userRepository.authToken != nil {
            let tabBarCoordinator = TabBarCoordinator(user: profile,
                                                      communicationManager: communicationManager)
            appState = .tabBar(tabBarCoordinator)
            tabBarCoordinator.logout = handleLoginState
        } else {
            let coordinator = LoginCoordinator(communication: communicationManager, userRepository: userRepository)
            coordinator.successfulLogin = handleLoginSuccess
            appState = .login(coordinator)
        }
    }

    private func handleLoginSuccess() {
        startMainAppFlow()
    }

    private func handleLoginState() {
        removeDataAfterLogout()
        let coordinator = LoginCoordinator(communication: communicationManager, userRepository: userRepository)
        appState = .login(coordinator)
        Task { @MainActor in
            coordinator.successfulLogin = handleLoginSuccess
        }
    }

    private func removeDataAfterLogout() {
        userRepository.logout()
    }
}
