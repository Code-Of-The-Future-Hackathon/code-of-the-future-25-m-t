//
//  TabBarCoordinator.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

class TabBarCoordinator: Coordinator, ObservableObject {
    var childCoordinators = [Coordinator]()

    @Published var selectedDestination: Int = 0
    @Published var destinations: [TabBarDestination] = []
    @Published var showSideMenu = false

    var communicationManager: Communication
    var user: User

    var logout: Event?

    private lazy var homeCoordinator: HomeCoordinator = {
        let coordinator = HomeCoordinator(communication: communicationManager)

        return coordinator
    }()
    private lazy var profileCoordinator: ProfileCoordinator = {
        let coordinator = ProfileCoordinator(user: user, communication: communicationManager)
        coordinator.logout = { [weak self] in
            self?.logout?()
        }

        return coordinator
    }()

    init(user: User, communicationManager: Communication) {
        self.user = user
        self.communicationManager = communicationManager
        let homeDestination = TabBarDestination.home(homeCoordinator)
        let profileDestination = TabBarDestination.profile(profileCoordinator)
        destinations = [homeDestination, profileDestination]
    }

    @ViewBuilder
    func start() -> AnyView {
        AnyView(TabBarCoordinatorView(coordinator: self))
    }
}
