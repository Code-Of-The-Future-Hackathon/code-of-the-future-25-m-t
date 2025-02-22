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
            .frame(height: 48)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(.systemBlue).opacity(0.8))

                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemBlue).opacity(0.7), lineWidth: 1)
                }
            }
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    CustomButton(action: { }, text: "Done")
}
