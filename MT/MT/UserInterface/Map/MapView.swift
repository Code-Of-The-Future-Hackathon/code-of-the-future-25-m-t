//
//  MapView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    @Binding var region: MKCoordinateRegion
    @Binding var visibleWidthKm: Double
    @Binding var visibleHeightKm: Double
    @Binding var topLeftCoordinate: CLLocationCoordinate2D
    @Binding var bottomRightCoordinate: CLLocationCoordinate2D

    @State private var userLocationSet = false

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .ignoresSafeArea()
            .onAppear {
                locationManager.requestLocation()
            }
            .onReceive(locationManager.$location) { newLocation in
                if let newLocation = newLocation, !userLocationSet {
                    region.center = newLocation
                    userLocationSet = true
                }
            }
    }
}

#Preview {
    MapView(
        region: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
        visibleWidthKm: .constant(0.0),
        visibleHeightKm: .constant(0.0),
        topLeftCoordinate: .constant(CLLocationCoordinate2D(latitude: 0, longitude: 0)),
        bottomRightCoordinate: .constant(CLLocationCoordinate2D(latitude: 0, longitude: 0))
    )
}
