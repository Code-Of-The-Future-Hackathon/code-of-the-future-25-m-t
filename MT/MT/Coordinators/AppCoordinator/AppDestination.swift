//
//  AppDestination.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

enum AppDestination {
    case loading
    case login(LoginCoordinator)
    case tabBar(TabBarCoordinator)
}

extension AppDestination: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }

    static func == (lhs: AppDestination, rhs: AppDestination) -> Bool {
        switch (lhs, rhs) {
        case let (.login(lhsC), .login(rhsC)):
            return lhsC === rhsC
        case let (.tabBar(lhsC), .tabBar(rhsC)):
            return lhsC === rhsC
        default:
            return false
        }
    }
}

extension AppDestination: View {
    var body: some View {
        switch self {
        case .loading:
            Splash()
        case let .login(coordinator):
            coordinator.start()
        case let .tabBar(coordinator):
            coordinator.start()
        }
    }
}
