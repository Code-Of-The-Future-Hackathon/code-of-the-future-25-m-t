//
//  AppCoordinatorView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

struct AppCoordinatorView: View {
    @StateObject var coordinator: AppCoordinator

    var body: some View {
        coordinator.appState
    }
}
