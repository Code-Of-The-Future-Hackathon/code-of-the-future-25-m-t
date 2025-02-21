//
//  Categories.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import Foundation

struct Category: Decodable, Identifiable {
    let id: Int
    let title: String
    let icon: String
    let types: [IssueType]
}

struct IssueType: Decodable, Identifiable {
    let id: Int
    let title: String
}
