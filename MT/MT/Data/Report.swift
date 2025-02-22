//
//  Report.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import UIKit

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
    let file: FileResponse?
}

struct ReportBody: Codable {
    let description: String?
    let address: String?
    let lat: Double
    let lon: Double
    let typeId: Int
    let file: UIImage?

    enum CodingKeys: String, CodingKey {
        case description, address, lat, lon, typeId
    }

    init(description: String? = nil, address: String? = nil, lat: Double, lon: Double, typeId: Int, file: UIImage? = nil) {
        self.description = description
        self.address = address
        self.lat = lat
        self.lon = lon
        self.typeId = typeId
        self.file = file
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try container.encode(address, forKey: .address)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        try container.encode(typeId, forKey: .typeId)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.typeId = try container.decode(Int.self, forKey: .typeId)
        self.file = nil
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

