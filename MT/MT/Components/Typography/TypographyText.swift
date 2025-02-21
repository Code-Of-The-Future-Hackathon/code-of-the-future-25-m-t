//
//  TypographyText.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI

struct TypographyText: View {
    let text: LocalizedStringKey
    let typography: Typography

    public init(text: String, typography: Typography) {
        self.text = LocalizedStringKey(text)
        self.typography = typography
    }
    
    public init(text: LocalizedStringKey, typography: Typography) {
        self.text = text
        self.typography = typography
    }

    public var body: Text {
        Text(text)
            .font(typography.value.font)
            .kerning(typography.value.letterSpacing)
    }
    
    var toText: Text {
        body
    }
}

#Preview {
    TypographyText(text: "Hello", typography: .bigHeading)
}
