//
//  APIClientTests.swift
//  
//
//  Created by Anthony Castelli on 3/18/24.
//

import XCTest
@testable import AppFit

final class APIClientTests: XCTestCase {
    let client = APIClient(
        apiKey: "YjZiODczMjItNTAwNC00YTg5LTg2ZTUtOWI3OWE5ZDA5Mjc3OmQ3OGMyMjVhLTc1YzQtNDY5ZC1iZTk5LTY3ZTZiMWM1ZDI5YQ=="
    )

    func testSendingEvent() async throws {
        let ipAddress = try await IPAddress().fetchIpAddress()
        
        let event = MetricEvent(
            occurredAt: Date(),
            payload: EventPayload(
                sourceEventId: UUID(),
                eventName: "unit_test",
                userId: nil,
                anonymousId: "xcode_75fbf7a3-2197-4353-9b39-baedf4628c68",
                properties: ["language": "swift"],
                systemProperties: EventSystemProperties(ipAddress: ipAddress)
            )
        )
        do {
            try await self.client.sendEvent(event)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testSendingBatchEvents() async throws {
        let ipAddress = try await IPAddress().fetchIpAddress()

        let event = MetricEvent(
            occurredAt: Date(),
            payload: EventPayload(
                sourceEventId: UUID(),
                eventName: "unit_test",
                userId: nil,
                anonymousId: "xcode_75fbf7a3-2197-4353-9b39-baedf4628c68",
                properties: ["language": "swift"],
                systemProperties: EventSystemProperties(ipAddress: ipAddress)
            )
        )
        do {
            try await self.client.sendEvents([event])
        } catch {
            XCTFail("\(error)")
        }
    }
}
