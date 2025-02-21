//
//  CategoriesViewModel.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import Foundation

class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var requestErrorMessage = ""
    @Published var didFailFetchingCategories: Bool = false

    let communication: CategoriesCommunication

    init(communication: CategoriesCommunication) {
        self.communication = communication

        loadCategories()
    }

    private func loadCategories() {
        Task { @MainActor in
            do {
                let loadedCategories = try await communication.loadCategories()

                categories = loadedCategories
            } catch {
                didFailFetchingCategories = true
                requestErrorMessage = error.customErrorMessage("Could not login this user")
            }
        }

    }
}
