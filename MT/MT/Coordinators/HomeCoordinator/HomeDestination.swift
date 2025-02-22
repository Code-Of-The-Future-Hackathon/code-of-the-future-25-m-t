//
//  HomeDestination.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

enum HomeDestination {
    case main(viewModel: HomepageViewModel)
    case reportProblem(viewModel: ReportProblemViewModel)
    case reportsList(viewModel: RepostsListViewModel)
}

extension HomeDestination: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }

    static func == (lhs: HomeDestination, rhs: HomeDestination) -> Bool {
        switch (lhs, rhs) {
        case let (.main(lhsVM), .main(rhsVM)):
            return lhsVM === rhsVM
        case let (.reportProblem(lhsVM), .reportProblem(rhsVM)):
            return lhsVM === rhsVM
        case let (.reportsList(lhsVM), .reportsList(rhsVM)):
            return lhsVM === rhsVM
        default:
            return false
        }
    }
}

extension HomeDestination: View {
    var body: some View {
        switch self {
        case let .main(viewModel):
            HomepageView(viewModel: viewModel)
        case let .reportProblem(viewModel):
            ReportProblemView(viewModel: viewModel)
        case let .reportsList(viewModel):
            RepostsListView(viewModel: viewModel)
        }
    }
}
