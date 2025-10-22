
import Foundation

let defaultVolcanoCount = 8

let defaultWallet = CoinWallet(balance: 0)

let defaultAchievements: [Achievement] = [
    Achievement(
        id: "first_explorer",
        title: "First Explorer",
        subtitle: "View your first volcano",
        emoji: "🌋",
        rewardCoins: 100,
        kind: .firstExplorer,
        isUnlocked: false,
        progressCurrent: 0,
        progressTarget: 1
    ),
    Achievement(
        id: "volcano_enthusiast",
        title: "Volcano Enthusiast",
        subtitle: "Explore 5 different volcanoes",
        emoji: "🔥",
        rewardCoins: 500,
        kind: .volcanoEnthusiast(count: 5),
        isUnlocked: false,
        progressCurrent: 0,
        progressTarget: 5
    ),
    Achievement(
        id: "master_explorer",
        title: "Master Explorer",
        subtitle: "Discover all volcanoes",
        emoji: "⭐",
        rewardCoins: 3000,
        kind: .masterExplorer(total: defaultVolcanoCount),
        isUnlocked: false,
        progressCurrent: 0,
        progressTarget: defaultVolcanoCount
    ),
    Achievement(
        id: "historian",
        title: "Historian",
        subtitle: "Open Full History on 5 volcanoes",
        emoji: "📖",
        rewardCoins: 800,
        kind: .historian(count: 5),
        isUnlocked: false,
        progressCurrent: 0,
        progressTarget: 5
    ),
    Achievement(
        id: "cartographer",
        title: "Cartographer",
        subtitle: "Open Location/Map on 5 volcanoes",
        emoji: "🗺️",
        rewardCoins: 800,
        kind: .cartographer(count: 5),
        isUnlocked: false,
        progressCurrent: 0,
        progressTarget: 5
    ),
    Achievement(
        id: "first_purchase",
        title: "First Purchase",
        subtitle: "Buy any item in the shop",
        emoji: "🛍️",
        rewardCoins: 300,
        kind: .firstPurchase,
        isUnlocked: false,
        progressCurrent: 0,
        progressTarget: 1
    ),
    
    Achievement(
        id: "treasure_hunter",
        title: "Treasure Hunter",
        subtitle: "Collect 1000 lava coins",
        emoji: "🏆",
        rewardCoins: 0,
        kind: .treasureHunter(target: 1000),
        isUnlocked: false,
        progressCurrent: 0,
        progressTarget: 1000
    )
]

let defaultShopItems: [ShopItem] = [
    ShopItem(id: "theme_volcanic", title: "Volcanic Theme", description: "Exclusive dark theme with lava effects", price: 500, category: .theme, rarity: .rare, emoji: "🌋", isOwned: false),
    ShopItem(id: "badge_explorer", title: "Explorer Badge", description: "Show off your explorer status", price: 200, category: .badge, rarity: .common, emoji: "🏅", isOwned: false),
    ShopItem(id: "shirt_volcano_lovers", title: "Volcano Lovers Shirt", description: "Virtual shirt for volcano enthusiasts", price: 300, category: .avatarItem, rarity: .common, emoji: "👕", isOwned: false),
    ShopItem(id: "badge_lava_master", title: "Lava Master Badge", description: "Legendary badge for true masters", price: 1000, category: .badge, rarity: .legendary, emoji: "🔥", isOwned: false),
    ShopItem(id: "cap_volcano", title: "Volcano Cap", description: "Stylish cap for volcano explorers", price: 250, category: .avatarItem, rarity: .common, emoji: "🧢", isOwned: false),
    ShopItem(id: "frame_golden_photo", title: "Golden Photo Frame", description: "Premium frame for your best photos", price: 400, category: .badge, rarity: .rare, emoji: "🖼️", isOwned: false),
    ShopItem(id: "badge_crystal_volcano", title: "Crystal Volcano Badge", description: "Rare crystalline badge", price: 750, category: .badge, rarity: .epic, emoji: "💎", isOwned: false),
    ShopItem(id: "crown_of_fire", title: "Crown of Fire", description: "Ultimate volcanic crown", price: 2000, category: .avatarItem, rarity: .legendary, emoji: "👑", isOwned: false)
]
