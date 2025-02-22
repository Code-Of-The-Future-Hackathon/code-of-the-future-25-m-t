//
//  CategoriesViewModel.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import Foundation

typealias IssueTypeEvent = (IssueType) -> Void

class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var requestErrorMessage = ""
    @Published var didFailFetchingCategories: Bool = false

    let communication: CategoriesCommunication
    let proccedToReport: IssueTypeEvent

    init(communication: CategoriesCommunication, proccedToReport: @escaping IssueTypeEvent) {
        self.communication = communication
        self.proccedToReport = proccedToReport

        loadCategories()
    }

    private func loadCategories() {
        Task { @MainActor in
            do {
                let loadedCategories = try await communication.loadCategories()

                categories = loadedCategories
            } catch {
                didFailFetchingCategories = true
                requestErrorMessage = error.customErrorMessage("Could not fetch categories.")
            }
        }
    }
}
