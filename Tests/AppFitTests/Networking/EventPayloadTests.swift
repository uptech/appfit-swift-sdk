//
//  EventPayloadTests.swift
//
//
//  Created by Anthony Castelli on 3/14/24.
//

import XCTest
@testable import AppFit

final class EventPayloadTests: XCTestCase {
    let testEvent = EventPayload(
        sourceEventId: UUID(),
        eventName: "test",
        userId: nil,
        anonymousId: nil,
        properties: ["property": "value"]
    )

    func testEncoding() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self.testEvent)
        let object = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let keys = (object["properties"] as? [String: Any])?.keys

        XCTAssertEqual(self.testEvent.eventName, object["eventName"] as? String)
        XCTAssertEqual(self.testEvent.properties?.keys, keys)
    }

    func testDecoding() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self.testEvent)
        let decoder = JSONDecoder()
        let object = try decoder.decode(EventPayload.self, from: data)

        XCTAssertEqual(self.testEvent.eventName, object.eventName)
        XCTAssertEqual(self.testEvent.properties?.keys, object.properties?.keys)
    }
}
