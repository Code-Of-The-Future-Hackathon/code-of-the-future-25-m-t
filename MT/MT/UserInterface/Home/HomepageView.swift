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
        Text("Homepage")
    }
}

#Preview {
    HomepageView(viewModel: HomepageViewModel())
}
