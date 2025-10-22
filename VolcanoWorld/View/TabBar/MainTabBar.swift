//
//  MainTabBar.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 13.10.2025.
//

import SwiftUI


enum AppTab: Hashable, CaseIterable, Identifiable {
    case home
    case quests
    case shop
    case settings

    var id: Self { self }

    var title: String {
        switch self {
        case .home: return "Home"
        case .quests: return "Quests"
        case .shop: return "Shop"
        case .settings: return "Settings"
        }
    }

    var image: String {
        switch self {
        case .home: return "Home"
        case .quests: return "Quests"
        case .shop: return "Shop"
        case .settings: return "Settings"
        }
    }
}

struct MainTabBar: View {
    @EnvironmentObject private var themeStore: ThemeStore
    @EnvironmentObject private var rewardsManager: RewardsManager
    @EnvironmentObject private var volcanoes: VolcanoManager
    
    var body: some View {
        NavigationStack {
            TabBarContainer { tab in
                switch tab {
                case .home: HomeView()
                case .quests: QuestsView()
                case .shop: ShopView()
                case .settings: SettingsView()
                }
            }
            .environmentObject(themeStore)
            .environmentObject(rewardsManager)
            .environmentObject(volcanoes)
            .preferredColorScheme(themeStore.preferredColorScheme)
        }
    }
}

#Preview {
    MainTabBar()
        .environmentObject(ThemeStore())
        .environmentObject(RewardsManager())
        .environmentObject(VolcanoManager())
}

struct TabBarContainer<Content: View>: View {
    @State private var selection: AppTab = .home
    
    @EnvironmentObject private var themeStore: ThemeStore

    let content: (AppTab) -> Content

    init(@ViewBuilder content: @escaping (AppTab) -> Content) {
        self.content = content
    }

    var body: some View {
        let palette = themeStore.palette

        ZStack(alignment: .bottom) {
            content(selection)
                .background(palette.background.ignoresSafeArea())

        }
        .safeAreaInset(edge: .bottom) {
            CustomTabBar(selection: $selection)
                .background(
                    palette.cardBackground
                        .ignoresSafeArea(edges: .bottom)
                )
        }
    }
}

struct CustomTabBar: View {
    @Binding var selection: AppTab
    @EnvironmentObject private var themeStore: ThemeStore
    @Namespace private var anim
    
    var body: some View {
        let palette = themeStore.palette

        VStack(spacing: 12) {
            TopStripe(accent: palette.switchTint)

            HStack(spacing: 0) {
                ForEach(AppTab.allCases) { tab in
                    Spacer()
                    TabBarItem(
                        tab: tab,
                        isSelected: selection == tab,
                        accent: palette.switchTint,
                        textMain: palette.textMain,
                        textSecond: palette.textSecond,
                        pillColor: pillBackgroundColor(for: palette),
                        anim: anim
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.1)) {
                            selection = tab
                        }
                    }
                    Spacer()
                }
            }
            
            .background(
                palette.cardBackground
                    .opacity(1)
            )
        }
       

    }

    private func pillBackgroundColor(for palette: LavaPalette) -> Color {
        palette.cardBackground
            
    }
    
}

private struct TabBarItem: View {
    let tab: AppTab
    let isSelected: Bool
    let accent: Color
    let textMain: Color
    let textSecond: Color
    let pillColor: Color
    let anim: Namespace.ID

    var body: some View {
        VStack(spacing: 12) {
            
            Image(tab.image)
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
            
            Text(tab.title)
                .font(.customFont(.InterRegular, size: 12))
                .foregroundStyle(isSelected ? textMain : textSecond)
            
            Circle()
                .fill(accent)
                .frame(width: 6, height: 6)
                .opacity(isSelected ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
                
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background() {
            if isSelected {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(pillColor)
                        .shadow(color: accent.opacity(0.32), radius: 14, x: 0, y: 8)
                        .shadow(color: accent.opacity(0.18), radius: 6,  x: 0, y: -2)
                        .matchedGeometryEffect(id: "pill", in: anim)
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(accent.opacity(0.05))
                        .matchedGeometryEffect(id: "pill2", in: anim)
                    
                }
                
            }
        }
    }
}

private struct TopStripe: View {
    let accent: Color

    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(accent)
                .frame(height: 3)
            Rectangle()
                .fill(accent.opacity(0.25))
                .frame(height: 1)
                .blur(radius: 10)
        }
        .allowsHitTesting(false)
        
    }
}


