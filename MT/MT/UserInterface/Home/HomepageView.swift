//
//  HomepageView.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//


import SwiftUI

struct HomepageView: View {
    @StateObject var viewModel: HomepageViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground).opacity(0.95)
                .ignoresSafeArea()
            Text("Homepage")
        }
    }
}

#Preview {
    HomepageView(viewModel: HomepageViewModel())
}
