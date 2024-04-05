//
//  RawMetricEventTests.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import XCTest
@testable import AppFit

final class RawMetricEventTests: XCTestCase {
    let testEvent = RawMetricEvent(
        occurredAt: Date(),
        payload: MetricEvent(
            eventId: UUID(),
            name: "test",
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
        XCTAssertEqual(self.testEvent.payload.name, payload["name"] as? String)
        XCTAssertNil(self.testEvent.payload.properties)
    }

    func testDecoding() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self.testEvent)
        let decoder = JSONDecoder()
        let object = try decoder.decode(RawMetricEvent.self, from: data)

        XCTAssertEqual(self.testEvent.occurredAt, object.occurredAt)
        XCTAssertEqual(self.testEvent.payload.name, object.payload.name)
        XCTAssertEqual(self.testEvent.payload.properties?.keys, object.payload.properties?.keys)
    }
}
