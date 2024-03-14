//
//  AppFitCacheTests.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import XCTest
@testable import AppFit

final class AppFitCacheTests: XCTestCase {
    let cache = AppFitCache()

    override func setUp() async throws {
        await self.cache.setUserId(nil)
    }

    @MainActor
    func testUserIdInitiallyNil() async {
        let expectation = expectation(description: "User id is nil")

        Task {
            let value = await self.cache.userId
            XCTAssertNil(value)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testUserIdSaving() async {
        let expectation = expectation(description: "User id was saved")

        Task {
            await self.cache.setUserId("test")
            let value = await self.cache.userId

            XCTAssertEqual(value, "test")
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testAnonymousIdInitiallyNotNil() async {
        let expectation = expectation(description: "Anonymous id was not nil")

        Task {
            let value = await self.cache.anonymousId

            XCTAssertNotNil(value)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
