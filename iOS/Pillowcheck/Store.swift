import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var items: [Item] = []
    @Published var remindersEnabled: Bool = false

    /// Free-tier cap. Deliberately set above the seed-data count so a fresh
    /// install never sees the paywall immediately.
    static let freeLimit = 30

    private let fileName = "pillowcheck_items.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
        if items.isEmpty {
            seed()
            save()
        }
    }

    var isAtLimit: Bool {
        items.count >= Self.freeLimit
    }

    @discardableResult
    func add(_ item: Item) -> Bool {
        guard !isAtLimit else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: Item) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Item) {
        items.removeAll(where: { $0.id == item.id })
        save()
    }

    private func seed() {
        items = [
            Item(name: "Pillow 1", purchaseDate: Calendar.current.date(byAdding: .month, value: -6, to: Date())!, replaceIntervalMonths: 18),\nItem(name: "Pillow 2", purchaseDate: Calendar.current.date(byAdding: .month, value: -12, to: Date())!, replaceIntervalMonths: 18),\nItem(name: "Pillow 3", purchaseDate: Calendar.current.date(byAdding: .month, value: -18, to: Date())!, replaceIntervalMonths: 18)
        ]
    }
    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Item].self, from: data) {
            items = decoded
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
