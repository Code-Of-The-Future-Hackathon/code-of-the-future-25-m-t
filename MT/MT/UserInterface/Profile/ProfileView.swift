//
//  ProfileView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @State private var showLogoutAlert = false

    var body: some View {
        ZStack {
            Color(.systemBackground).opacity(0.95)
                .ignoresSafeArea()
            Text("Profile")

            VStack {
                Spacer()
                Button(action: {
//                        viewModel.logoutClicked?()
                    showLogoutAlert = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .renderingMode(.template)
                            .foregroundStyle(.black.opacity(0.8))
                        TypographyText(text: "Log out", typography: .body2)
                            .foregroundStyle(.black.opacity(0.8))
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
    }
}
