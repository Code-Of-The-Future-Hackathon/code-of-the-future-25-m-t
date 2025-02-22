//
//  RepostsListViewModel.swift
//  MT
//
//  Created by Mihail Kolev on 22/02/2025.
//

import Foundation
import MapKit

typealias ReportsListCommunication = CategoriesCommunication & HomeCommunication

class RepostsListViewModel: ObservableObject {
    let communication: ReportsListCommunication

    var visibleHeightKm: Double
    var currentRegion: MKCoordinateRegion

    @Published var reports: [ReportResponse] = []
    @Published var categories: [Category] = []

    var openReportProblem: ReportProblemEvent?

    @Published var selectedCategory: Int?

    let goBack: Event

    init(communication: ReportsListCommunication, visibleHeightKm: Double, currentRegion: MKCoordinateRegion, goBack: @escaping Event) {
        self.communication = communication
        self.visibleHeightKm = visibleHeightKm
        self.currentRegion = currentRegion
        self.goBack = goBack

        loadCategories()
    }

    func getAllReports() {
        Task { @MainActor in
            do {
                let loadedReports = try await communication.getAllReports(report: ReportGetBody(sort: true,
                                                                                                categoryId: selectedCategory,
                                                                                                lat: currentRegion.center.latitude,
                                                                                                lon: currentRegion.center.longitude,
                                                                                                radius: visibleHeightKm * 1000))

                reports = loadedReports
                print("### Loaded reports: \(loadedReports)")
            } catch { }
        }
    }

    private func loadCategories() {
        Task { @MainActor in
            do {
                let loadedCategories = try await communication.loadCategories()

                categories = loadedCategories
            } catch { }
        }
    }
}
