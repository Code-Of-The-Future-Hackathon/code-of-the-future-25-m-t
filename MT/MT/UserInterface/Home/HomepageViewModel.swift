//
//  HomepageViewModel.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI
import CoreLocation
import MapKit

class HomepageViewModel: ObservableObject {
    let communication: CategoriesCommunication
    @Published var visibleWidthKm: Double = 0.0
    @Published var visibleHeightKm: Double = 0.0
    @Published var topLeftCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var bottomRightCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    func updateVisibleArea(region: MKCoordinateRegion) {
        let centerLatitude = region.center.latitude
        
        let metersPerDegreeLongitude = cos(centerLatitude * .pi / 180) * 111320
        visibleWidthKm = region.span.longitudeDelta * metersPerDegreeLongitude / 1000
        
        visibleHeightKm = region.span.latitudeDelta * 111
        
        topLeftCoordinate = CLLocationCoordinate2D(
            latitude: region.center.latitude + (region.span.latitudeDelta / 2),
            longitude: region.center.longitude - (region.span.longitudeDelta / 2)
        )
        
        bottomRightCoordinate = CLLocationCoordinate2D(
            latitude: region.center.latitude - (region.span.latitudeDelta / 2),
            longitude: region.center.longitude + (region.span.longitudeDelta / 2)
        )
    }

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
