//
//  CustomFonts.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 13.10.2025.
//

import SwiftUI

enum CustomAppFont: String {
    case InterRegular = "Inter_18pt-Regular"
    case InterSemiBold = "Inter_18pt-SemiBold"
    case JockeyRegular = "JockeyOne-Regular"
}

extension Font {
    static func customFont(_ font: CustomAppFont,
                       size: CGFloat,
                       relativeTo textStyle: Font.TextStyle? = nil) -> SwiftUI.Font {
        if let textStyle = textStyle {
            return SwiftUI.Font.custom(font.rawValue, size: size, relativeTo: textStyle)
        } else {
            return SwiftUI.Font.custom(font.rawValue, fixedSize: size)
        }
    }
}
