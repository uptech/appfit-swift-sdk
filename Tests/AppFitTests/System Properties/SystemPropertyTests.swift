//
//  SystemPropertyTests.swift
//  
//
//  Created by Anthony Castelli on 5/21/24.
//

import XCTest
@testable import AppFit

final class SystemPropertyTests: XCTestCase {
    func testSystemProperties() throws {
        let properties = EventSystemProperties(
            appVersion: "1.0.0"
        )

        XCTAssertEqual(properties.appVersion, "1.0.0")
        XCTAssertEqual(properties.device?.manufacturer, "Apple")

        #if os(macOS)
        XCTAssertEqual(properties.operatingSystem?.name, OperatingSystemName.macOS)
        XCTAssertEqual(properties.operatingSystem?.version, "14.4.1")
        #elseif os(iOS)
        XCTAssertEqual(properties.operatingSystem?.name, OperatingSystemName.iOS)
        XCTAssertEqual(properties.operatingSystem?.version, "17.5")
        #endif
    }

    func testSystemPropertyEncoding() throws {
        let properties = EventSystemProperties(
            appVersion: "1.0.0"
        )

        let data = try JSONEncoder().encode(properties)
        let decodedProperties = try JSONSerialization.jsonObject(with: data) as! [String : Any]
        let appVersion = decodedProperties["appVersion"] as! String

        XCTAssertEqual(appVersion, properties.appVersion)
    }
}
