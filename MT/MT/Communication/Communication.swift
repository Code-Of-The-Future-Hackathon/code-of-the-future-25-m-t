//
//  Communication.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Foundation

protocol LoginCommunication {
    func login(email: String, password: String) async throws -> Tokens
}

protocol RegistrationCommunication {
    func register(email: String, password: String) async throws -> Tokens
}

protocol GoogleAuthCommunication {
    func googleAuth(token: String) async throws -> Tokens
}

protocol AuthMeCommunication {
    func getMyProfile() async throws -> User
}

protocol CategoriesCommunication {
    func loadCategories() async throws -> [Category]
}

protocol ReportIssueCommunication {
    func reportAnIssue(report: ReportBody) async throws -> ReportResponse 
}

protocol GetAllReportsCommunication {
    func getAllReports(report: ReportGetBody) async throws -> [ReportResponse]
}

protocol PushTokenCommunication {
    func postPushToken(token: String) async throws -> EmptyResponse
}

protocol UpdateIssueStatusCommunication {
    func updateIssueStatus(reportId: Int, status: ReportStatus) async throws -> EmptyResponse
}

protocol ContinueAsGuestCommunication {
    func continueAsGuest() async throws -> Tokens
}

protocol GetAllActiveReportsCommunication {
    func getActiveIssues() async throws -> [ReportResponse]
}

protocol GetAllResolvedReportsCommunication {
    func getResolvedIssues() async throws -> [ReportResponse]
}

protocol AppleAuthCommunication {
    func appleAuth(token: String) async throws -> Tokens
}
