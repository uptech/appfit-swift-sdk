//
//  EventCacheTests.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import XCTest
@testable import AppFit

final class EventCacheTests: XCTestCase {
    let cache = EventCache()

    override func setUpWithError() throws {
        self.cache.clear()
    }

    func testSaving() throws {
        self.cache.add(event: AppFitEvent(name: "test"))

        XCTAssertEqual(self.cache.events.count, 1)
    }

    func testSavingMultiple() throws {
        self.cache.add(event: AppFitEvent(name: "test 1"))
        self.cache.add(event: AppFitEvent(name: "test 2"))
        self.cache.add(event: AppFitEvent(name: "test 3"))
        self.cache.add(event: AppFitEvent(name: "test 4"))

        XCTAssertEqual(self.cache.events.count, 4)
    }

    func testRemoveByEvent() throws {
        let event = AppFitEvent(name: "test")
        self.cache.add(event: event)

        XCTAssertEqual(self.cache.events.count, 1)

        self.cache.remove(event: event)

        XCTAssertEqual(self.cache.events.count, 0)
    }

    func testRemoveById() throws {
        let event = AppFitEvent(name: "test")
        self.cache.add(event: event)

        XCTAssertEqual(self.cache.events.count, 1)

        self.cache.remove(id: event.id.uuidString)

        XCTAssertEqual(self.cache.events.count, 0)
    }
}
