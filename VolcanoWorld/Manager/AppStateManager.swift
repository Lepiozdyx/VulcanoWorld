//
//  AppStateManager.swift
//  VolcanoWorld

import Foundation
import Combine
import FirebaseMessaging

@MainActor
final class AppStateManager: ObservableObject {
    enum States {
        case first
        case second
        case final
    }
    
    @Published private(set) var appState: States = .first
    let webManager: NetworkManager
    
    private var timeoutTask: Task<Void, Never>?
    private let maxLoadingTime: TimeInterval = 7.0
    
    init(webManager: NetworkManager) {
        self.webManager = webManager
    }
    
    convenience init() {
        self.init(webManager: NetworkManager())
    }
    
    func stateCheck() {
        timeoutTask?.cancel()
        
        Task { @MainActor in
            do {
                if webManager.volcanoUrl != nil {
                    updateState(.second)
                    return
                }
                
                let shouldShowWebView = try await webManager.checkInitialURL()
                
                if shouldShowWebView {
                    updateState(.second)
                } else {
                    updateState(.final)
                }
            } catch {
                updateState(.final)
            }
        }
        
        startTimeoutTask()
    }
    
    private func updateState(_ newState: States) {
        timeoutTask?.cancel()
        timeoutTask = nil
        appState = newState
    }
    
    private func startTimeoutTask() {
        timeoutTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: UInt64(maxLoadingTime * 1_000_000_000))
                
                if self.appState == .first {
                    self.appState = .final
                }
            } catch {
                print("Timeout task cancelled")
            }
        }
    }
    
    deinit {
        timeoutTask?.cancel()
    }
}

class FcmTokenManager: ObservableObject {
    static let shared = FcmTokenManager()
    
    @Published private(set) var fcmToken: String?
    private var continuation: CheckedContinuation<String, Never>?
    
    private init() {}
    
    func setToken(_ token: String) {
        self.fcmToken = token
        continuation?.resume(returning: token)
        continuation = nil
    }
    
    func waitForToken() async -> String {
        if let existingToken = fcmToken {
            return existingToken
        }
        
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
        }
    }
}
