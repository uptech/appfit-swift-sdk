//
//  EventSystemProperties.swift
//
//
//  Created by Anthony Castelli on 5/21/24.
//

import Foundation

/**
 * Event System Properties
 *
 * These return all of the system properties we generate based on the device type
 * and data we wish to always include in every event.
 */
internal struct EventSystemProperties: Codable {
    enum CodingKeys: String, CodingKey {
        case appVersion
        case device
        case operatingSystem = "os"
    }

    /// The version of the parent bundle
    let appVersion: String?

    /// All of the device related properties
    /// These include anything that is specific to the physical device
    /// such as model, operating system version, platform, etc
    /// Note: Linux is untested and will return nil for this property
    let device: DeviceProperties?

    /// All of the operating system properties
    /// These include the operating system name (i.e. iOS or macOS)
    /// and the version number (i.e. 17.5.1)
    /// Note: Linux is untested and will return an empty string for the version.
    let operatingSystem: OperatingSystem?

    init(
        appVersion: String? = App.current.version,
        device: DeviceProperties? = DeviceProperties.current,
        operatingSystem: OperatingSystem? = OperatingSystem.current
    ) {
        self.appVersion = appVersion
        self.device = device
        self.operatingSystem = operatingSystem
    }
}
