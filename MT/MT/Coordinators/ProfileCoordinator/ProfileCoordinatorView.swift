//
//  ProfileCoordinatorView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

struct ProfileCoordinatorView: View {
    @StateObject var coordinator: ProfileCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.initialDestination
                .navigationDestination(for: ProfileDestination.self) { $0 }
                .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar(coordinator.hideTabBar ? .hidden : .visible, for: .tabBar)
        .animation(.linear(duration: 0.5), value: coordinator.hideTabBar)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
