//
//  ProfileDestination.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

enum ProfileDestination {
    case profile(viewModel: ProfileViewModel)
    case achievements(viewModel: AchievementsViewModel)
}

extension ProfileDestination: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }

    static func == (lhs: ProfileDestination, rhs: ProfileDestination) -> Bool {
        switch (lhs, rhs) {
        case let (.profile(lhsVM), .profile(rhsVM)):
            return lhsVM === rhsVM
        case let (.achievements(lhsVM), .achievements(rhsVM)):
            return lhsVM === rhsVM
        default:
            return false
        }
    }
}

extension ProfileDestination: View {
    var body: some View {
        switch self {
        case let .profile(viewModel):
            ProfileView(viewModel: viewModel)
        case let .achievements(viewModel):
            AchievementsView(viewModel: viewModel)
        }
    }
}
