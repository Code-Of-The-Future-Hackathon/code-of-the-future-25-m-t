//
//  Report.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import Foundation

struct ReportResponse: Codable, Identifiable {
    let address: String?
    let description: String?
    let lat: Double
    let lon: Double
    let type: ReportType
    let user: ReportUser?
    let id: Int
    let createdAt: String
    let distance: Double?
    let issues: [Issue]?
    let status: String?

    struct ReportType: Codable {
        let id: Int
        let title: String?
        let category: Category?
    }

    struct ReportUser: Codable {
        let id: String
    }
}

struct Issue: Codable {
    let description: String?
    let address: String?
    let lat: Double
    let lon: Double
    let id: Int
    let createdAt: String
}

struct ReportBody: Codable {
    let description: String?
    let address: String?
    let lat: Double
    let lon: Double
    let typeId: Int

    init(description: String? = nil, address: String? = nil, lat: Double, lon: Double, typeId: Int) {
        self.description = description
        self.address = address
        self.lat = lat
        self.lon = lon
        self.typeId = typeId
    }
}

struct ReportGetBody: Codable {
    let sort: Bool?
    let categoryId: Int?
    let lat: Double
    let lon: Double
    let radius: Double

    init(sort: Bool? = false, categoryId: Int? = nil, lat: Double, lon: Double, radius: Double) {
        self.sort = sort
        self.categoryId = categoryId
        self.lat = lat
        self.lon = lon
        self.radius = radius
    }
}

