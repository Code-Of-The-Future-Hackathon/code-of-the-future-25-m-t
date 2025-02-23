//
//  RepostsListView.swift
//  MT
//
//  Created by Mihail Kolev on 22/02/2025.
//

import SwiftUI

struct RepostsListView: View {
    @StateObject var viewModel: RepostsListViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground).opacity(0.95)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                searchBox
                Divider()
                clearCategoriesButton
                categoriesScrollView
                reportsList
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getAllReports()
        }
        .onChange(of: viewModel.selectedCategory) {
            viewModel.getAllReports()
        }
    }

    var searchBox: some View {
        ZStack {
            heading

            HStack(spacing: 0) {
                TypographyText(text: "Near you", typography: .largeHeading)
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
//            .background(
//                RoundedRectangle(cornerRadius: 30)
//                    .foregroundColor(.gray.opacity(0.3))
//            )
        }
    }

    @ViewBuilder
    var clearCategoriesButton: some View {
        if viewModel.selectedCategory != nil {
            HStack {
                Button(action: {
                    viewModel.selectedCategory = nil
                }) {
                    TypographyText(text: "Clear Filter", typography: .smallText)
                        .underline()
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.horizontal, 4)
        }
    }

    var categoriesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Text("\(category.title)")
                        .foregroundStyle(viewModel.selectedCategory == category.id ? Color.blue : Color.gray)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(viewModel.selectedCategory == category.id ? Color.blue : Color.gray, lineWidth: 1)
                        )
                        .onTapGesture {
                            if viewModel.selectedCategory == category.id {
                                viewModel.selectedCategory = nil
                            } else {
                                viewModel.selectedCategory = category.id
                            }
                        }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    var reportsList: some View {
        ZStack {
            Color.clear.ignoresSafeArea() // Ensures full transparency

            List {
                ForEach(viewModel.reports) { report in
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
                    .contentShape(Rectangle())
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        viewModel.openReportDetail(report)
                    }
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


    var heading: some View {
        HStack {
            Button(action: viewModel.goBack) {
                Image(systemName: "arrow.backward")
            }
            
            Spacer()
        }
        .padding()
    }
}
