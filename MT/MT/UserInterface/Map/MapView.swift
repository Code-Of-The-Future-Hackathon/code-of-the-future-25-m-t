//
//  MapView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import CoreLocation
import MapKit
import SwiftUI

typealias ReportResponseEvent = (ReportResponse) -> Void

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager

    var pointers: [ReportResponse]
    var onMarkerTap: ReportResponseEvent

    @Binding var region: MKCoordinateRegion
    @Binding var visibleWidthKm: Double
    @Binding var visibleHeightKm: Double
    @Binding var topLeftCoordinate: CLLocationCoordinate2D
    @Binding var bottomRightCoordinate: CLLocationCoordinate2D

    @State private var userLocationSet = false

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: pointers) { pointer in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: pointer.lat, longitude: pointer.lon)) {
                ZStack(alignment: .top) {
                    if let icon = pointer.type.category?.icon {
                        Image(.mapMarkerIcon)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.red)
                        TypographyText(text: icon, typography: .body2)
                            .padding(.top, 12)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 26, height: 26)
                                    .padding(.top, 16)
                            }
                    } else {
                        Image(.mapMarker)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.red)
                    }
                }
                .onTapGesture {
                    onMarkerTap(pointer)
                }
            }
        }
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
        .mapControls {
            MapUserLocationButton()
        }
    }
}

#Preview {
    MapView(
        pointers: [],
        onMarkerTap: { _ in },
        region: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
        visibleWidthKm: .constant(0.0),
        visibleHeightKm: .constant(0.0),
        topLeftCoordinate: .constant(CLLocationCoordinate2D(latitude: 0, longitude: 0)),
        bottomRightCoordinate: .constant(CLLocationCoordinate2D(latitude: 0, longitude: 0))
    )
}
