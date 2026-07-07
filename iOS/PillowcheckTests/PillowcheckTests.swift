import XCTest
@testable import Pillowcheck

@MainActor
final class PillowcheckTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataIsBelowFreeLimit() {
        XCTAssertLessThan(store.items.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        let added = store.add(Item(name: "Test Pillow", purchaseDate: Date(), replaceIntervalMonths: 12))
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testAddRespectsFreeLimit() {
        for _ in 0..<(Store.freeLimit + 5) {
            _ = store.add(Item(name: "Test Pillow", purchaseDate: Date(), replaceIntervalMonths: 12))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit)
    }

    func testIsAtLimitBecomesTrue() {
        for _ in 0..<Store.freeLimit {
            _ = store.add(Item(name: "Test Pillow", purchaseDate: Date(), replaceIntervalMonths: 12))
        }
        XCTAssertTrue(store.isAtLimit)
    }

    func testDeleteRemovesItem() {
        _ = store.add(Item(name: "Test Pillow", purchaseDate: Date(), replaceIntervalMonths: 12))
        let before = store.items.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, before - 1)
    }

    func testAddBeyondLimitReturnsFalse() {
        for _ in 0..<Store.freeLimit {
            _ = store.add(Item(name: "Test Pillow", purchaseDate: Date(), replaceIntervalMonths: 12))
        }
        let result = store.add(Item(name: "Test Pillow", purchaseDate: Date(), replaceIntervalMonths: 12))
        XCTAssertFalse(result)
    }

    func testDeleteSpecificItem() {
        let item = Item(name: "Test Pillow", purchaseDate: Date(), replaceIntervalMonths: 12)
        _ = store.add(item)
        let before = store.items.count
        store.delete(item)
        XCTAssertEqual(store.items.count, before - 1)
    }
}
