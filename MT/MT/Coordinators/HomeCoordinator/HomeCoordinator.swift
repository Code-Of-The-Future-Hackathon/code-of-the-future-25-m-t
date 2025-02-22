//
//  HomeCoordinator.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

typealias HomeCommunication = CategoriesCommunication & ReportIssueCommunication & GetAllReportsCommunication

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

        homeViewModel.openReportProblem = navigateToReport
        homeViewModel.openReportDetail = { [weak self] report in
            self?.navigateToDetail(report: report)
        }

    }

    @ViewBuilder
    func start() -> AnyView {
        AnyView(HomeCoordinatorView(coordinator: self))
    }

    private func navigateToReport(issueType: IssueType, lat: Double, lon: Double, address: String? = nil) {
        print("✅ Processing SINGLE report for: \(issueType.title) | ID: \(issueType.id)")

        path.append(.reportProblem(viewModel: ReportProblemViewModel(communication: communication, lattitude: lat, longitude: lon, address: address, issueType: issueType, goBack: removeLastPath)))
    }

    private func navigateToDetail(report: ReportResponse) {
        let detailVM = ReportDetailViewModel(report: report, goBack: removeLastPath)
        path.append(.reportDetail(viewModel: detailVM))
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
