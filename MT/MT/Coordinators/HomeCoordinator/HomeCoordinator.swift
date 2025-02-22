//
//  HomeCoordinator.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI
import MapKit

typealias HomeCommunication = CategoriesCommunication & ReportIssueCommunication & GetAllReportsCommunication & UpdateIssueStatusCommunication

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
        homeViewModel.openReportsList = navigateToReportsList
    }

    @ViewBuilder
    func start() -> AnyView {
        AnyView(HomeCoordinatorView(coordinator: self))
    }

    private func navigateToReport(issueType: IssueType, supportsImages: Bool, lat: Double, lon: Double, address: String? = nil) {
        withAnimation {
            hideTabBar = true
        }

        path.append(.reportProblem(viewModel: ReportProblemViewModel(communication: communication, lattitude: lat, longitude: lon, address: address, issueType: issueType, supportsImages: supportsImages, goBack: removeLastPath)))
    }

    private func navigateToDetail(report: ReportResponse) {
        let detailVM = ReportDetailViewModel(report: report, communication: communication, goBack: removeLastPath)
        path.append(.reportDetail(viewModel: detailVM))

    }

    private func navigateToReportsList(currentRegion: MKCoordinateRegion, visibleHeightKm: Double) {
        hideTabBar = true

        let viewModel = RepostsListViewModel(communication: communication, visibleHeightKm: visibleHeightKm, currentRegion: currentRegion, goBack: removeLastPath)

        path.append(.reportsList(viewModel: viewModel))
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
