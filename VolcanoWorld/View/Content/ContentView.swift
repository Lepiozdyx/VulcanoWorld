//
//  ContentView.swift
//  VolcanoWorld
//

import SwiftUI

struct ContentView: View {
    @StateObject private var themeStore = ThemeStore()
    @StateObject private var rewards = RewardsManager()
    @StateObject private var volcanoes = VolcanoManager()
    @StateObject private var manager = AppStateManager()
        
    var body: some View {
        Group {
            switch manager.appState {
            case .request:
                LoadingView()
                
            case .support:
                if let url = manager.networkManager.gameURL {
                    WKWebViewManager(
                        url: url,
                        webManager: manager.networkManager
                    )
                } else {
                    WKWebViewManager(
                        url: NetworkManager.initialURL,
                        webManager: manager.networkManager
                    )
                }
                
            case .loading:
                MainTabBar()
                    .environmentObject(themeStore)
                    .environmentObject(rewards)
                    .environmentObject(volcanoes)
                    .preferredColorScheme(themeStore.preferredColorScheme)
            }
        }
        .onAppear {
            manager.stateRequest()
        }
    }
}

#Preview {
    ContentView()
}
