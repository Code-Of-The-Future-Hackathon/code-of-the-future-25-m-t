//
//  HomepageViewModel.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import CoreLocation
import MapKit
import SwiftUI

typealias ReportProblemEvent = (IssueType, Bool, Double, Double, String?) -> Void?
typealias ReportsListEvent = (MKCoordinateRegion, Double) -> Void?

class HomepageViewModel: ObservableObject {
    let communication: HomeCommunication

    @Published var visibleWidthKm: Double = 0.0
    @Published var visibleHeightKm: Double = 0.0
    @Published var topLeftCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var bottomRightCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    @Published var myAddress: String = ""
    @Published var topLeftAddress: String = ""
    @Published var bottomRightAddress: String = ""
    @Published var myLocationAddress: String = ""

    @Published var pointers: [ReportResponse] = []

    private var geocodeTimer: Timer?
    private let locationManager = CLLocationManager()

    var openReportProblem: ReportProblemEvent?
    var openReportDetail: ReportResponseEvent?
    var openReportsList: ReportsListEvent?

    @Published var categories: [Category] = []

    init(communication: HomeCommunication) {
        self.communication = communication

        fetchCurrentLocation()
        loadCategories()
    }

    func reportIssue(issueType: IssueType) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        if let category = categories.first(where: { $0.types?.contains(where: { $0.id == issueType.id }) ?? false }) {
            let supportsImages = category.supportsImages
            print("🚀 Reporting Issue in Category \(issueType.title) - supportsImages: \(supportsImages)")
            openReportProblem?(issueType, supportsImages, coordinate.latitude, coordinate.longitude, myAddress.isEmpty ? nil : myAddress)
        } else {
            print("🚀 Reporting Issue in Category \(issueType.title) - Category not found, defaulting supportsImages to true")
            openReportProblem?(issueType, true, coordinate.latitude, coordinate.longitude, myAddress.isEmpty ? nil : myAddress)
        }
    }

    private func loadCategories() {
        Task { @MainActor in
            do {
                let loadedCategories = try await communication.loadCategories()

                categories = loadedCategories
            } catch {
                print("Error loading categories: \(error.localizedDescription)")
            }
        }
    }

    func fetchCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        if let location = locationManager.location {
            reverseGeocode(coordinate: location.coordinate) { address in
                DispatchQueue.main.async {
                    self.myLocationAddress = address
                }
            }
        }
    }

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

        geocodeTimer?.invalidate()
        geocodeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.performGeocoding(region: region)
            self?.getAllReports(region: region)
        }
    }

    private func performGeocoding(region: MKCoordinateRegion) {
        DispatchQueue.global(qos: .background).async {
            self.reverseGeocode(coordinate: region.center) { address in
                DispatchQueue.main.async {
                    self.myAddress = address
                }
            }

            self.reverseGeocode(coordinate: self.topLeftCoordinate) { address in
                DispatchQueue.main.async {
                    self.topLeftAddress = address
                }
            }

            self.reverseGeocode(coordinate: self.bottomRightCoordinate) { address in
                DispatchQueue.main.async {
                    self.bottomRightAddress = address
                }
            }
            if let location = self.locationManager.location {
                self.reverseGeocode(coordinate: location.coordinate) { address in
                    DispatchQueue.main.async {
                        self.myLocationAddress = address
                    }
                }
            }
        }
    }

    private func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        let localGeocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        localGeocoder.reverseGeocodeLocation(location, preferredLocale: .autoupdatingCurrent) { placemarks, _ in
            DispatchQueue.main.async {
                if let placemark = placemarks?.first {
                    let address: String
                    if let street = placemark.thoroughfare {
                        address = [
                            street,
                            placemark.subThoroughfare,
                            placemark.administrativeArea,
                            placemark.country,
                        ].compactMap { $0 }.joined(separator: ", ")
                    } else {
                        address = [
                            placemark.administrativeArea,
                            placemark.country,
                        ].compactMap { $0 }.joined(separator: ", ")
                    }
                    completion(address)
                } else {
                    self.findNearestPlace(for: coordinate, completion: completion)
                }
            }
        }
    }

    private func findNearestPlace(for coordinate: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Street"
        request.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )

        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            DispatchQueue.main.async {
                if let place = response?.mapItems.first?.placemark {
                    let address: String
                    if let street = place.thoroughfare {
                        address = [
                            street,
                            place.subThoroughfare,
                            place.administrativeArea,
                            place.country,
                        ].compactMap { $0 }.joined(separator: ", ")
                    } else {
                        address = [
                            place.administrativeArea,
                            place.country,
                        ].compactMap { $0 }.joined(separator: ", ")
                    }
                    completion(address)
                } else {
                    completion("Unknown location")
                }
            }
        }
    }

    func getAllReports(region: MKCoordinateRegion) {
        Task { @MainActor in
            do {
                let loadedReports = try await communication.getAllReports(report: ReportGetBody(lat: region.center.latitude, lon: region.center.longitude, radius: visibleHeightKm * 1000))

                pointers = loadedReports
                print("### Loaded reports: \(loadedReports)")
            } catch {
//                didFailFetchingCategories = true
//                requestErrorMessage = error.customErrorMessage("Could not fetch categories.")
            }
        }
    }
}

class MockCategoriesCommunication: CategoriesCommunication {
    func loadCategories() async throws -> [Category] {
        return [
            Category(id: 1, title: "Roads & Sidewalks", icon: "🛣️", types: [IssueType(id: 1, title: "Potholes")], supportsImages: false),
            Category(id: 2, title: "Streetlights & Electrical", icon: "💡", types: [IssueType(id: 6, title: "Streetlight Malfunctions")], supportsImages: false),
        ]
    }
}
