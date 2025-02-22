//
//  Splash.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI

struct Splash: View {
    @State private var moveToTop = false

    var body: some View {
        ZStack {
            Color(.systemBackground).opacity(0.95)
                .ignoresSafeArea()

            VStack {
                TypographyText(text: "ReportIt", typography: .bigHeading)
                    .foregroundStyle(.black.opacity(0.8))
                    .padding()
                if moveToTop {
                    Spacer()
                }
            }

        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    moveToTop = true
                }
            }
        }
    }
}

#Preview {
    Splash()
}
