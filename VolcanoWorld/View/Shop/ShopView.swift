//
//  ShopView.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 13.10.2025.
//

import SwiftUI

private enum ShopFilter: String, CaseIterable, Identifiable {
    case all = "All Items"
    case themes = "Themes"
    case badges = "Badges"
    case avatar = "Avatar Items"

    var id: String { rawValue }

    var category: ItemCategory? {
        switch self {
        case .all:    return nil
        case .themes: return .theme
        case .badges: return .badge
        case .avatar: return .avatarItem
        }
    }

    var shortTitle: String {
        switch self {
        case .all:    return "All Items"
        case .themes: return "Themes"
        case .badges: return "Badges"
        case .avatar: return "Avatar Items"
        }
    }
}

struct ShopView: View {
    @EnvironmentObject private var themeStore: ThemeStore
    @EnvironmentObject private var rewards: RewardsManager
    @State private var filter: ShopFilter = .all

    var body: some View {
        let p = themeStore.palette

        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("🛒 Volcano Shop")
                        .foregroundStyle(.white)
                        .font(.customFont(.JockeyRegular, size: 40))
                    Text("Exchange coins for exclusive items!")
                        .foregroundStyle(.white)
                        .font(.customFont(.InterRegular, size: 16))
                    
                    HStack(spacing: 7) {
                        Image(.balance)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 49)
                        
                        Text("\(rewards.balance)")
                            .foregroundStyle(.white)
                            .font(.customFont(.JockeyRegular, size: 40))
                    }
                    .padding(16)
                    .background() {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white.opacity(0.2))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.switchTintLight, lineWidth: 2)

                    }
                    
                }
                
                Spacer()
            }
            .headerBackground()
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    filterChips
                    
                    LazyVStack(spacing: 14) {
                        ForEach(filteredItems) { item in
                            ShopItemCard(item: item,
                                         balance: rewards.balance,
                                         onBuy: { rewards.purchase(itemID: item.id) })
                            .environmentObject(themeStore)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .background(p.background.ignoresSafeArea())
            
        }
    }
    private var filteredItems: [ShopItem] {
            guard let cat = filter.category else { return rewards.shopItems }
            return rewards.shopItems.filter { $0.category == cat }
        }

    private var filterChips: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(ShopFilter.allCases) { f in
                    ShopFilterChip(
                        title: f.shortTitle,
                        isActive: filter == f,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.15)) { filter = f }
                        }
                    )
                    .environmentObject(themeStore)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
        }
        .padding(.horizontal, -16)
    }
}

private struct ShopFilterChip: View {
    @EnvironmentObject private var themeStore: ThemeStore

    let title: String
    let isActive: Bool
    let onTap: () -> Void

    var body: some View {
        let p = themeStore.palette
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.customFont(.InterSemiBold, size: 14))
            }
            .foregroundStyle(isActive ? Color.white : p.textMain)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .frame(height: 36)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(isActive ? p.switchTint : p.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(p.switchTint, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(title))
        .accessibilityAddTraits(isActive ? .isSelected : [])
    }
}

#Preview {
    MainTabBar()
        .environmentObject(ThemeStore())
        .environmentObject(RewardsManager())
        .environmentObject(VolcanoManager())
}

private struct ShopItemCard: View {
    @EnvironmentObject private var themeStore: ThemeStore

    let item: ShopItem
    let balance: Int
    let onBuy: () -> Bool

    private var isOwned: Bool { item.isOwned }
    private var canAfford: Bool { balance >= item.price }
    private var needMore: Int { max(0, item.price - balance) }

    var body: some View {
        let p = themeStore.palette
        let radius: CGFloat = 22

        VStack(spacing: 16) {
            HStack {
                rarityBadge(item.rarity)
                Spacer()
                if isOwned {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                        Text("Owned")
                            .font(.customFont(.InterRegular, size: 14))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.green.opacity(0.85)))
                }
            }

            Text(item.emoji).font(.system(size: 48))
            Text(item.title)
                .foregroundStyle(p.textMain)
                .font(.customFont(.InterRegular, size: 20))
            Text(item.description)
                .foregroundStyle(p.textSecond)
                .font(.customFont(.InterRegular, size: 14))
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                Text("🪙").font(.system(size: 18))
                Text("\(item.price)")
                    .foregroundStyle(p.switchTint)
                    .font(.customFont(.InterRegular, size: 18))
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if isOwned {
                actionButton(title: "Purchased", enabled: false, fill: p.textSecond.opacity(0.35))
            } else if canAfford {
                actionButton(title: "Buy Now", enabled: true, fill: p.switchTint) {
                    _ = onBuy()
                }
            } else {
                actionButton(title: "Need \(needMore) more coins", enabled: false, fill: p.textSecond.opacity(0.35))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(p.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .stroke(p.textSecond.opacity(0.18), lineWidth: 1)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .stroke(isOwned ? Color.green.opacity(0.85) : .clear, lineWidth: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill((isOwned ? Color.green : p.switchTint).opacity(isOwned ? 0.20 : 0.0))
                .blur(radius: isOwned ? 18 : 0)
                .padding(isOwned ? -6 : 0)
                .allowsHitTesting(false)
        )
    }

    private func rarityBadge(_ r: ItemRarity) -> some View {
        let title: String
        let color: Color
        switch r {
        case .common:    title = "Common";    color = .gray
        case .rare:      title = "Rare";      color = Color.blue.opacity(0.8)
        case .epic:      title = "Epic";      color = Color.purple.opacity(0.85)
        case .legendary: title = "Legendary"; color = Color.orange.opacity(0.9)
        }
        return Text(title)
            .foregroundStyle(.white)
            .font(.customFont(.InterRegular, size: 12))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(color))
    }

    private func actionButton(title: String,
                              enabled: Bool,
                              fill: Color,
                              action: (() -> Void)? = nil) -> some View {
        let p = themeStore.palette
        return Button {
            action?()
        } label: {
            HStack {
                if enabled {  }
                Text(title)
                    .font(.customFont(.InterRegular, size: 16))
            }
            .foregroundStyle(enabled ? .white : p.textMain.opacity(0.7))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(fill)
            )
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}
