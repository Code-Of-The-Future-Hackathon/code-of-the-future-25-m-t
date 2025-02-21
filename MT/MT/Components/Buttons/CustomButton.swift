//
//  CustomButton.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI

struct CustomButton: View {
    var action: () -> Void
    let text: String

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()

                TypographyText(text: text, typography: .body2)
                    .foregroundStyle(Color(.label).opacity(0.9))
                    .frame(height: 26)

                Spacer()
            }
            .padding(8)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color(.systemBlue).opacity(0.8))

                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.systemBlue).opacity(0.7), lineWidth: 1)
                }
            }
            .clipShape(Rectangle())
        }
    }
}

#Preview {
    CustomButton(action: { }, text: "Done")
}
