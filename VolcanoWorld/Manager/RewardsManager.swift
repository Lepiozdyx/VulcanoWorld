//
//  RewardsManager.swift
//  VolcanoWorld
//

import SwiftUI
import Combine

struct RewardResult: Equatable {
    let coinsDelta: Int
    let unlockedAchievementIDs: [String]
}

@MainActor
final class RewardsManager: ObservableObject {
    private enum Keys {
        static let wallet        = "rw.v3.wallet"
        static let progress      = "rw.v3.progress"
        static let achievements  = "rw.v3.achievements"
        static let shopItems     = "rw.v3.shop"

        static let openedHistoryIDs = "rw.v3.opened.history.ids"
        static let openedMapIDs     = "rw.v3.opened.map.ids"
    }

    private let encoder: JSONEncoder = { let e = JSONEncoder(); e.outputFormatting = [.sortedKeys]; return e }()
    private let decoder = JSONDecoder()
    private let userDefaults: UserDefaults

    // public state
    @Published private(set) var wallet: CoinWallet
    @Published private(set) var progress: PlayerProgress
    @Published private(set) var achievements: [Achievement]
    @Published private(set) var shopItems: [ShopItem]

    @Published private(set) var openedHistoryIDs: Set<Int>
    @Published private(set) var openedMapIDs: Set<Int>

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        self.wallet       = Self.load(CoinWallet.self,       key: Keys.wallet,       decoder: decoder, from: userDefaults) ?? defaultWallet
        self.progress     = Self.load(PlayerProgress.self,   key: Keys.progress,     decoder: decoder, from: userDefaults) ?? PlayerProgress()
        self.achievements = Self.load([Achievement].self,    key: Keys.achievements, decoder: decoder, from: userDefaults) ?? defaultAchievements
        self.shopItems    = Self.load([ShopItem].self,       key: Keys.shopItems,    decoder: decoder, from: userDefaults) ?? defaultShopItems
        self.openedHistoryIDs = Self.load(Set<Int>.self,     key: Keys.openedHistoryIDs, decoder: decoder, from: userDefaults) ?? []
        self.openedMapIDs     = Self.load(Set<Int>.self,     key: Keys.openedMapIDs,     decoder: decoder, from: userDefaults) ?? []
        
        let unlocked = shopItems.contains { $0.id == "theme_volcanic" && $0.isOwned }
        UserDefaults.standard.set(unlocked, forKey: "volcanicThemeUnlocked")
        
