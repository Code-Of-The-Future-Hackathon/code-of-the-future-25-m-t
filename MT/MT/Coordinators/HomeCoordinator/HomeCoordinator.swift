//
//  HomeCoordinator.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

typealias HomeCommunication = CategoriesCommunication

class HomeCoordinator: Coordinator, ObservableObject {
    var childCoordinators = [Coordinator]()

    @Published var path = [HomeDestination]()
    @Published var hideTabBar = false

    var communication: HomeCommunication

    var initialDestination: HomeDestination

    init(communication: HomeCommunication) {
        self.communication = communication

        let homeViewModel = HomepageViewModel(communication: communication)

        initialDestination = .main(viewModel: homeViewModel)
    }

    @ViewBuilder
    func start() -> AnyView {
        AnyView(HomeCoordinatorView(coordinator: self))
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
