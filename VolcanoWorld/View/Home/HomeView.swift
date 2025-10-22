//
//  HomeView.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 13.10.2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var themeStore: ThemeStore
    @EnvironmentObject private var rewardsManager: RewardsManager
    @EnvironmentObject private var volcanoes: VolcanoManager
    @State private var showFavoritesOnly: Bool = false
    @State private var searchText: String = ""
    @State private var selectedCountry: String? = nil
    @State private var showVolcano = false
    @State private var volcanoID = 0
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Image(.loadingLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 2)
                    HStack {
                        Text("Explore volcanoes & earn rewards!")
                            .foregroundStyle(.white)
                            .font(.customFont(.JockeyRegular, size: 14))
                        Spacer()
                    }
                    
                }
                HStack(spacing: 7) {
                    Image(.balance)
                    
                    Text("\(rewardsManager.balance)")
                        .foregroundStyle(.white)
                        .font(.customFont(.JockeyRegular, size: 20))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background() {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white.opacity(0.2))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.switchTintLight, lineWidth: 2)
                    
                }
                
            }
            .headerBackground()
            
            ScrollView {
            TopModeSelector(
                isFavorites: showFavoritesOnly,
                onChange: { showFavoritesOnly = $0 }
            )
            .environmentObject(themeStore)
            .padding(16)
            
            SearchBar(text: $searchText)
                .environmentObject(themeStore)
                .padding(.horizontal, 16)
            
            CountryChips(
                countries: allCountries,
                selected: $selectedCountry
            )
            .environmentObject(themeStore)
            
                if filteredVolcanoes.isEmpty {
                    VStack(spacing: 6) {
                        Spacer()
                        Image(systemName: "flame")
                            .font(.largeTitle)
                            .foregroundStyle(themeStore.palette.textMain)
                            .padding(.bottom)

                        Text("No volcanoes found")
                            .foregroundStyle(themeStore.palette.textMain)
                            .font(.customFont(.InterRegular, size: 16))

                        Text("Add some volcanoes to your favorites!")
                            .foregroundStyle(themeStore.palette.textMain)
                            .font(.customFont(.InterRegular, size: 14))
                        Spacer()
                    }
                    .frame(minHeight: UIScreen.main.bounds.height * 0.25)
                }
            
                LazyVStack(spacing: 14, pinnedViews: []) {
                    ForEach(filteredVolcanoes) { v in
                        VolcanoListCard(volcano: v)
                            .environmentObject(themeStore)
                            .onTapGesture {
                                volcanoes.markViewed(v.id)
                                volcanoID = v.id
                                showVolcano.toggle()
                            }
                            .contextMenu {
                                Button {
                                    volcanoes.toggleFavorite(v.id)
                                } label: {
                                    Label(v.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                                          systemImage: v.isFavorite ? "heart.slash" : "heart")
                                }
                            }
                    }
                }
                .padding(.top, 6)
                .padding(.horizontal, 16)
            }
        }
        .navigationDestination(isPresented: $showVolcano) {
            VolcanoDetailView(volcanoID: volcanoID)
                .navigationBarBackButtonHidden()
                .environmentObject(themeStore)
                .environmentObject(volcanoes)
                .environmentObject(rewardsManager)
        }
    }
    private var allCountries: [String] {
        let set = Set(volcanoes.volcanoes.map { $0.geographic.country })
        
        return Array(set).sorted()
    }
    
    private var filteredVolcanoes: [Volcano] {
        volcanoes.volcanoes.filter { v in
            if showFavoritesOnly && !v.isFavorite { return false }
            
            if let c = selectedCountry, v.geographic.country != c { return false }
            
            if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let q = searchText.lowercased()
                let hay =
                "\(v.name) \(v.overview) \(v.historicalOverview) \(v.geographic.country)"
                    .lowercased()
                if !hay.contains(q) { return false }
            }
            
            return true
        }
    }
}

#Preview {
    MainTabBar()
        .environmentObject(ThemeStore())
        .environmentObject(RewardsManager())
        .environmentObject(VolcanoManager())
}

private struct TopModeSelector: View {
    @EnvironmentObject private var themeStore: ThemeStore
    
    let isFavorites: Bool
    let onChange: (Bool) -> Void
    
    var body: some View {
        
        HStack(spacing: 18) {
            PillButton(
                title: "All Volcanoes",
                systemImage: "list.bullet",
                isActive: !isFavorites,
                onTap: { onChange(false) }
            )
            .environmentObject(themeStore)
            
            
            PillButton(
                title: "Favorites",
                systemImage: "heart",
                isActive: isFavorites,
                onTap: { onChange(true) }
            )
            .environmentObject(themeStore)
            
        }
    }
}

private struct PillButton: View {
    @EnvironmentObject private var themeStore: ThemeStore
    
    let title: String
    let systemImage: String
    let isActive: Bool
    let onTap: () -> Void
    
