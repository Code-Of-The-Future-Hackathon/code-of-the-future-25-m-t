//
//  HomepageView.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import MapKit
import SwiftUI

struct HomepageView: View {
    @StateObject var viewModel: HomepageViewModel
    @State private var showCategoriesSheet = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("Visible Width: \(String(format: "%.2f", viewModel.visibleWidthKm)) km")
                    Text("Visible Height: \(String(format: "%.2f", viewModel.visibleHeightKm)) km")
                    Text("Top-Left: \(viewModel.topLeftCoordinate.latitude), \(viewModel.topLeftCoordinate.longitude)")
                    Text("Bottom-Right: \(viewModel.bottomRightCoordinate.latitude), \(viewModel.bottomRightCoordinate.longitude)")
                    Button(action: {
                        showCategoriesSheet.toggle()
                    }) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Show Categories")
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
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
        .sheet(isPresented: $showCategoriesSheet) {
            CategoriesView(viewModel: CategoriesViewModel(communication: viewModel.communication))
        }
    }
}

#Preview {
    HomepageView(viewModel: HomepageViewModel(communication: MockCategoriesCommunication()))
}
