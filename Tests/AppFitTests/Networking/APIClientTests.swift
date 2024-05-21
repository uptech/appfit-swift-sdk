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
        let event = RawMetricEvent(
            occurredAt: Date(),
            payload: MetricEvent(
                eventId: UUID(),
                name: "unit_test",
                userId: nil,
                anonymousId: "xcode_75fbf7a3-2197-4353-9b39-baedf4628c68",
                properties: ["language": "swift"],
                systemProperties: SystemProperties(
                    network: NetworkProperties(
                        ip: "127.0.0.1"
                    ),
                    location: LocationProperties(
                        continent: "North America",
                        country: "United States of America",
                        countryCode: "USA",
                        region: "Florida",
                        city: "Sarasota",
                        postalCode: "34239",
                        latitude: 27.30810,
                        longitude: -82.50982
                    )
                )
            )
        )
        let result = try await self.client.sendEvent(event)

        XCTAssertTrue(result)
    }

    func testSendingBatchEvents() async throws {
        let event = RawMetricEvent(
            occurredAt: Date(),
            payload: MetricEvent(
                eventId: UUID(),
                name: "unit_test",
                userId: nil,
                anonymousId: "xcode_75fbf7a3-2197-4353-9b39-baedf4628c68",
                properties: ["language": "swift"],
                systemProperties: SystemProperties(
                    network: NetworkProperties(
                        ip: "127.0.0.1"
                    ),
                    location: LocationProperties(
                        continent: "North America",
                        country: "United States of America",
                        countryCode: "USA",
                        region: "Florida",
                        city: "Sarasota",
                        postalCode: "34239",
                        latitude: 27.30810,
                        longitude: -82.50982
                    )
                )
            )
        )
        let result = try await self.client.sendEvents([event])

        XCTAssertTrue(result)
    }
}
