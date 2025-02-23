//
//  AchievementsView.swift
//  MT
//
//  Created by Ivan Gamov on 23.02.25.
//

import SwiftUI

struct AchievementsView: View {
    @StateObject var viewModel: AchievementsViewModel

    private var heading: some View {
        HStack {
            Button(action: viewModel.goBack) {
                Image(systemName: "arrow.backward")
            }

            Spacer()
        }
    }

    private var title: some View {
        ZStack {
            heading

            HStack(spacing: 0) {
                TypographyText(text: "Achievements Progress", typography: .largeHeading)
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
        }
    }

    @ViewBuilder
    private var pointsSection: some View {
        if let user = viewModel.myUser {
            TypographyText(text: "Your Points: \(user.points)", typography: .mediumHeading)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .center, spacing: 16) {
                    title
                    pointsSection
                }.padding(.bottom, 20)

                ForEach(viewModel.stepTitles.indices, id: \.self) { index in
                    HStack {
                        Circle()
                            .strokeBorder(index <= viewModel.completedSteps ? Color.teal : Color.gray, lineWidth: 2)
                            .background(Circle().fill(index <= viewModel.completedSteps ? Color.teal : Color.clear))
                            .frame(width: 20, height: 20)

                        TypographyText(text: "\(viewModel.stepTitles[index]) - \(viewModel.pointsPerStep * index)", typography: .body)
                            .font(.body)
                            .foregroundColor(index <= viewModel.completedSteps ? .teal : .gray)

                        Spacer()
                    }

                    if index < viewModel.totalSteps - 1 {
                        ZStack(alignment: .top) {
                            Rectangle()
                                .frame(width: 2, height: 50)
                                .foregroundColor(index < viewModel.completedSteps ? .teal : .gray)
                                .padding(.leading, 9)
                                .padding(.vertical, -2)

                            if index == viewModel.completedSteps {
                                Rectangle()
                                    .frame(width: 2, height: 50 * viewModel.progressPercentage, alignment: .top)
                                    .foregroundColor(.teal)
                                    .padding(.leading, 9)
                                    .padding(.vertical, -2)
                            }
                        }
                    }
                }

                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
    }
}
