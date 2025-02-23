//
//  ReportDetailView.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import SwiftUI
import KeychainSwift

struct ReportDetailView: View {
    @StateObject var viewModel: ReportDetailViewModel
    @State private var selectedIssueIndex = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(spacing: 12) {
                title
                
                Divider()
                    .padding(.horizontal, -16)
            }

            Group {
                if let icon = viewModel.report.type.category?.icon, let title = viewModel.report.type.category?.title {
                    TypographyText(text: "\(title) \(icon)", typography: .largeHeading)
                }
                if let address = viewModel.report.address {
                    TypographyText(text: "\(address)", typography: .mediumHeading)
                        .foregroundStyle(.black.opacity(0.75))
                }
            }
            .padding(.horizontal)

            if let issues = viewModel.report.issues, !issues.isEmpty {
                TabView(selection: $selectedIssueIndex) {
                    ForEach(issues.indices, id: \.self) { index in
                        VStack {
                            let issue = issues[index]
                            if let file = issue.file,
                               let url = URL(string: file.url) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity, maxHeight: 400)
                                        .background(Color.blue)
                                        .cornerRadius(12, corners: .allCorners)

                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: 400)
                                    .foregroundColor(.gray)
                                    .cornerRadius(12, corners: .allCorners)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                if let issueDescription = issue.description {
                                    TypographyText(text: issueDescription, typography: .body)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack(spacing: 4) {
                    Spacer()
                    ForEach(0 ..< issues.count, id: \.self) { index in
                        Capsule()
                            .fill(index == selectedIssueIndex ? Color.blue : Color.gray.opacity(0.5))
                            .frame(width: index == selectedIssueIndex ? 12 : 6, height: 6)
                            .transition(.slide)
                            .animation(.easeInOut, value: selectedIssueIndex)
                    }
                    Spacer()
                }
                .padding()
            }

            if viewModel.report.status == .active && KeychainSwift().profile?.role == .admin {
                CustomButton(action: viewModel.updateStatus, text: "Resolve")
            }
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
    }

    var heading: some View {
        HStack {
            Button(action: viewModel.goBack) {
                Image(systemName: "arrow.backward")
            }
            
            Spacer()
        }
//        .padding()
    }

    var title: some View {
        ZStack {
            heading

            HStack(spacing: 0) {
                TypographyText(text: "Report Details", typography: .largeHeading)
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
        }
    }
}
