//
//  AchievementsViewModel.swift
//  MT
//
//  Created by Ivan Gamov on 23.02.25.
//

import SwiftUI

typealias AchievementsCommunication = GetTitleMappingsCommunication & AuthMeCommunication

class AchievementsViewModel: ObservableObject {
    var totalSteps: Int {
        return titles.count
    }

    let pointsPerStep = 100
    @Published var currentPoints: Int
    @Published var titles: [TitleMapping] = []

    var myUser: User?

    let communication: AchievementsCommunication
    let goBack: Event

    var completedSteps: Int {
        return currentPoints / pointsPerStep
    }

    var stepTitles: [String] = []

    init(communication: AchievementsCommunication, goBack: @escaping Event) {
        self.communication = communication
        self.goBack = goBack
        currentPoints = 0

        fetchMe()
        getTitleMappings()
    }

    var progressPercentage: CGFloat {
        let currentStepPoints = CGFloat(currentPoints % pointsPerStep)
        return currentStepPoints / CGFloat(pointsPerStep)
    }

    func fetchMe() {
        Task { @MainActor in
            do {
                let profileResponse = try await communication.getMyProfile()
                myUser = profileResponse
                self.currentPoints = myUser?.points ?? 0
            } catch { }
        }
    }

    func getTitleMappings() {
        Task { @MainActor in
            do {
                let loadedTitleMappings = try await communication.getTitleMappings()
                titles = loadedTitleMappings
                self.mapTitlesToSteps()
            } catch {
                print("Error during getting title mappings: \(error.localizedDescription)")
            }
        }
    }

    private func mapTitlesToSteps() {
        let sortedTitles = titles.sorted { $0.points < $1.points }

        for i in 0 ..< totalSteps {
            if i < sortedTitles.count {
                stepTitles.append(sortedTitles[i].title)
            } else {
                stepTitles.append("")
            }
        }
    }
}
