//
//  SystemProperties.swift
//  
//
//  Created by Anthony Castelli on 5/21/24.
//

import Foundation

/**
 * The System Properties
 *
 * These return all of the system properties we generate based on the device type
 * and data we wish to always include in every event.
 */
internal struct SystemProperties: Codable {
    /// The Origin of the SDK. This is a hard-coded property that will never change
    /// The value is `swift`
    let origin: String

    /// The version of the parent bundle
    let appVersion: String?

    /// All of the device related properties
    /// These include anything that is specific to the physical device
    /// such as model, operating system version, platform, etc
    let device: DeviceProperties

    init(
        origin: String = "swift",
        appVersion: String? = App.current.version,
        device: DeviceProperties = DeviceProperties.current
    ) {
        self.origin = origin
        self.appVersion = appVersion
        self.device = device
    }
}
