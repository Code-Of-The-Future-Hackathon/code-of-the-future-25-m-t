//
//  HomepageView.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI
import MapKit

struct HomepageView: View {
    @StateObject var viewModel: HomepageViewModel = HomepageViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack {
            VStack {
                Text("Visible Width: \(String(format: "%.2f", viewModel.visibleWidthKm)) km")
                Text("Visible Height: \(String(format: "%.2f", viewModel.visibleHeightKm)) km")
                Text("Top-Left: \(viewModel.topLeftCoordinate.latitude), \(viewModel.topLeftCoordinate.longitude)")
                Text("Bottom-Right: \(viewModel.bottomRightCoordinate.latitude), \(viewModel.bottomRightCoordinate.longitude)")
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .padding()

            MapView(
                region: $region,
                visibleWidthKm: $viewModel.visibleWidthKm,
                visibleHeightKm: $viewModel.visibleHeightKm,
                topLeftCoordinate: $viewModel.topLeftCoordinate,
                bottomRightCoordinate: $viewModel.bottomRightCoordinate
            )
            .onChange(of: region.center.latitude) {
                viewModel.updateVisibleArea(region: region)
            }
            .onChange(of: region.center.longitude) {
                viewModel.updateVisibleArea(region: region)
            }
            .onChange(of: region.span.latitudeDelta) {
                viewModel.updateVisibleArea(region: region)
            }
        }
    }
}

#Preview {
    HomepageView()
}
