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
 * These includes all of the metadata related to the device
 */
internal struct DeviceProperties: Codable {
    /// The Device Manufacturer (Apple)
    let manufacturer: String

    /// The Device Model (MacBookPro18,4)
    let model: String

    init(
        manufacturer: String,
        model: String
    ) {
        self.manufacturer = manufacturer
        self.model = model
    }

    /// Returns the current properties of the device
    static let current: DeviceProperties? = {
        #if os(Linux)
        return nil
        #else
        return DeviceProperties(
            manufacturer: "Apple",
            model: Device.current.modelIdentifier
        )
        #endif
    }()
}
