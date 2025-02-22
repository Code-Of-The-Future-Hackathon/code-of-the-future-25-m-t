//
//  ReportDetailView.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import SwiftUI

struct ReportDetailView: View {
    @StateObject var viewModel: ReportDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack(alignment: .top) {
                HStack {
                    Button(action: viewModel.goBack) {
                        Image(systemName: "arrow.backward")
                    }
                    .padding()

                    Spacer()
                }

                TypographyText(text: "Report Details", typography: .bigHeading)
            }

            Divider()

            Group {
                if let address = viewModel.report.address {
                    TypographyText(text: "Address: \(address)", typography: .body)
                }
                if let description = viewModel.report.description {
                    TypographyText(text: "Description: \(description)", typography: .body)
                }
                TypographyText(text: "Type: \(viewModel.report.type.title ?? "N/A")", typography: .body)
            }
            .padding(.horizontal)

            if let issues = viewModel.report.issues,
               let firstIssue = issues.first,
               let file = firstIssue.file,
               let url = URL(string: file.url) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
            }

            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
    }
}
