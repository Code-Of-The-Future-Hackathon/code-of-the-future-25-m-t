//
//  Typography.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI

struct TypographyData {
    let letterSpacing: CGFloat
    let font: Font
}

public enum Typography {
    case bigHeading
    case largeHeading
    case mediumHeading
    case smallHeading
    case button
    case body
    case body2
    case body3
    case smallText

    var value: TypographyData {
        switch self {
        case .bigHeading:
            return TypographyData(
                letterSpacing: -0.3,
                font: InterFont.inter(.bold, size: 34))
        case .largeHeading:
            return TypographyData(
                letterSpacing: -0.3,
                font: InterFont.inter(.bold, size: 26))
        case .mediumHeading:
            return TypographyData(
                letterSpacing: -0.3,
                font: InterFont.inter(.bold, size: 20))
        case .smallHeading:
            return TypographyData(
                letterSpacing: -0.3,
                font: InterFont.inter(.bold, size: 18))
        case .button:
            return TypographyData(
                letterSpacing: -0.3,
                font: InterFont.inter(.semibold, size: 17))
        case .body:
            return TypographyData(
                letterSpacing: -0.3,
                font: InterFont.inter(.medium, size: 17))
        case .body2:
            return TypographyData(
                letterSpacing: -0.3,
                font: InterFont.inter(.regular, size: 17))
        case .body3:
            return TypographyData(
                letterSpacing: -0.3,
                font: InterFont.inter(.regular, size: 14))
        case .smallText:
            return TypographyData(
                letterSpacing: -0.3,
                font: InterFont.inter(.regular, size: 12))
        }
    }
}

enum InterFont {
    case bold
    case extraBold
    case extraLight
    case light
    case medium
    case regular
    case semibold

    var value: String {
        switch self {
        case .bold:
            return "Bold"
        case .extraBold:
            return "ExtraBold"
        case .extraLight:
            return "ExtraLight"
        case .light:
            return "Light"
        case .medium:
            return "Medium"
        case .regular:
            return "Regular"
        case .semibold:
            return "SemiBold"
        }
    }

    static func inter(_ type: InterFont, size: CGFloat) -> Font {
        return .custom("Inter-\(type.value)", size: size)
    }
}

