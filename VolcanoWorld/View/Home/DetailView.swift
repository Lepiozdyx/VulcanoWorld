import SwiftUI
import Foundation
import MapKit

private enum DetailTab: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case location = "Location"
    case facts    = "Facts"
    var id: String { rawValue }
}

struct VolcanoDetailView: View {
    @EnvironmentObject private var themeStore: ThemeStore
    @EnvironmentObject private var volcanoes: VolcanoManager
    @EnvironmentObject private var rewards: RewardsManager
    @State private var didRegisterMap = false

    @State private var showHistory = false
    @State private var showGallery = false
    @Environment(\.dismiss) private var dismiss

    let volcanoID: Int

    @State private var tab: DetailTab = .overview


    var body: some View {
        let p = themeStore.palette
        if let v = volcanoes.volcano(by: volcanoID) {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack {
                        Image(lastWordFromVolcanoName(v.name))
                            .resizable()
                            .scaledToFit()
                            
                            .clipped()
                            .edgesIgnoringSafeArea(.all)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .overlay {
                        VStack {
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    Circle()
                                        .fill(.switchTintLight)
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            Image(systemName: "arrow.left")
                                                .foregroundStyle(.black)
                                                .font(.system(size: 17, weight: .semibold))
                                        )
                                }
                                .padding(.leading, 16)
                                .padding(.top, 0)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                Spacer()
                                Button {
                                    volcanoes.toggleFavorite(v.id)
                                } label: {
                                    Circle()
                                        .fill(.switchTintLight)
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            Image(systemName: v.isFavorite ? "heart.fill" : "heart")
                                                .foregroundStyle(v.isFavorite ? .pink : .black)
                                                .font(.system(size: 17, weight: .semibold))
                                        )
                                }
                                .padding(.trailing, 16)
                                .padding(.top, 0)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            }
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(v.name)
                                    .foregroundStyle(.white)
                                    .font(.customFont(.JockeyRegular, size: 36))
                                    .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 2)
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundStyle(p.textMain)
                                        .font(.system(size: 16, weight: .semibold))
                                        .shadow(color: .black.opacity(0.45), radius: 6, x: 0, y: 2)
                                    
                                    Text(v.geographic.country)
                                        .foregroundStyle(p.textMain)
                                        .font(.customFont(.InterRegular, size: 16))
                                        .shadow(color: .black.opacity(0.45), radius: 6, x: 0, y: 2)
                                }
                                
                            }
                            .offset(y: -20)
                            .padding(.leading, 16)
                            .padding(.bottom, 12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                            
                        }
                    }
                        
                    ScrollView {
                        VStack(spacing: 16) {
                            VolcanoStatusGrid(v: v)
                                .padding(.horizontal, 16)
                            
                            DetailTabSegmentView(selected: $tab)
                                .environmentObject(themeStore)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                            
                            switch tab {
                            case .overview:
                                OverviewSection(v: v)
                                    .environmentObject(themeStore)
                            case .location:
                                LocationSection(v: v)
                                    .environmentObject(themeStore)
                            case .facts:
                                FactsSection(v: v)
                                    .environmentObject(themeStore)
                            }
                            
                            ActionButtonsRow(
                                primaryTitle: "Full History",
                                primaryIcon: "book",
                                secondaryTitle: "Gallery",
                                secondaryIcon: "photo.on.rectangle",
                                onPrimary: { showHistory = true },
                                onSecondary: { showGallery = true }
                            )
                            .environmentObject(themeStore)
                            .padding(.horizontal, 16)
                            .padding(.top, 4)
                        }
                    }
                }                
            }
            .onAppear() {
                _ = volcanoes.markViewed(v.id)
                _ = rewards.registerView(volcanoID: v.id, source: volcanoes)
            }
            .onChange(of: tab) { newValue in
                if newValue == .location, !didRegisterMap {
                    didRegisterMap = true
                    if let v = volcanoes.volcano(by: volcanoID) {
                        _ = rewards.registerOpenedMap(volcanoID: v.id)   
                    }
                }
            }
            .background(p.background.ignoresSafeArea())
            .navigationDestination(isPresented: $showHistory) {
                FullHistoryView(id: volcanoID)
                    .environmentObject(themeStore)
                    .environmentObject(volcanoes)
                    .environmentObject(rewards)
                    .navigationBarBackButtonHidden()
            }
            
            .navigationDestination(isPresented: $showGallery) {
                GalleryView(id: volcanoID)
                    .environmentObject(themeStore)
                    .environmentObject(volcanoes)
                    .navigationBarBackButtonHidden()
            }
        }
            
    }
}