    var body: some View {
        let p = themeStore.palette
        
        Button(action: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                onTap()
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isActive ? .backgroundLight : p.textMain)
                Text(title)
                    .font(.customFont(.InterSemiBold, size: 14))
                    .foregroundStyle(isActive ? .backgroundLight : p.textMain)
            }
            .foregroundStyle(isActive ? Color.white : .backgroundLight)
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(isActive ? .switchTintDark : p.cardBackground)
                    .shadow(color: .switchTintDark.opacity(0.35), radius: 10, x: 0, y: 0)
                
            )
            
        }
        .buttonStyle(.plain)
    }
}

import SwiftUI

struct SearchBar: View {
    @EnvironmentObject private var themeStore: ThemeStore
    @Binding var text: String
    
    var placeholder: String = "Search volcanoes..."
    @FocusState private var isFocused: Bool  // для скрытия клавиатуры
    
    var body: some View {
        let p = themeStore.palette
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(p.textSecond)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(p.textSecond.opacity(0.6))
                        .font(.customFont(.InterRegular, size: 16))
                }
                
                TextField("", text: $text)
                    .font(.customFont(.InterRegular, size: 16))
                    .foregroundStyle(p.textMain)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($isFocused)
            }
            
            if !text.isEmpty {
                Button {
                    text = ""
                    isFocused = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(p.textSecond.opacity(0.6))
                }
                .buttonStyle(.plain)
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(height: 32)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(p.cardBackground.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(p.switchTint.opacity(0.25), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: text) // плавное появление/пропадание крестика
    }
}


struct CountryChips: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let countries: [String]
    @Binding var selected: String?

    var body: some View {
        let p = themeStore.palette

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                CountryChip(
                    title: "All",
                    isActive: selected == nil,
                    onTap: { withAnimation(.easeInOut(duration: 0.18)) { selected = nil } }
                )
                .environmentObject(themeStore)

                ForEach(countries, id: \.self) { country in
                    CountryChip(
                        title: country,
                        isActive: selected == country,
                        onTap: { withAnimation(.easeInOut(duration: 0.18)) { selected = country } }
                    )
                    .environmentObject(themeStore)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(p.background.opacity(0.0001))
        }
    }
}

private struct CountryChip: View {
    @EnvironmentObject private var themeStore: ThemeStore
    
    let title: String
    let isActive: Bool
    let onTap: () -> Void
    
    var body: some View {
        let p = themeStore.palette
        let isAll = (title == "All")
        
        Button(action: onTap) {
            HStack(spacing: 8) {
                if isAll {
                    Image(systemName: "flame")
                        .font(.system(size: 14, weight: .bold))
                }
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

struct VolcanoListCard: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let volcano: Volcano
    
    var body: some View {
        let p = themeStore.palette
        
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(p.cardBackground)
                .shadow(color: p.textSecond.opacity(0.12), radius: 14, x: 0, y: 8)
            
            VStack(spacing: 0) {
                LinearGradient(colors: [p.switchTint.opacity(0.95), p.switchTint.opacity(0.6)],
                               startPoint: .leading, endPoint: .trailing)
                .frame(height: 10)
                .mask(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .padding(.bottom, 120)
                )
                Spacer(minLength: 0)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Text(volcano.name)
                        .foregroundStyle(p.switchTint)
                        .font(.customFont(.JockeyRegular, size: 28))
                    
                    Spacer(minLength: 12)
                    
                    StatusBadge(isActive: volcano.status.isActive)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(p.textSecond)
                    Text(volcano.geographic.country)
                        .foregroundStyle(p.textMain)
                        .font(.customFont(.InterRegular, size: 18))
                }
                
                HStack(spacing: 18) {
                    HStack(spacing: 8) {
                        Image(systemName: "mountain.2.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(p.textSecond)
                        Text(volcano.status.altitude)
                            .foregroundStyle(p.textMain)
                            .font(.customFont(.InterRegular, size: 18))
                    }
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(p.textSecond)
                        Text(volcano.status.lastEruption)
                            .foregroundStyle(p.textMain)
                            .font(.customFont(.InterRegular, size: 18))
                    }
                }
                
                Text(volcano.overview)
                    .foregroundStyle(p.textMain)
                    .font(.customFont(.InterRegular, size: 18))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(volcano.status.type)
                        .font(.customFont(.InterRegular, size: 16))
                        .foregroundStyle(p.textMain)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(p.cardBackground.opacity(0.75))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(p.textSecond.opacity(0.18), lineWidth: 1)
                        )
                    Spacer()
                }
            }
            .padding(18)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(p.textSecond.opacity(0.16), lineWidth: 1)
        )
    }
}

private struct StatusBadge: View {
    @EnvironmentObject private var themeStore: ThemeStore
    let isActive: Bool
    
    var body: some View {
        let p = themeStore.palette
        let title = isActive ? "Active" : "Dormant"
        HStack(spacing: 8) {
            Image(systemName: "flame.fill")
                .font(.system(size: 16, weight: .bold))
            Text(title)
                .font(.customFont(.InterRegular, size: 18))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(p.switchTint)
                .shadow(color: p.switchTint.opacity(0.45), radius: 18, x: 0, y: 8)
        )
    }
}
