//
//  QuestsView.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 13.10.2025.
//

import SwiftUI

struct QuestsView: View {
    @EnvironmentObject private var themeStore: ThemeStore
    @EnvironmentObject private var rewards: RewardsManager
    var body: some View {
//        let p = themeStore.palette

        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("🎖️ Achievements")
                        .foregroundStyle(.white)
                        .font(.customFont(.JockeyRegular, size: 40))
                    Text("Complete quests and earn rewards!")
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
                OverallProgressCard(
                    unlocked: rewards.achievementsUnlockedCount,
                    total: rewards.achievements.count
                )
                .padding()
                .environmentObject(themeStore)
                AchievementsListSection()
                    .environmentObject(themeStore)
                    .environmentObject(rewards)
            }
        }
    }
}

#Preview {
    MainTabBar()
        .environmentObject(ThemeStore())
        .environmentObject(RewardsManager())
        .environmentObject(VolcanoManager())
}


private struct OverallProgressCard: View {
    @EnvironmentObject private var themeStore: ThemeStore

    let unlocked: Int
    let total: Int

    var progress: CGFloat {
        guard total > 0 else { return 0 }
        return CGFloat(unlocked) / CGFloat(total)
    }

    var body: some View {
        let p = themeStore.palette
        let radius: CGFloat = 26

   
            VStack(alignment: .leading, spacing: 18) {

                HStack {
                    Text("Overall Progress")
                        .foregroundStyle(p.switchTint)
                        .font(.customFont(.InterRegular, size: 20))

                    Spacer()

                    Text("\(unlocked)/\(total)")
                        .foregroundStyle(.white)
                        .font(.customFont(.InterRegular, size: 14))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(p.switchTint))
                        .shadow(color: p.switchTint.opacity(0.45), radius: 14, x: 0, y: 6)
                }

                ProgressBar(value: progress)
                    .environmentObject(themeStore)

                Text("\(Int(round(progress * 100)))% Complete")
                    .foregroundStyle(p.textMain)
                    .font(.customFont(.InterRegular, size: 14))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(p.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: radius)
                            .stroke(p.textSecond.opacity(0.14), lineWidth: 1)
                            .blur(radius: 26)
                            .padding(-4)
                            .allowsHitTesting(false)
                    )
                    
                
            )
            
            
        
    }
}

private struct ProgressBar: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let value: CGFloat

    var body: some View {
        let p = themeStore.palette

        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let corner = height / 2

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(p.cardBackground.opacity(0.35))
                    .overlay(
                        RoundedRectangle(cornerRadius: corner, style: .continuous)
                            .stroke(p.textSecond.opacity(0.18), lineWidth: 1)
                    )

                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(p.switchTint)
                    .frame(width: max(0, min(1, value)) * width)
                    .shadow(color: p.switchTint.opacity(0.30), radius: 10, x: 0, y: 3)
            }
        }
        .frame(height: 18)
        .padding(.top, 2)
    }
}

struct AchievementsListSection: View {
    @EnvironmentObject private var themeStore: ThemeStore
    @EnvironmentObject private var rewards: RewardsManager

    var body: some View {
        let p = themeStore.palette

        VStack(alignment: .leading, spacing: 14) {

            HStack(spacing: 10) {
                Image(systemName: "trophy")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(p.switchTint)
                Text("All Achievements")
                    .foregroundStyle(p.switchTint)
                    .font(.customFont(.InterRegular, size: 20))
            }
            .padding(.horizontal, 2)
            .padding(.bottom, 4)

            LazyVStack(spacing: 14, pinnedViews: []) {
                ForEach(rewards.achievements) { a in
                    AchievementCard(achievement: a)
                        .environmentObject(themeStore)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct AchievementCard: View {
    @EnvironmentObject private var themeStore: ThemeStore

    let achievement: Achievement

    private var progress: CGFloat {
        guard achievement.progressTarget > 0 else { return 0 }
        return CGFloat(achievement.progressCurrent) / CGFloat(achievement.progressTarget)
    }

    var body: some View {
        let p = themeStore.palette
        let radius: CGFloat = 22

        VStack(alignment: .leading, spacing: 14) {

            HStack(alignment: .center, spacing: 12) {
                Text(achievement.emoji)
                    .font(.system(size: 28))

                Text(achievement.title)
                    .foregroundStyle(p.textMain)
                    .font(.customFont(.InterRegular, size: 20))

                Spacer()

                if achievement.isUnlocked {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12, weight: .bold))
                        Text("Unlocked")
                            .font(.customFont(.InterRegular, size: 14))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.green.opacity(0.85)))
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12, weight: .bold))
                        Text("Locked")
                            .font(.customFont(.InterRegular, size: 14))
                    }
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(p.textSecond.opacity(0.45)))
                }
            }

            Text(achievement.subtitle)
                .foregroundStyle(p.textSecond)
                .font(.customFont(.InterRegular, size: 14)) // мелкий 14
                .lineSpacing(2)

            HStack {
                Text("Progress")
                    .foregroundStyle(p.textSecond)
                    .font(.customFont(.InterRegular, size: 14))
                Spacer()
                Text("\(achievement.progressCurrent)/\(achievement.progressTarget)")
                    .foregroundStyle(p.textMain)
                    .font(.customFont(.InterRegular, size: 14))
            }

            SmallProgressBar(value: progress)
                .environmentObject(themeStore)

            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(p.switchTint)
                Text("+\(achievement.rewardCoins) coins")
                    .foregroundStyle(p.switchTint)
                    .font(.customFont(.InterRegular, size: 14))
            }
            .padding(.top, 2)
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
        
    }
}

private struct SmallProgressBar: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let value: CGFloat

    var body: some View {
        let p = themeStore.palette

        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let r = h / 2

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: r)
                    .fill(p.cardBackground.opacity(0.35))
                    .overlay(
                        RoundedRectangle(cornerRadius: r)
                            .stroke(p.textSecond.opacity(0.18), lineWidth: 1)
                    )

                RoundedRectangle(cornerRadius: r)
                    .fill(p.switchTint)
                    .frame(width: max(0, min(1, value)) * w)
            }
        }
        .frame(height: 12)
    }
}
