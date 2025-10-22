//
//  RootView.swift
//  VolcanoWorld

import SwiftUI

struct ContentView: View {
    @StateObject private var themeStore = ThemeStore()
    @StateObject private var rewards = RewardsManager()
    @StateObject private var volcanoes = VolcanoManager()
    @StateObject private var state = AppStateManager()
    @StateObject private var fcmManager = FcmTokenManager.shared
        
    var body: some View {
        Group {
            switch state.appState {
            case .first:
                LoadingView()
            case .second:
                if let url = state.webManager.volcanoUrl {
                    WebViewManager(url: url, webManager: state.webManager)
                } else if let fcmToken = fcmManager.fcmToken {
                    WebViewManager(
                        url: NetworkManager.getInitialURL(fcmToken: fcmToken),
                        webManager: state.webManager
                    )
                } else {
                    WebViewManager(
                        url: NetworkManager.initialURL,
                        webManager: state.webManager
                    )
                }
            case .final:
                MainTabBar()
                    .environmentObject(themeStore)
                    .environmentObject(rewards)
                    .environmentObject(volcanoes)
                    .preferredColorScheme(themeStore.preferredColorScheme)
            }
        }
        .onAppear {
            state.stateCheck()
        }
    }
}

#Preview {
    ContentView()
}
