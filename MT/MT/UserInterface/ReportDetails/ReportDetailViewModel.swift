//
//  ReportDetailViewModel.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import Foundation

class ReportDetailViewModel: ObservableObject {
    let report: ReportResponse
    let communication: UpdateIssueStatusCommunication
    let goBack: () -> Void

    init(report: ReportResponse, communication: UpdateIssueStatusCommunication, goBack: @escaping () -> Void) {
        self.report = report
        self.communication = communication
        self.goBack = goBack
    }

    func updateStatus() {
        Task { @MainActor in
            do {
                let _ = try await communication.updateIssueStatus(reportId: report.id, status: .resolved)
                goBack()
                print("success updating statuses")
            } catch { }
        }
    }
}
