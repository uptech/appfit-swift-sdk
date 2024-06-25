//
//  MetricEventTests.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import XCTest
@testable import AppFit

final class MetricEventTests: XCTestCase {
    let testEvent = MetricEvent(
        occurredAt: Date(),
        payload: EventPayload(
            sourceEventId: UUID(),
            eventName: "test",
            userId: nil,
            anonymousId: nil,
            properties: nil,
            systemProperties: nil
        )
    )

    func testEncoding() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self.testEvent)
        let object = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let payload = object["payload"] as! [String: Any]

        XCTAssertNotNil(object["occurredAt"])
        XCTAssertEqual(self.testEvent.payload.eventName, payload["eventName"] as? String)
        XCTAssertNil(self.testEvent.payload.properties)
    }

    func testDecoding() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self.testEvent)
        let decoder = JSONDecoder()
        let object = try decoder.decode(MetricEvent.self, from: data)

        XCTAssertEqual(self.testEvent.occurredAt, object.occurredAt)
        XCTAssertEqual(self.testEvent.payload.eventName, object.payload.eventName)
        XCTAssertEqual(self.testEvent.payload.properties?.keys, object.payload.properties?.keys)
    }

    func testAppFitEventToRawEvent() throws {
        let event = AppFitEvent(name: "test", properties: ["key": "value"])
        let rawEvent = event.convertToRawMetricEvent(
            userId: nil,
            anonymousId: nil,
            appVersion: nil,
            ipAddress: nil
        )

        XCTAssertEqual(event.name, rawEvent.payload.eventName)
        XCTAssertEqual(rawEvent.payload.origin, "swift")
    }
}
