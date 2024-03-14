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

    override func setUp() async throws {
        await self.cache.clear()
    }

    func testSaving() async {
        let expectation = expectation(description: "Test Saving")

        Task {
            await self.cache.add(event: AppFitEvent(name: "test"))
            let value = await self.cache.events.count

            XCTAssertEqual(value, 1)
            expectation.fulfill()
        }


        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testSavingMultiple() async {
        let expectation = expectation(description: "Test Saving Multiple")

        Task {
            await self.cache.add(event: AppFitEvent(name: "test 1"))
            await self.cache.add(event: AppFitEvent(name: "test 2"))
            await self.cache.add(event: AppFitEvent(name: "test 3"))
            await self.cache.add(event: AppFitEvent(name: "test 4"))
            let value = await self.cache.events.count

            XCTAssertEqual(value, 4)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testRemoveByEvent() async {
        let expectation = expectation(description: "Test Remove by Event")

        Task {
            let event = AppFitEvent(name: "test")
            await self.cache.add(event: event)
            
            let savedCount = await self.cache.events.count
            XCTAssertEqual(savedCount, 1)

            await self.cache.remove(event: event)
            let removedCount = await self.cache.events.count

            XCTAssertEqual(removedCount, 0)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testRemoveById() async {
        let expectation = expectation(description: "Test Remove by Id")

        Task {
            let event = AppFitEvent(name: "test")
            await self.cache.add(event: event)
            let savedCount = await self.cache.events.count

            XCTAssertEqual(savedCount, 1)

            await self.cache.remove(id: event.id.uuidString)
            let removedCount = await self.cache.events.count

            XCTAssertEqual(removedCount, 0)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
