//
//  Report.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import Foundation

struct ReportResponse: Codable {
    let address: String?
    let description: String?
    let lat: Double
    let lon: Double
    let type: ReportType
    let user: ReportUser
    let id: Int
    let createdAt: String

    struct ReportType: Codable {
        let id: Int
    }

    struct ReportUser: Codable {
        let id: String
    }
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
