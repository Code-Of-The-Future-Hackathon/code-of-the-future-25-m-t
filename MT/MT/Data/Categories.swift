//
//  Categories.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import Foundation

struct Category: Codable, Identifiable {
    let id: Int
    let title: String
    let icon: String
    let types: [IssueType]?
    let supportsImages: Bool?
}

struct IssueType: Codable, Identifiable {
    let id: Int
    let title: String
}