#Preview {
    let manager = VolcanoManager()
    return VolcanoDetailView(volcanoID: manager.volcanoes.first!.id)
        .environmentObject(ThemeStore())
        .environmentObject(manager)
        .environmentObject(RewardsManager())
}

private struct VolcanoStatusGrid: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let v: Volcano

    private let cols = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {

        LazyVGrid(columns: cols, spacing: 12) {
            StatusCard(
                icon: "flame.fill",
                title: "Status",
                value: v.status.isActive ? "Active" : "Dormant",
                highlight: v.status.isActive
            )

            StatusCard(
                icon: "mountain.2",
                title: "Altitude",
                value: v.status.altitude
            )

            StatusCard(
                icon: "calendar",
                title: "Last Eruption",
                value: v.status.lastEruption
            )

            StatusCard(
                icon: "info.circle",
                title: "Type",
                value: v.status.type
            )
        }
    }
}

private struct StatusCard: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let icon: String
    let title: String
    let value: String
    var highlight: Bool = false

    var body: some View {
        let p = themeStore.palette

        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(highlight ? p.switchTint : p.textMain.opacity(0.9))
                    .font(.system(size: 14, weight: .semibold))

                Text(title)
                    .foregroundStyle(p.textSecond)
                    .font(.customFont(.InterRegular, size: 14))
            }

            if highlight {
                Text(value)
                    .foregroundStyle(.white)
                    .font(.customFont(.InterRegular, size: 16))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(
                        Capsule()
                            .fill(p.switchTint)
                            .shadow(color: p.switchTint.opacity(0.4), radius: 16, x: 0, y: 6)
                    )
            } else {
                Text(value)
                    .foregroundStyle(p.textMain)
                    .font(.customFont(.InterRegular, size: 20))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(themeStore.palette.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(p.textSecond.opacity(0.16), lineWidth: 1)
        )
    }
}

private struct DetailTabSegmentView: View {
    @EnvironmentObject private var themeStore: ThemeStore
    @Binding var selected: DetailTab
    @Namespace private var anim
    
    var body: some View {
        let p = themeStore.palette
        
        HStack(spacing: 0) {
            ForEach(DetailTab.allCases) { tab in
                ZStack {
                    if selected == tab {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(p.cardBackground.opacity(0.8))
                            .matchedGeometryEffect(id: "TAB_FILL", in: anim)
                            .shadow(color: p.switchTint.opacity(0.3), radius: 12, x: 0, y: 6)
                    }
                    
                    Text(tab.rawValue)
                        .font(.customFont(.InterRegular, size: 16))
                        .foregroundStyle(selected == tab ? p.textMain : p.textMain.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selected = tab
                    }
                }
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(p.cardBackground.opacity(0.4))
        )
    }
}

private struct OverviewSection: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let v: Volcano

    var body: some View {
        let p = themeStore.palette

        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 18) {
                Text("History")
                    .foregroundStyle(p.switchTint)
                    .font(.customFont(.InterRegular, size: 18))

                Text(v.historicalOverview)
                    .foregroundStyle(p.textMain)
                    .font(.customFont(.InterRegular, size: 16))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)

                MythologyCallout(title: "⚡ Mythology & Legend",
                                 text: v.mythology)
                .environmentObject(themeStore)
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
            .shadow(color: .black.opacity(0.15), radius: 18, x: 0, y: 10)
            .padding(.horizontal, 16)
        }
    }
}