        saveAll()
    }

    var balance: Int { wallet.balance }
    var achievementsUnlockedCount: Int { achievements.filter { $0.isUnlocked }.count }
    var ownedItemIDs: Set<String> { Set(shopItems.filter { $0.isOwned }.map { $0.id }) }


    @discardableResult
    func registerView(volcanoID: Int, source: VolcanoProgressSource) -> RewardResult {
        progress.viewedVolcanoIDs = source.viewedVolcanoIDs
        let unlocked = updateAfterViews(total: source.totalVolcanoCount)
        saveAll()
        return RewardResult(coinsDelta: 0, unlockedAchievementIDs: unlocked)
    }

    @discardableResult
    func registerOpenedHistory(volcanoID: Int) -> RewardResult {
        let inserted = openedHistoryIDs.insert(volcanoID).inserted
        guard inserted else { return RewardResult(coinsDelta: 0, unlockedAchievementIDs: []) }
        let unlocked = updateAfterHistorian()
        saveAll()
        return RewardResult(coinsDelta: 0, unlockedAchievementIDs: unlocked)
    }

    @discardableResult
    func registerOpenedMap(volcanoID: Int) -> RewardResult {
        let inserted = openedMapIDs.insert(volcanoID).inserted
        guard inserted else { return RewardResult(coinsDelta: 0, unlockedAchievementIDs: []) }
        let unlocked = updateAfterCartographer()
        saveAll()
        return RewardResult(coinsDelta: 0, unlockedAchievementIDs: unlocked)
    }

    @discardableResult
    func addCoins(_ amount: Int) -> RewardResult {
        guard amount > 0 else { return RewardResult(coinsDelta: 0, unlockedAchievementIDs: []) }
        wallet.balance += amount
        progress.lifetimeCoinsEarned += amount
        let extra = updateTreasureHunterIfNeeded()
        saveAll()
        return RewardResult(coinsDelta: amount, unlockedAchievementIDs: extra)
    }

    @discardableResult
    func purchase(itemID: String) -> Bool {
        guard let idx = shopItems.firstIndex(where: { $0.id == itemID }) else { return false }
        guard shopItems[idx].isOwned == false else { return false }
        let price = shopItems[idx].price
        guard wallet.balance >= price else { return false }
        
        wallet.balance -= price
        shopItems[idx].isOwned = true
        
        if itemID == "theme_volcanic" {
            UserDefaults.standard.set(true, forKey: "volcanicThemeUnlocked")
        }
        
        _ = updateAfterFirstPurchase()
        saveAll()
        return true
    }

    private func unlockIfReady(_ a: inout Achievement, bucket: inout [String]) {
        if a.progressCurrent >= a.progressTarget, !a.isUnlocked {
            a.isUnlocked = true
            if a.rewardCoins > 0 {
                wallet.balance += a.rewardCoins
                progress.lifetimeCoinsEarned += a.rewardCoins
            }
            bucket.append(a.id)
        }
    }

    private func updateAfterViews(total: Int) -> [String] {
        var unlocked: [String] = []
        for i in achievements.indices {
            var a = achievements[i]
            switch a.kind {
            case .firstExplorer:
                a.progressCurrent = progress.viewedVolcanoIDs.isEmpty ? 0 : 1
            case .volcanoEnthusiast(let need):
                a.progressCurrent = min(need, progress.viewedVolcanoIDs.count)
            case .masterExplorer(let totalNeeded):
                let t = min(totalNeeded, total)
                a.progressTarget = t
                a.progressCurrent = min(t, progress.viewedVolcanoIDs.count)
            default: break
            }
            if a.progressCurrent >= a.progressTarget, !a.isUnlocked {
                a.isUnlocked = true
                if a.rewardCoins > 0 {
                    wallet.balance += a.rewardCoins
                    progress.lifetimeCoinsEarned += a.rewardCoins
                }
                unlocked.append(a.id)
            }
            achievements[i] = a
        }
        unlocked.append(contentsOf: updateTreasureHunterIfNeeded())
        return unlocked
    }

    private func updateAfterHistorian() -> [String] {
        var unlocked: [String] = []
        for i in achievements.indices {
            var a = achievements[i]
            if case .historian(let need) = a.kind {
                a.progressCurrent = min(need, openedHistoryIDs.count)
                if a.progressCurrent >= a.progressTarget, !a.isUnlocked {
                    a.isUnlocked = true
                    if a.rewardCoins > 0 {
                        wallet.balance += a.rewardCoins
                        progress.lifetimeCoinsEarned += a.rewardCoins
                    }
                    unlocked.append(a.id)
                }
            }
            achievements[i] = a
        }
        unlocked.append(contentsOf: updateTreasureHunterIfNeeded())
        return unlocked
    }

    private func updateAfterCartographer() -> [String] {
        var unlocked: [String] = []
        for i in achievements.indices {
            var a = achievements[i]
            if case .cartographer(let need) = a.kind {
                a.progressCurrent = min(need, openedMapIDs.count)
                if a.progressCurrent >= a.progressTarget, !a.isUnlocked {
                    a.isUnlocked = true
                    if a.rewardCoins > 0 {
                        wallet.balance += a.rewardCoins
                        progress.lifetimeCoinsEarned += a.rewardCoins
                    }
                    unlocked.append(a.id)
                }
            }
            achievements[i] = a
        }
        unlocked.append(contentsOf: updateTreasureHunterIfNeeded())
        return unlocked
    }

    private func updateAfterFirstPurchase() -> [String] {
        var unlocked: [String] = []
        for i in achievements.indices {
            var a = achievements[i]
            if case .firstPurchase = a.kind {
                a.progressCurrent = 1
                if a.progressCurrent >= a.progressTarget, !a.isUnlocked {
                    a.isUnlocked = true
                    if a.rewardCoins > 0 {
                        wallet.balance += a.rewardCoins
                        progress.lifetimeCoinsEarned += a.rewardCoins
                    }
                    unlocked.append(a.id)
                }
            }
            achievements[i] = a
        }
        unlocked.append(contentsOf: updateTreasureHunterIfNeeded())
        return unlocked
    }
    
    private func updateTreasureHunterIfNeeded() -> [String] {
        var unlocked: [String] = []
        for i in achievements.indices {
            var a = achievements[i]
            if case .treasureHunter(let target) = a.kind {
                a.progressTarget = target
                a.progressCurrent = min(target, progress.lifetimeCoinsEarned)
                if a.progressCurrent >= a.progressTarget, !a.isUnlocked {
                    a.isUnlocked = true
                    unlocked.append(a.id)
                }
                achievements[i] = a
            }
        }
        return unlocked
    }

    private func saveAll() {
        Self.save(wallet,       key: Keys.wallet,       encoder: encoder, to: userDefaults)
        Self.save(progress,     key: Keys.progress,     encoder: encoder, to: userDefaults)
        Self.save(achievements, key: Keys.achievements, encoder: encoder, to: userDefaults)
        Self.save(shopItems,    key: Keys.shopItems,    encoder: encoder, to: userDefaults)
        Self.save(openedHistoryIDs, key: Keys.openedHistoryIDs, encoder: encoder, to: userDefaults)
        Self.save(openedMapIDs,     key: Keys.openedMapIDs,     encoder: encoder, to: userDefaults)
    }

    private static func save<T: Codable>(_ value: T, key: String, encoder: JSONEncoder, to userDefaults: UserDefaults) {
        if let data = try? encoder.encode(value) { userDefaults.set(data, forKey: key) }
    }
    private static func load<T: Codable>(_ type: T.Type, key: String, decoder: JSONDecoder, from userDefaults: UserDefaults) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
}
