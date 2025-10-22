import Foundation

enum ItemRarity: String, Codable, CaseIterable { case common, rare, epic, legendary }
enum ItemCategory: String, Codable, CaseIterable { case theme, badge, avatarItem }

struct ShopItem: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let price: Int
    let category: ItemCategory
    let rarity: ItemRarity
    let emoji: String
    var isOwned: Bool
}

struct CoinWallet: Codable, Equatable { var balance: Int }

struct PlayerProgress: Codable, Equatable {
    var viewedVolcanoIDs: Set<Int>
    var lifetimeCoinsEarned: Int

    init(viewedVolcanoIDs: Set<Int> = [], lifetimeCoinsEarned: Int = 0) {
        self.viewedVolcanoIDs = viewedVolcanoIDs
        self.lifetimeCoinsEarned = lifetimeCoinsEarned
    }
}

protocol VolcanoProgressSource {
    var totalVolcanoCount: Int { get }
    var viewedVolcanoIDs: Set<Int> { get }
}


enum AchievementKind: Codable, Equatable {
    case firstExplorer
    case volcanoEnthusiast(count: Int)
    case masterExplorer(total: Int)
    case historian(count: Int)
    case cartographer(count: Int)
    case firstPurchase
    case treasureHunter(target: Int)
}

struct Achievement: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let emoji: String
    let rewardCoins: Int
    let kind: AchievementKind

    var isUnlocked: Bool
    var progressCurrent: Int
    var progressTarget: Int
}
