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
        let properties = SystemProperties(
            appVersion: "1.0.0"
        )

        XCTAssertEqual(properties.appVersion, "1.0.0")
        XCTAssertEqual(properties.device.platform, Platform.apple)

        #if os(macOS)
        XCTAssertEqual(properties.device.family, DeviceFamily.mac)
        XCTAssertEqual(properties.device.model, "MacBookPro18,4")
        XCTAssertEqual(properties.device.operatingSystem, OperatingSystem.macOS)
        XCTAssertEqual(properties.device.operatingSystemVersion, "14.4.1")
        #else
        XCTAssertEqual(properties.device.family, DeviceFamily.iPhone)
        XCTAssertEqual(properties.device.model, "iPhone Simulator")
        XCTAssertEqual(properties.device.operatingSystem, OperatingSystem.iOS)
        XCTAssertEqual(properties.device.operatingSystemVersion, "17.5")
        #endif
    }

    func testSystemPropertyEncoding() throws {
        let properties = SystemProperties(
            appVersion: "1.0.0"
        )

        let data = try JSONEncoder().encode(properties)
        let decodedProperties = try JSONSerialization.jsonObject(with: data) as! [String : Any]
        let appVersion = decodedProperties["appVersion"] as! String

        XCTAssertEqual(appVersion, properties.appVersion)
    }
}
