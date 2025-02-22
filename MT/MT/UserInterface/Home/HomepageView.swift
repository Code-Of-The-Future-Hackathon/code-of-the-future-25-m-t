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
        ZStack(alignment: .bottom) {
//            VStack {
//                VStack {
//                    Text("Visible Width: \(String(format: "%.2f", viewModel.visibleWidthKm)) km")
//                    Text("Visible Height: \(String(format: "%.2f", viewModel.visibleHeightKm)) km")
//                    Text("Top-Left: \(viewModel.topLeftCoordinate.latitude), \(viewModel.topLeftCoordinate.longitude)")
//                    Text("Bottom-Right: \(viewModel.bottomRightCoordinate.latitude), \(viewModel.bottomRightCoordinate.longitude)")
//                    Text("My Location: \(viewModel.myAddress)")
//                    Text("Top-Left Address: \(viewModel.topLeftAddress)")
//                    Text("Bottom-Right Address: \(viewModel.bottomRightAddress)")
//                    Text("Current Location: \(viewModel.myLocationAddress)")
//
//                    Button(action: {
//                        showCategoriesSheet.toggle()
//                    }) {
//                        HStack {
//                            Image(systemName: "list.bullet")
//                            Text("Show Categories")
//                                .font(.headline)
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                    }
//                }
//                .padding()
//                .background(Color.white.opacity(0.8))
//                .cornerRadius(10)
//                .padding()

                MapView(
                    pointers: viewModel.pointers,
                    onMarkerTap: { report in
                        viewModel.openReportDetail?(report)
                    },
                    region: $region,
                    visibleWidthKm: $viewModel.visibleWidthKm,
                    visibleHeightKm: $viewModel.visibleHeightKm,
                    topLeftCoordinate: $viewModel.topLeftCoordinate,
                    bottomRightCoordinate: $viewModel.bottomRightCoordinate
                )
                .onAppear {
                    viewModel.fetchCurrentLocation()
                }
                .onChange(of: region.center.latitude) {
                    viewModel.updateVisibleArea(region: region)
                }
                .onChange(of: region.center.longitude) {
                    viewModel.updateVisibleArea(region: region)
                }
                .onChange(of: region.span.latitudeDelta) {
                    viewModel.updateVisibleArea(region: region)
                }

            HStack(spacing: 16) {
                Button(action: {
                    // showCategoriesSheet.toggle()
                }) {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(.blue)
                        .padding(12)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .frame(width: 50, height: 50)

                Spacer()

                Button(action: {
                    showCategoriesSheet.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.blue)
                        .padding(12)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .frame(width: 50, height: 50)
            }
            .padding(.vertical, 28)
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
        .sheet(isPresented: $showCategoriesSheet) {
            CategoriesView(
                viewModel: CategoriesViewModel(
                    communication: viewModel.communication,
                    proccedToReport: { issueType in
                        DispatchQueue.main.async {
                            viewModel.reportIssue(issueType: issueType)

                            showCategoriesSheet = false
                        }
                    }
                )
            )
        }
    }
}

//#Preview {
//    HomepageView(viewModel: HomepageViewModel(communication: MockCategoriesCommunication()))
//}
