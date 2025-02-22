//
//  ReportDetailViewModel.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import Foundation

class ReportDetailViewModel: ObservableObject {
    let report: ReportResponse
    let goBack: () -> Void

    init(report: ReportResponse, goBack: @escaping () -> Void) {
        self.report = report
        self.goBack = goBack
    }
}
