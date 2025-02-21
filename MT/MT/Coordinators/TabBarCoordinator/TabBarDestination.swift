//
//  TabBarDestination.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

enum TabBarDestination: Identifiable {
    var id: String {
        switch self {
        case .home:
            "home"
        case .profile:
            "profile"
        }
    }
    
    case home(HomeCoordinator)
    case profile(ProfileCoordinator)
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .profile:
            return "person"
        }
    }

    var iconSelected: String {
        switch self {
        case .home:
            return "house.fill"
        case .profile:
            return "person.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .profile:
            return "Profile"
        }
    }
}

extension TabBarDestination: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }

    static func == (lhsCoord: TabBarDestination, rhs: TabBarDestination) -> Bool {
        switch (lhsCoord, rhs) {
        case let (.home(lhsCoord), .home(rhsCoord)):
            return lhsCoord === rhsCoord
        case let (.profile(lhsCoord), .profile(rhsCoord)):
            return lhsCoord === rhsCoord
        default:
            assertionFailure("Unhandled case in TabBarDestination equality")
            return false
        }
    }
}

extension TabBarDestination: View {
    var body: some View {
        switch self {
        case let .home(coordinator):
            coordinator.start()
        case let .profile(coordinator):
            coordinator.start()
        }
    }
}
