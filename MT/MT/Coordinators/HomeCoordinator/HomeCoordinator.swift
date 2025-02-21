//
//  HomeCoordinator.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

class HomeCoordinator: Coordinator, ObservableObject {
    var childCoordinators = [Coordinator]()

    @Published var path = [HomeDestination]()
    @Published var hideTabBar = false

    var initialDestination: HomeDestination

    init() {
        let homeViewModel = HomepageViewModel()
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
