//
//  SettingsView.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 13.10.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeStore: ThemeStore
    @EnvironmentObject private var rewardsManager: RewardsManager
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Settings")
                    .foregroundStyle(.white)
                    .font(.customFont(.JockeyRegular, size: 40))
                HStack {
                    Text("Customize your experience")
                        .foregroundStyle(.white)
                        .font(.customFont(.InterRegular, size: 16))
                    Spacer()
                }
            }
            .headerBackground()
            
            ScrollView {
                SettingsAppearanceCard()
                
                SettingsAboutSection()
            }
            .padding([.horizontal, .top])
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    MainTabBar()
        .environmentObject(ThemeStore())
        .environmentObject(RewardsManager())
}

struct SettingsAppearanceCard: View {
    @EnvironmentObject private var themeStore: ThemeStore

    var body: some View {
        let p = themeStore.palette

        VStack(alignment: .leading, spacing: 16) {
            Text("Appearance")
                .font(.customFont(.InterRegular, size: 20))
                .foregroundStyle(.switchTintDark)

            LavaSwitchRow(
                title: "Lava Night Mode",
                subtitle: themeStore.mode == .dark ? "Dark volcanic purple theme" : "Bright day theme",
                isOn: Binding(
                    get: { themeStore.mode == .dark },
                    set: { isOn in
                        withAnimation(.easeInOut(duration: 0.25)) {
                            if isOn && !themeStore.volcanicThemeUnlocked { return }
                            themeStore.mode = isOn ? .dark : .light
                        }
                    }
                ),
                isDisabled: !themeStore.volcanicThemeUnlocked
            )
            .opacity(themeStore.volcanicThemeUnlocked ? 1.0 : 0.5)

            HStack(spacing: 16) {
                ModePreviewTile(
                    title: "Day Mode",
                    isSelected: themeStore.mode == .light,
                    content: {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color(.sRGB, red: 1.0, green: 0.98, blue: 0.90, opacity: 1.0))
                            .frame(height: 64)
                    },
                    palette: p
                )
                .disabled(true)

                ModePreviewTile(
                    title: "Lava Night",
                    isSelected: themeStore.mode == .dark,
                    content: {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.26, green: 0.08, blue: 0.42),
                                        Color(red: 0.16, green: 0.04, blue: 0.30)
                                    ],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 64)
                    },
                    palette: p
                )
                .disabled(true)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(p.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(p.textSecond.opacity(0.14), lineWidth: 1)
        )
        .clipped()
    }
}

private struct LavaSwitchRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let isDisabled: Bool

    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var themeStore: ThemeStore

    var body: some View {
        let p = themeStore.palette

        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(p.cardBackground.opacity(0.001))
                    .frame(width: 36, height: 36)
                    .shadow(color: p.switchTint.opacity(0.35), radius: 10, x: 0, y: 4)
                Image(themeStore.mode == .dark ? "moon" : "sun")
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.customFont(.InterRegular, size: 16))
                    .foregroundStyle(p.textMain)
                Text(subtitle)
                    .font(.customFont(.InterRegular, size: 14))
                    .foregroundStyle(p.textSecond)
            }

            Spacer(minLength: 6)

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(p.switchTint)
                .accessibilityLabel(Text(title))
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.75 : 1.0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(p.cardBackground.opacity(0.72))
                .shadow(color: p.textSecond.opacity(0.18), radius: 10, x: 0, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(p.textSecond.opacity(0.12), lineWidth: 1)
        )
        .disabled(isDisabled) 
    }
}

private struct ModePreviewTile<Content: View>: View {
    let title: String
    let isSelected: Bool
    @ViewBuilder var content: () -> Content
    let palette: LavaPalette

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content()
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(palette.textSecond.opacity(0.12), lineWidth: 1)
                )

            Text(title)
                .font(.customFont(.InterRegular, size: 14))
                .foregroundStyle(palette.textMain)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(palette.cardBackground.opacity(0.86))
                .shadow(color: isSelected ? palette.switchTint.opacity(0.45) : .clear, radius: isSelected ? 18 : 0, x: 0, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(
                    isSelected ? palette.switchTint : palette.switchTint.opacity(0.4),
                    lineWidth: isSelected ? 2 : 1
                )
        )
        .allowsHitTesting(false)
    }
}

struct SettingsAboutSection: View {
    @EnvironmentObject private var themeStore: ThemeStore

    private let appDescription =
        "Volcano Guide is your comprehensive encyclopedia for exploring Earth's most powerful geological wonders. Discover active and extinct volcanoes, learn about their history, and explore stunning visuals of eruptions and lava flows."

    private let versionText = "1.0.0"
    private let volcanoesFeaturedText = "8 Featured"
    private let lastUpdatedText = "October 2025"

    private let eduTitle = "Educational & Adventure"
    private let eduSubtitle =
        "A travel-science guide combining geography education with stunning volcanic imagery. Explore the power of Earth's fire mountains."

    var body: some View {

        VStack(spacing: 10) {
            AboutCard(
                title: "About",
                description: appDescription,
                rows: [
                    .init(title: "Version", value: versionText),
                    .init(title: "Volcanoes", value: volcanoesFeaturedText),
                    .init(title: "Last Updated", value: lastUpdatedText)
                ]
            )
            .environmentObject(themeStore)

            EducationalCard(
                icon: "flame",
                title: eduTitle,
                subtitle: eduSubtitle
            )
            .environmentObject(themeStore)
        }
    }
}

private struct AboutCard: View {
    @EnvironmentObject private var themeStore: ThemeStore

    struct Row: Identifiable {
        let id = UUID()
        let title: String
        let value: String
    }

    let title: String
    let description: String
    let rows: [Row]

    var body: some View {
        let p = themeStore.palette

        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "info.circle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(p.switchTint)
                Text(title)
                    .font(.customFont(.InterRegular, size: 20))
                    .foregroundStyle(p.switchTint)
                Spacer()
            }

            Text(description)
                .font(.customFont(.InterRegular, size: 16))
                .foregroundStyle(p.textMain)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(2)

            VStack(spacing: 12) {
                ForEach(rows) { row in
                    InfoCapsuleRow(title: row.title, value: row.value)
                        .environmentObject(themeStore)
                }
            }
            .padding(.top, 4)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(p.cardBackground)
                
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(p.textSecond.opacity(0.16), lineWidth: 1)
        )
    }
}

private struct InfoCapsuleRow: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let title: String
    let value: String

    var body: some View {
        let p = themeStore.palette

        HStack {
            Text(title)
                .font(.customFont(.InterRegular, size: 14))
                .foregroundStyle(p.textSecond)
            Spacer(minLength: 12)
            Text(value)
                .font(.customFont(.InterRegular, size: 14))
                .foregroundStyle(p.textMain)
        }
        .font(.system(size: 16, weight: .semibold))
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(p.cardBackground.opacity(0.75))
                .shadow(color: p.textSecond.opacity(0.10), radius: 10, x: 0, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(p.textSecond.opacity(0.14), lineWidth: 1)
        )
    }
}


private struct EducationalCard: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        let p = themeStore.palette

        VStack(spacing: 16) {
                Image(icon)

            Text(title)
                .font(.customFont(.InterRegular, size: 18))
                .foregroundStyle(.switchTintDark)

            Text(subtitle)
                .font(.customFont(.InterRegular, size: 14))
                .multilineTextAlignment(.center)
                .foregroundStyle(p.textMain)
                .lineSpacing(2)
        }
        .padding(.vertical, 26)
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(p.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(p.textSecond.opacity(0.16), lineWidth: 1)
        )
    }
}
