import SwiftUI

struct FullHistoryView: View {
    @EnvironmentObject private var themeStore: ThemeStore
    @EnvironmentObject private var volcanoes: VolcanoManager
    @EnvironmentObject private var rewardsManager: RewardsManager

    @Environment(\.dismiss) private var dismiss

    let id: Int

    var body: some View {
        let p = themeStore.palette

        VStack(alignment: .leading, spacing: 0) {
            if let v = volcanoes.volcano(by: id) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Circle()
                                .fill(Color.switchTintLight)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "arrow.left")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 17, weight: .semibold))
                                )
                        }
                        Spacer()
                    }

                    Text(v.name)
                        .foregroundStyle(.white)
                        .font(.customFont(.JockeyRegular, size: 40))

                    HStack {
                        Text("History, Facts & Timeline")
                            .foregroundStyle(.white)
                            .font(.customFont(.InterRegular, size: 16))
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .headerBackground()
                ScrollView {
                    VStack(spacing: 16) {
                        
                        GlowingMythologyCard(
                            title: "Mythology & Legends",
                            text: v.mythology
                        )
                        .environmentObject(themeStore)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        
                        EruptionTimelineSection(events: v.eruptionTimeline)
                            .environmentObject(themeStore)
                        
                        FascinatingFactsSection(facts: v.quickFacts)
                            .environmentObject(themeStore)
                        
                        HistoricalOverviewSection(text: v.historicalOverview)
                            .environmentObject(themeStore)
                    }
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
                .background(p.background.ignoresSafeArea())
            } else {
                Text("Volcano not found")
                    .foregroundStyle(.red)
                    .padding()
            }
        }
        .onAppear {
            _ = rewardsManager.registerOpenedHistory(volcanoID: id)
        }
        .background(themeStore.palette.background.ignoresSafeArea())
    }
}

#Preview {
    FullHistoryView(id: 0)
        .environmentObject(ThemeStore())
        .environmentObject(VolcanoManager())
}

private struct GlowingMythologyCard: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let title: String
    let text: String

    var body: some View {
        let p = themeStore.palette
        let radius: CGFloat = 28

        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "book.closed")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(p.switchTint)

                Text(title)
                    .foregroundStyle(p.switchTint)
                    .font(.customFont(.InterRegular, size: 20))
            }

            Text(text)
                .foregroundStyle(p.textMain.opacity(0.95))
                .font(.customFont(.InterRegular, size: 16))
                .italic()
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(p.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .stroke(p.textSecond.opacity(0.12), lineWidth: 1)
                )
                
                .shadow(color: p.switchTint.opacity(0.35), radius: 26, x: 0, y: 0)
                .shadow(color: p.switchTint.opacity(0.18), radius: 48, x: 0, y: 6)
        )
       
        .padding(.vertical, 6)
    }
}


private struct EruptionTimelineSection: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let events: [EruptionEvent]

    private let railWidth: CGFloat = 56

    var body: some View {
        let p = themeStore.palette

        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "calendar")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(p.switchTint)
                Text("Eruption Timeline")
                    .foregroundStyle(p.switchTint)
                    .font(.customFont(.InterRegular, size: 20))
            }

            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    Path { path in
                        let x = railWidth / 2
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geo.size.height))
                    }
                    .stroke(p.switchTint, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                }

                VStack(spacing: 18) {
                    ForEach(events, id: \.id) { ev in
                        TimelineRow(event: ev, railWidth: railWidth)
                            .environmentObject(themeStore)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(p.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(p.textSecond.opacity(0.14), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

private struct TimelineRow: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let event: EruptionEvent
    let railWidth: CGFloat

    var body: some View {
        let p = themeStore.palette

        HStack(alignment: .center, spacing: 12) {
            TimelineDot()
                .environmentObject(themeStore)
                .frame(width: railWidth, height: 56, alignment: .center)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(event.year)
                        .foregroundStyle(p.switchTint)
                        .font(.customFont(.InterRegular, size: 18))
                    Spacer()
                    VEIBadgeString(text: event.vei)
                        .environmentObject(themeStore)
                }

                Text(event.description)
                    .foregroundStyle(p.textMain)
                    .font(.customFont(.InterRegular, size: 16))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(p.cardBackground.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(p.textSecond.opacity(0.14), lineWidth: 1)
            )
        }
    }
}

private struct TimelineDot: View {
    @EnvironmentObject private var themeStore: ThemeStore
    var body: some View {
        let p = themeStore.palette
        ZStack {
            Circle()
                .fill(p.switchTint)
                .frame(width: 28, height: 28)
                .shadow(color: p.switchTint.opacity(0.45), radius: 18)
                .shadow(color: p.switchTint.opacity(0.22), radius: 30, y: 6)

            Circle()
                .strokeBorder(Color.black.opacity(0.05), lineWidth: 8)
                .frame(width: 36, height: 36)

            Image(systemName: "bolt.fill")
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .bold))
        }
    }
}

private struct VEIBadgeString: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let text: String
    var body: some View {
        let p = themeStore.palette
        Text(text)
            .font(.customFont(.InterRegular, size: 12))
            .foregroundStyle(p.textMain)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(p.cardBackground.opacity(0.55))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(p.switchTint.opacity(0.55), lineWidth: 1)
            )
    }
}

private struct FascinatingFactsSection: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let facts: [String]

    var body: some View {
        let p = themeStore.palette

        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "book.closed")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(p.switchTint)
                Text("Fascinating Facts")
                    .foregroundStyle(p.switchTint)
                    .font(.customFont(.InterRegular, size: 20))
            }

            VStack(spacing: 14) {
                ForEach(Array(facts.enumerated()), id: \.offset) { idx, text in
                    ShiftedFactRow(index: idx + 1, text: text)
                        .environmentObject(themeStore)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(p.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(p.textSecond.opacity(0.14), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

private struct ShiftedFactRow: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let index: Int
    let text: String

    var body: some View {
        let p = themeStore.palette
        let cardRadius: CGFloat = 22

        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [.switchTintLight, .switchTintDark],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 32)
                Text("\(index)")
                    .foregroundStyle(.white)
                    .font(.customFont(.InterRegular, size: 12))
            }
            .frame(width: 40, height: 40)

            Text(text)
                .foregroundStyle(p.textMain)
                .font(.customFont(.InterRegular, size: 16))
                .multilineTextAlignment(.leading)
                .lineSpacing(6)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            
            RoundedRectangle(cornerRadius: cardRadius, style: .continuous)
                .fill(.switchTintDark)
                .overlay(
                    RoundedRectangle(cornerRadius: cardRadius, style: .continuous)
                        .fill(p.cardBackground)
                        .offset(x: 6)
                )
        )
    }
}

private struct HistoricalOverviewSection: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let text: String

    var body: some View {
        let p = themeStore.palette

        VStack(alignment: .leading, spacing: 18) {
            Text("Historical Overview")
                .foregroundStyle(p.switchTint)
                .font(.customFont(.InterRegular, size: 20))

            Text(text)
                .foregroundStyle(p.textMain)
                .font(.customFont(.InterRegular, size: 16))
                .multilineTextAlignment(.leading)
                .lineSpacing(8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(p.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(p.textSecond.opacity(0.14), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}
