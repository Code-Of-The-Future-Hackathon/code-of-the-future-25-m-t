//
//  ProfileView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

enum ReportsStatus {
    case active
    case resolved
}

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @State private var showLogoutAlert = false
    @State private var reportsStatusType: ReportsStatus = .active

    var body: some View {
        ZStack {
            Color(.systemBackground).opacity(0.95)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black.opacity(0.8))
                    Spacer()
                    VStack(spacing: 4) {
                        TypographyText(text: viewModel.myUser.email, typography: .body)
                            .foregroundStyle(.black.opacity(0.8))
                        TypographyText(text: "\(viewModel.myUser.title ?? "") (\(viewModel.myUser.points))", typography: .smallText)
                            .foregroundStyle(.black.opacity(0.8))
                    }
                    Spacer()
                    Button(action: { }) {
                        Image(systemName: "arrow.forward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundStyle(.black.opacity(0.8))
                    }
                }
                .padding(EdgeInsets(top: 16,
                                    leading: 16,
                                    bottom: 4,
                                    trailing: 16))

                Divider()

                if viewModel.myUser.role == .user {
                    TypographyText(text: "My reports" , typography: .mediumHeading)
                        .foregroundStyle(.black.opacity(0.8))
                    reportsListActive
                        .padding(.bottom, 100)

                } else {
                    ZStack {
                        HStack(spacing: 0) {
                            Button {
                                reportsStatusType = .active
                            } label: {
                                ZStack {
                                    reportsStatusType == .active ? Color.blue : Color.white
                                    HStack {
                                        Spacer()
                                        TypographyText(text: "My reports" , typography: .body)
                                            .foregroundStyle(.black.opacity(0.8))
                                            .foregroundStyle(reportsStatusType == .active ? .white : .blue)
                                        Spacer()
                                    }
                                }
                                .cornerRadius(20, corners: [.bottomLeft, .topLeft])
                            }
                            Button {
                                reportsStatusType = .resolved
                            } label: {
                                ZStack {
                                    reportsStatusType == .resolved ? Color.blue : Color.white
                                    HStack {
                                        Spacer()
                                        TypographyText(text: "Resolved by me" , typography: .body)
                                            .foregroundStyle(.black.opacity(0.8))
                                            .foregroundStyle(reportsStatusType == .active ? .white : .blue)
                                        Spacer()
                                    }
                                }
                                .cornerRadius(20, corners: [.bottomRight, .topRight])
                            }
                        }
                        .padding(.horizontal, 28)
                        .frame(height: 40)

                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.black.opacity(0.5)), lineWidth: 1)
                            .padding(.horizontal, 28)
                            .frame(height: 40)

                    }

                    if reportsStatusType == .active { reportsListActive.padding(.bottom, 50) } else { reportsListResolved.padding(.bottom, 50) }
                }
            }

            VStack {
                Spacer()
                Button(action: {
                    showLogoutAlert = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .renderingMode(.template)
                            .foregroundStyle(.red.opacity(0.8))
                        TypographyText(text: "Log out", typography: .body2)
                            .foregroundStyle(.red.opacity(0.8))
                    }
                }
            }
            .padding()
        }
        .alert("Are you sure you want to log out?", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Log out", role: .destructive) {
                viewModel.logoutClicked?()
            }
        }
        .onAppear {
            viewModel.getAllReports()
        }
    }

    var reportsListActive: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            List {
                ForEach(viewModel.reportsActive) { report in
                    HStack {
                        TypographyText(text: report.type.category?.icon ?? "", typography: .largeHeading)
                        VStack(alignment: .leading, spacing: 8) {
                            TypographyText(text: report.type.title ?? "", typography: .body2)
                                .foregroundStyle(.black.opacity(0.8))
                                .lineLimit(1)
                            TypographyText(text: report.address ?? "", typography: .smallText)
                                .foregroundStyle(.black.opacity(0.8))
                                .lineLimit(1)
                        }
                        Spacer()
                        TypographyText(text: report.distanceInKm, typography: .body2)
                            .foregroundStyle(.black.opacity(0.8))
                    }
                    .listRowBackground(Color.clear) // Ensure each row is clear
                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                    .listRowSeparator(.hidden)
                }
            }
            .refreshable {
                viewModel.getAllReports()
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .padding(.horizontal)
        }
    }

    var reportsListResolved: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            List {
                ForEach(viewModel.reportsResolved) { report in
                    HStack {
                        TypographyText(text: report.type.category?.icon ?? "", typography: .largeHeading)
                        VStack(alignment: .leading, spacing: 8) {
                            TypographyText(text: report.type.title ?? "", typography: .body2)
                                .foregroundStyle(.black.opacity(0.8))
                                .lineLimit(1)
                            TypographyText(text: report.address ?? "", typography: .smallText)
                                .foregroundStyle(.black.opacity(0.8))
                                .lineLimit(1)
                        }
                        Spacer()
                        TypographyText(text: report.distanceInKm, typography: .body2)
                            .foregroundStyle(.black.opacity(0.8))
                    }
                    .listRowBackground(Color.clear) // Ensure each row is clear
                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                    .listRowSeparator(.hidden)
                }
            }
            .refreshable {
                viewModel.getAllReports()
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .padding(.horizontal)
        }
    }

}
