import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [MilestoneEntry] = []
    @Published var isPro: Bool = false

    static let freeLimit = 15

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Milestone", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: MilestoneEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: MilestoneEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(id: UUID) {
        entries.removeAll { $0.id == id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([MilestoneEntry].self, from: data) {
            entries = decoded
        } else {
            entries = Store.seedData
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static let seedData: [MilestoneEntry] = [
        MilestoneEntry(title: "First Milestone", stage: stageOptions[0], date: Date(), note: "Tap + to add your own."),
    ]
}
