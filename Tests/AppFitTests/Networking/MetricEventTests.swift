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
        eventId: UUID(),
        name: "test",
        userId: nil,
        anonymousId: nil,
        properties: ["property": "value"],
        systemProperties: nil
    )

    func testEncoding() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self.testEvent)
        let object = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        XCTAssertEqual(self.testEvent.name, object["name"] as? String)
        XCTAssertEqual(self.testEvent.properties, object["properties"] as? [String: String])
        XCTAssertEqual(self.testEvent.properties?["property"], (object["properties"] as! [String: String])["property"])
    }

    func testDecoding() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self.testEvent)
        let decoder = JSONDecoder()
        let object = try decoder.decode(MetricEvent.self, from: data)

        XCTAssertEqual(self.testEvent.name, object.name)
        XCTAssertEqual(self.testEvent.properties, object.properties)
        XCTAssertEqual(self.testEvent.properties?["property"], object.properties?["property"])
    }
}
