//
//  VolcanoManager.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 15.10.2025.
//

import Foundation
import Combine

@MainActor
final class VolcanoManager: ObservableObject {

    @Published private(set) var volcanoes: [Volcano]
    @Published private(set) var viewedVolcanoIDs: Set<Int>

    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.outputFormatting = [.sortedKeys]
        return e
    }()
    private let decoder = JSONDecoder()

    private enum Keys {
        static let volcanoes = "vw.volcanoes"
        static let viewedIDs = "vw.viewed.ids"
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        if let data = userDefaults.data(forKey: Keys.volcanoes),
           let saved = try? decoder.decode([Volcano].self, from: data) {
            self.volcanoes = saved
        } else {
            self.volcanoes = defaultVolcanoes
        }

        if let data = userDefaults.data(forKey: Keys.viewedIDs),
           let saved = try? decoder.decode(Set<Int>.self, from: data) {
            self.viewedVolcanoIDs = saved
        } else {
            self.viewedVolcanoIDs = []
        }

        saveAll()
    }

    var totalVolcanoCount: Int { volcanoes.count }

    var favorites: [Volcano] { volcanoes.filter { $0.isFavorite } }

    var totalUserPhotosCount: Int {
        volcanoes.reduce(0) { $0 + $1.userPhotos.count }
    }

    func volcano(by id: Int) -> Volcano? {
        volcanoes.first(where: { $0.id == id })
    }


    @discardableResult
    func markViewed(_ id: Int) -> Bool {
        let inserted = viewedVolcanoIDs.insert(id).inserted
        if inserted { saveViewed() }
        return inserted
    }

    func toggleFavorite(_ id: Int) {
        guard let idx = volcanoes.firstIndex(where: { $0.id == id }) else { return }
        volcanoes[idx].isFavorite.toggle()
        saveVolcanoes()
    }

    func setFavorite(_ id: Int, _ isFavorite: Bool) {
        guard let idx = volcanoes.firstIndex(where: { $0.id == id }) else { return }
        if volcanoes[idx].isFavorite != isFavorite {
            volcanoes[idx].isFavorite = isFavorite
            saveVolcanoes()
        }
    }

    @discardableResult
    func addUserPhoto(_ id: Int, data: Data) -> Int? {
        guard let idx = volcanoes.firstIndex(where: { $0.id == id }) else { return nil }
        volcanoes[idx].userPhotos.append(data)
        saveVolcanoes()
        return volcanoes[idx].userPhotos.count - 1
    }

    func removeUserPhoto(_ id: Int, at photoIndex: Int) {
        guard let idx = volcanoes.firstIndex(where: { $0.id == id }) else { return }
        guard volcanoes[idx].userPhotos.indices.contains(photoIndex) else { return }
        volcanoes[idx].userPhotos.remove(at: photoIndex)
        saveVolcanoes()
    }

    func replaceUserPhoto(_ id: Int, at photoIndex: Int, with newData: Data) {
        guard let idx = volcanoes.firstIndex(where: { $0.id == id }) else { return }
        guard volcanoes[idx].userPhotos.indices.contains(photoIndex) else { return }
        volcanoes[idx].userPhotos[photoIndex] = newData
        saveVolcanoes()
    }

    func setUserPhotos(_ id: Int, photos: [Data]) {
        guard let idx = volcanoes.firstIndex(where: { $0.id == id }) else { return }
        volcanoes[idx].userPhotos = photos
        saveVolcanoes()
    }

    private func saveVolcanoes() {
        if let data = try? encoder.encode(volcanoes) {
            userDefaults.set(data, forKey: Keys.volcanoes)
        }
    }

    private func saveViewed() {
        if let data = try? encoder.encode(viewedVolcanoIDs) {
            userDefaults.set(data, forKey: Keys.viewedIDs)
        }
    }

    private func saveAll() {
        saveVolcanoes()
        saveViewed()
    }
}

extension VolcanoManager: VolcanoProgressSource {}
