//
//  ProfileCoordinator.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

class ProfileCoordinator: Coordinator, ObservableObject {
    var childCoordinators = [Coordinator]()

    @Published var path = [ProfileDestination]()
    @Published var hideTabBar = false

    var initialDestination: ProfileDestination
    var logout: Event?

    init() {
        let profileViewModel = ProfileViewModel()
        initialDestination = .profile(viewModel: profileViewModel)
    }

    @ViewBuilder
    func start() -> AnyView {
        AnyView(ProfileCoordinatorView(coordinator: self))
    }

    func removeLastPath() {
        path.removeLast()
        if path.isEmpty {
            hideTabBar = false
        }
    }

    func removeAllPath() {
        path.removeAll()
        hideTabBar = false
    }
}
