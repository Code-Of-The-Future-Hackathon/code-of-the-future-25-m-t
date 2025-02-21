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
                    .foregroundStyle(.blue)
                    .frame(height: 26)

                Spacer()
            }
            .padding(8)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.red.opacity(0.2))

                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 2)
                }
            }
            .clipShape(Rectangle())
        }
    }
}

#Preview {
    CustomButton(action: { }, text: "Done")
}
