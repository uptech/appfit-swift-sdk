//
//  DeviceProperties.swift
//
//
//  Created by Anthony Castelli on 5/21/24.
//

import Foundation

/**
 * Device Properties
 *
 * These includes all of the metadata related tothe device
 */
internal struct DeviceProperties: Codable {
    /// The overall device platform. Refer to ``Platform``
    /// for more info
    let platform: Platform

    /// The Platform (iOS, tvOS
    let operatingSystem: OperatingSystem

    /// The Operating System Version (14.4.1)
    let operatingSystemVersion: String

    /// The Device Family (i.e. Mac)
    let family: DeviceFamily

    /// The Device Model (MacBookPro18,4)
    let model: String

    init(
        platform: Platform,
        operatingSystem: OperatingSystem,
        operatingSystemVersion: String,
        family: DeviceFamily,
        model: String
    ) {
        self.platform = platform
        self.operatingSystem = operatingSystem
        self.operatingSystemVersion = operatingSystemVersion
        self.family = family
        self.model = model
    }

    /// Returns the current properties of the device
    static let current = DeviceProperties(
        platform: Platform.current,
        operatingSystem: OperatingSystem.current,
        operatingSystemVersion: Device.current.operatingSystemVersion,
        family: DeviceFamily.current,
        model: Device.current.model
    )
}
