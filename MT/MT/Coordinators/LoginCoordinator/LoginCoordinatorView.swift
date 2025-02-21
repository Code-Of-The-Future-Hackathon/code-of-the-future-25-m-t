//
//  LoginCoordinatorView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

struct LoginCoordinatorView: View {
    @StateObject var coordinator: LoginCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.initialDestination
                .navigationDestination(for: LoginDestination.self) { $0 }
                .navigationBarTitleDisplayMode(.automatic)
        }
    }
}
