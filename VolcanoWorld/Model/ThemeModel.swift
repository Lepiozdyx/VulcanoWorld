//
//  ThemeModel.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 13.10.2025.
//

import SwiftUI

enum LavaMode: String, CaseIterable, Identifiable {
    case light
    case dark

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .light: return "Lava Light"
        case .dark:  return "Lava Dark"
        }
    }
}

struct LavaPalette: Equatable {
    let background: Color
    let cardBackground: Color
    let textMain: Color
    let textSecond: Color
    let switchTint: Color

    static let light = LavaPalette(
        background: Color.backgroundLight,
        cardBackground: Color.cardBackgroundLight,
        textMain: Color.textMainLight,
        textSecond: Color.textSecondLight,
        switchTint: Color.switchTintLight
    )

    static let dark = LavaPalette(
        background: Color.backgroundDark,
        cardBackground: Color.cardBackgroundDark,
        textMain: Color.textMainDark,
        textSecond: Color.textSecondDark,
        switchTint: Color.switchTintDark
    )
}