private struct MythologyCallout: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let title: String
    let text: String

    var body: some View {
        let p = themeStore.palette
        let cardRadius: CGFloat = 22

        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .foregroundStyle(p.switchTint) 
                .font(.customFont(.InterRegular, size: 16))

            Text(text)
                .foregroundStyle(p.textMain.opacity(0.9))
                .font(.customFont(.InterRegular, size: 14))
                .italic()
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
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

private struct LocationSection: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let v: Volcano

    var body: some View {
        let p = themeStore.palette

        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Geographic Data")
                    .foregroundStyle(p.switchTint)
                    .font(.customFont(.InterRegular, size: 20))

                InfoRow(title: "Latitude",  value: v.geographic.latitude)
                InfoRow(title: "Longitude", value: v.geographic.longitude)
                InfoRow(title: "Country",   value: v.geographic.country)

                VolcanoMapCard(
                    latitudeString:  v.geographic.latitude,
                    longitudeString: v.geographic.longitude
                )
                .environmentObject(themeStore)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(themeStore.palette.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(themeStore.palette.textSecond.opacity(0.14), lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
    }

    private struct InfoRow: View {
        @EnvironmentObject private var themeStore: ThemeStore
        let title: String
        let value: String

        var body: some View {
            let p = themeStore.palette
            HStack {
                Text(title)
                    .foregroundStyle(p.textSecond)
                    .font(.customFont(.InterRegular, size: 16))
                Spacer()
                Text(value)
                    .foregroundStyle(p.textMain)
                    .font(.customFont(.InterRegular, size: 18))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.white.opacity(0.05))
            )
        }
    }
}


private struct VolcanoMapCard: View {
    @EnvironmentObject private var themeStore: ThemeStore

    let latitudeString: String
    let longitudeString: String

    @State private var region: MKCoordinateRegion
    private let coordinateItem: VolcanoCoordinate

    init(latitudeString: String, longitudeString: String) {
        self.latitudeString = latitudeString
        self.longitudeString = longitudeString

        let lat = VolcanoMapCard.parseCoordinate(self.latitudeString) ?? 0
        let lon = VolcanoMapCard.parseCoordinate(self.longitudeString) ?? 0
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)

        self.coordinateItem = VolcanoCoordinate(coordinate: coord)

        let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        _region = State(initialValue: MKCoordinateRegion(center: coord, span: span))
    }

    var body: some View {
        let p = themeStore.palette

        ZStack {
            Map(coordinateRegion: $region, annotationItems: [coordinateItem]) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    ZStack {
                        Circle()
                            .fill(p.switchTint.opacity(0.18))
                            .frame(width: 32, height: 32)
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(p.switchTint)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            VStack {
                Spacer()
                Text("Interactive map would display here")
                    .foregroundStyle(themeStore.palette.textSecond)
                    .font(.customFont(.InterRegular, size: 14))
                    .padding(.bottom, 12)
            }
            .allowsHitTesting(false)
        }
        .frame(minHeight: 220)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(themeStore.palette.cardBackground.opacity(0.75))
        )
    }

    private static func parseCoordinate(_ s: String) -> Double? {
        let allowed = CharacterSet(charactersIn: "0123456789.-")
        let filtered = String(s.unicodeScalars.filter { allowed.contains($0) })
        return Double(filtered)
    }
}

private struct FactsSection: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let v: Volcano
    
    var body: some View {
        let p = themeStore.palette
        
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 18) {
                Text("Quick Facts")
                    .foregroundStyle(p.switchTint)
                    .font(.customFont(.InterRegular, size: 20))
                
                VStack(spacing: 12) {
                    ForEach(Array(v.fascinatingFacts.enumerated()), id: \.offset) { index, fact in
                        FactRow(index: index + 1, text: fact)
                            .environmentObject(themeStore)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(themeStore.palette.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(themeStore.palette.textSecond.opacity(0.14), lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
    }
}

private struct FactRow: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let index: Int
    let text: String
    
    var body: some View {
        let p = themeStore.palette
        
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(p.switchTint.opacity(0.25))
                    .frame(width: 32, height: 32)
                Text("\(index)")
                    .foregroundStyle(p.switchTint)
                    .font(.customFont(.InterRegular, size: 16))
            }
            
            Text(text)
                .foregroundStyle(p.textMain)
                .font(.customFont(.InterRegular, size: 16))
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white.opacity(0.05))
        )
    }
}

private struct ActionButtonsRow: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let primaryTitle: String
    let primaryIcon: String
    let secondaryTitle: String
    let secondaryIcon: String
    let onPrimary: () -> Void
    let onSecondary: () -> Void

    var body: some View {
        let p = themeStore.palette

        HStack(spacing: 16) {
            Button(action: onPrimary) {
                HStack(spacing: 12) {
                    Image(systemName: primaryIcon)
                        .font(.system(size: 18, weight: .semibold))
                    Text(primaryTitle)
                        .font(.customFont(.InterRegular, size: 18))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(colors: [.switchTintLight, .switchTintDark],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .shadow(color: p.switchTint.opacity(0.45), radius: 24, x: 0, y: 10)
                )
            }
            .buttonStyle(.plain)

            Button(action: onSecondary) {
                HStack(spacing: 12) {
                    Image(systemName: secondaryIcon)
                        .font(.system(size: 18, weight: .semibold))
                    Text(secondaryTitle)
                        .font(.customFont(.InterRegular, size: 18))
                }
                .foregroundStyle(p.textMain)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(themeStore.palette.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.switchTintLight.opacity(0.1), lineWidth: 1.5)
                )
                .shadow(color: p.switchTint.opacity(0.1), radius: 10, x: 0, y: 6)
            }
            .buttonStyle(.plain)
        }
    }
}
