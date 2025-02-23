//
//  ProfileCoordinator.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

typealias ProfileCoordinatorCommunication = GetAllActiveReportsCommunication & GetAllResolvedReportsCommunication & AuthMeCommunication

class ProfileCoordinator: Coordinator, ObservableObject {
    var childCoordinators = [Coordinator]()

    @Published var path = [ProfileDestination]()
    @Published var hideTabBar = false

    var initialDestination: ProfileDestination
    var user: User
    var communication: ProfileCoordinatorCommunication

    var logout: Event?

    init(user: User, communication: ProfileCoordinatorCommunication) {
        self.user = user
        self.communication = communication
        let profileViewModel = ProfileViewModel(communication: communication, user: user)
        initialDestination = .profile(viewModel: profileViewModel)

        profileViewModel.logoutClicked = { [weak self] in
            self?.logout?()
        }
    }

    @ViewBuilder
    func start() -> AnyView {
        AnyView(ProfileCoordinatorView(coordinator: self))
    }

    func removeLastPath() {
        if !path.isEmpty {
            path.removeLast()
        }
        if path.isEmpty {
            hideTabBar = false
        }
    }

    func removeAllPath() {
        path.removeAll()
        hideTabBar = false
    }
}
