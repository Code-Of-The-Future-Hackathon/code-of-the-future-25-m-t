//
//  ProfileViewModel.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Foundation

typealias ProfileCommunication = AuthMeCommunication & GetAllReportsCommunication

class ProfileViewModel: ObservableObject {
    @Published var reportsActive: [ReportResponse] = []
    @Published var reportsResolved: [ReportResponse] = []
    var logoutClicked: Event?
    var navigateToAchievements: Event?
    var myUser: User

    let communication: ProfileCoordinatorCommunication

    init(communication: ProfileCoordinatorCommunication, user: User) {
        self.communication = communication
        self.myUser = user

        fetchMe()
    }

    func fetchMe() {
        Task { @MainActor in
            do {
                let profileResponse = try await communication.getMyProfile()

                myUser = profileResponse
            } catch { }
        }
    }

    func getAllReports() {
        Task { @MainActor in
            do {
                if myUser.role == .user {
                    let loadedReports = try await communication.getActiveIssues()
                    reportsActive = loadedReports
                } else {
                    let loadedReportsActive = try await communication.getActiveIssues()
                    reportsActive = loadedReportsActive
                    let loadedReportsResolved = try await communication.getResolvedIssues()
                    reportsResolved = loadedReportsResolved
                }
            } catch { }
        }
    }
}
