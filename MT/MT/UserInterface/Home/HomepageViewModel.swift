//
//  HomepageViewModel.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import Foundation

class HomepageViewModel: ObservableObject {
    let communication: CategoriesCommunication

    init(communication: CategoriesCommunication) {
        self.communication = communication
    }
}

class MockCategoriesCommunication: CategoriesCommunication {
    func loadCategories() async throws -> [Category] {
        return [
            Category(id: 1, title: "Roads & Sidewalks", icon: "🛣️", types: [IssueType(id: 1, title: "Potholes")]),
            Category(id: 2, title: "Streetlights & Electrical", icon: "💡", types: [IssueType(id: 6, title: "Streetlight Malfunctions")])
        ]
    }
}
