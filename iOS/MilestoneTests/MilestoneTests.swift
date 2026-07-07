import XCTest
@testable import Milestone

@MainActor
final class MilestoneTests: XCTestCase {
    func makeStore() -> Store {
        Store()
    }

    func testSeedDataLoadedOnFreshInstall() {
        let store = makeStore()
        XCTAssertFalse(store.entries.isEmpty)
    }

    func testSeedCountIsBelowFreeLimit() {
        XCTAssertLessThan(Store.seedData.count, Store.freeLimit)
    }

    func testAddEntryIncreasesCount() {
        let store = makeStore()
        let before = store.entries.count
        store.add(MilestoneEntry(title: "Test", stage: MilestoneEntry.stageOptions[0], date: Date(), note: ""))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testCanAddMoreWhenUnderLimitAndNotPro() {
        let store = makeStore()
        store.isPro = false
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtLimitAndNotPro() {
        let store = makeStore()
        store.isPro = false
        for i in 0..<Store.freeLimit {
            store.add(MilestoneEntry(title: "Item \(i)", stage: MilestoneEntry.stageOptions[0], date: Date(), note: ""))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenProRegardlessOfCount() {
        let store = makeStore()
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(MilestoneEntry(title: "Item \(i)", stage: MilestoneEntry.stageOptions[0], date: Date(), note: ""))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testDeleteRemovesEntry() {
        let store = makeStore()
        let entry = MilestoneEntry(title: "ToDelete", stage: MilestoneEntry.stageOptions[0], date: Date(), note: "")
        store.add(entry)
        store.delete(id: entry.id)
        XCTAssertFalse(store.entries.contains(where: { $0.id == entry.id }))
    }

    func testUpdateEntryChangesFields() {
        let store = makeStore()
        var entry = MilestoneEntry(title: "Orig", stage: MilestoneEntry.stageOptions[0], date: Date(), note: "")
        store.add(entry)
        entry.title = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.title, "Updated")
    }
}
