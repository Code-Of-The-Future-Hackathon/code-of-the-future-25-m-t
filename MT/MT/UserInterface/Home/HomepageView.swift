//
//  HomepageView.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI

struct HomepageView: View {
    @StateObject var viewModel: HomepageViewModel
    @State private var showCategoriesSheet = false

    var body: some View {
        ZStack {
            Color(.systemBackground).opacity(0.95)
                .ignoresSafeArea()
            
            VStack {
                Text("Homepage")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                Button(action: {
                    showCategoriesSheet.toggle()
                }) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("Show Categories")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
        }
        .sheet(isPresented: $showCategoriesSheet) {
            CategoriesView(viewModel: CategoriesViewModel(communication: viewModel.communication))
        }
    }
}

#Preview {
    HomepageView(viewModel: HomepageViewModel(communication: MockCategoriesCommunication()))
}
