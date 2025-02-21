//
//  CategoriesView.swift
//  MT
//
//  Created by Ivan Gamov on 22.02.25.
//

import SwiftUI

struct CategoriesView: View {
    @StateObject var viewModel: CategoriesViewModel
    @State private var expandedCategoryID: Int? = nil

    var body: some View {
        VStack(spacing: .zero) {
            TypographyText(text: "Categories", typography: .bigHeading)
                .padding(.vertical, 16)

            List {
                ForEach(viewModel.categories) { category in
                    VStack(alignment: .leading, spacing: 4) { // Reduce spacing here
                        Button(action: {
//                            withAnimation {
                                if expandedCategoryID == category.id {
                                    expandedCategoryID = nil // Collapse if already open
                                } else {
                                    expandedCategoryID = category.id // Expand
                                }
//                            }
                        }) {
                            HStack {
                                TypographyText(text: category.icon, typography: .body)

                                TypographyText(text: category.title, typography: .body)

                                Spacer()

                                Image(systemName: expandedCategoryID == category.id ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle()) // Removes default button styling

                        // Show subcategories when expanded
                        if expandedCategoryID == category.id {
                            ForEach(category.types) { issueType in
                                HStack {
                                    TypographyText(text: "• \(issueType.title)", typography: .body3)
                                        .foregroundColor(.gray)
                                        .padding(.leading, 24) // Indent subcategories
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                            .transition(.opacity.combined(with: .move(edge: .top))) // Smooth animation
                        }

                        Divider() // Separator between categories
                    }
                }
            }
            .listStyle(PlainListStyle()) // Use plain style to reduce spacing
        }
        .navigationBarBackButtonHidden()
        .alert("Fetching categories failed", isPresented: $viewModel.didFailFetchingCategories) {
            Button("OK") {}
        } message: {
            TypographyText(text: viewModel.requestErrorMessage, typography: Typography.body3)
        }
    }
}
