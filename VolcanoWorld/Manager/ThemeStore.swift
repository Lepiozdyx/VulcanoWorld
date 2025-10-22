//
//  ThemeStore.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 13.10.2025.
//


import SwiftUI
import Combine

final class ThemeStore: ObservableObject {
    private let storageKey = "lavaMode"

    @AppStorage("lavaMode") private var lavaModeRaw: String = LavaMode.light.rawValue {
        didSet { objectWillChange.send() }
    }

    @AppStorage("volcanicThemeUnlocked") var volcanicThemeUnlocked: Bool = false {
        didSet { objectWillChange.send() }
    }

    let objectWillChange = ObservableObjectPublisher()

    var mode: LavaMode {
        get { LavaMode(rawValue: lavaModeRaw) ?? .light }
        set { lavaModeRaw = newValue.rawValue }
    }

    var palette: LavaPalette {
        switch mode { case .light: return .light; case .dark: return .dark }
    }

    var preferredColorScheme: ColorScheme {
        switch mode { case .light: return .light; case .dark: return .dark }
    }

    func requestSetMode(_ newMode: LavaMode) {
        if newMode == .dark, volcanicThemeUnlocked == false {
            return
        }
        mode = newMode
    }

    var isDarkLocked: Bool { volcanicThemeUnlocked == false }
    var isDarkEnabled: Bool { volcanicThemeUnlocked }
}
