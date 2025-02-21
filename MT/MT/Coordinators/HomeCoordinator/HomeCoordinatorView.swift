//
//  HomeCoordinatorView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

struct HomeCoordinatorView: View {
    @StateObject var coordinator: HomeCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.initialDestination
                .navigationDestination(for: HomeDestination.self) { $0 }
                .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar(coordinator.hideTabBar ? .hidden : .visible, for: .tabBar)
        .animation(.linear(duration: 0.5), value: coordinator.hideTabBar)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
