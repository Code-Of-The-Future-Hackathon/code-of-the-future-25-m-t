//
//  ReportProblemViewModel.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI

class ReportProblemViewModel: ObservableObject {
    @Published var title: String
    @Published var description: String = ""
    @Published var image: UIImage? = nil
    @Published var isShowingCamera = false

    @Published var didFailReportingProblem: Bool = false
    @Published var requestErrorMessage = ""

    var supportsImages: Bool
    var issueType: IssueType
    var lattitude: Double
    var longitude: Double
    var address: String?
    let communication: ReportIssueCommunication
    let goBack: Event

    var isSubmitDisabled: Bool {
        return title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(communication: ReportIssueCommunication,
         lattitude: Double,
         longitude: Double,
         address: String? = nil,
         issueType: IssueType,
         supportsImages: Bool,
         goBack: @escaping Event) {
        self.communication = communication
        self.lattitude = lattitude
        self.longitude = longitude
        self.address = address
        self.title = issueType.title
        self.issueType = issueType
        self.supportsImages = supportsImages
        self.goBack = goBack
    }

    func submitReport() {
        Task { @MainActor in
            do {
                let _ = try await communication.reportAnIssue(report: ReportBody(
                    description: description,
                    address: address,
                    lat: lattitude,
                    lon: longitude,
                    typeId: issueType.id,
                    file: image))

                goBack()
            } catch {
                didFailReportingProblem = true
                requestErrorMessage = error.customErrorMessage("Could not report a problem.")
            }
        }
    }
}
