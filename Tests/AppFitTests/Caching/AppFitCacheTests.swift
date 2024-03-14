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

    override func setUpWithError() throws {
        self.cache.userId = nil
    }

    func testUserIdInitiallyNil() throws {
        XCTAssertNil(self.cache.userId)
    }

    func testUserIdSaving() throws {
        self.cache.userId = "test"
        XCTAssertEqual(self.cache.userId, "test")
    }

    func testAnonymousIdInitiallyNotNil() throws {
        XCTAssertNotNil(self.cache.anonymousId)
    }
}
