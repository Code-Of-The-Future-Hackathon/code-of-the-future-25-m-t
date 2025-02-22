//
//  Categories.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import Foundation

struct Category: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let icon: String
    let types: [IssueType]?
    let supportsImages: Bool?
}

struct IssueType: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
}
