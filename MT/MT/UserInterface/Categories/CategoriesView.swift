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
    @Namespace private var animationNamespace

    var body: some View {
        VStack(spacing: .zero) {
            TypographyText(text: "Categories", typography: .bigHeading)
                .padding(.vertical, 16)

            List {
                ForEach(viewModel.categories) { category in
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.2)) {
                            expandedCategoryID = (expandedCategoryID == category.id) ? nil : category.id
                        }
                    } label: {
                        HStack {
                            TypographyText(text: category.icon, typography: .body)
                            TypographyText(text: category.title, typography: .body)
                            Spacer()
                            Image(systemName: expandedCategoryID == category.id ? "chevron.up" : "chevron.down")
                                .foregroundColor(.gray)
                                .matchedGeometryEffect(id: "arrow\(category.id)", in: animationNamespace)
                        }
                        .padding(.vertical, 8)
                    }
                    .contentShape(Rectangle())
                    .background(Color.white)

                    if expandedCategoryID == category.id {
                        VStack(spacing: 4) {
                            if let types = category.types {
                                ForEach(types, id: \.id) { issueType in
                                    Button {
                                        DispatchQueue.main.async {
                                            viewModel.proccedToReport(issueType)
                                        }

                                        expandedCategoryID = nil
                                    } label: {
                                        HStack {
                                            TypographyText(text: "\(issueType.title)", typography: .body2)
                                                .foregroundColor(.gray)
                                                .padding(.leading, 24)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .contentShape(Rectangle())
                                    }
                                    .padding(.vertical, 6)
                                    .background(Color.white)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .background(Color.white)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarBackButtonHidden()
        .alert("Fetching categories failed", isPresented: $viewModel.didFailFetchingCategories) {
            Button("OK") {}
        } message: {
            TypographyText(text: viewModel.requestErrorMessage, typography: Typography.body3)
        }
    }
}
