//
//  OperatingSystem.swift
//
//
//  Created by Anthony Castelli on 5/21/24.
//

import Foundation

/**
 * Operating System Name
 */
internal enum OperatingSystemName: String, Codable {
    case iOS
    case macOS
    case macCatalyst
    case tvOS
    case watchOS
    case visionOS
    case linux
    case other

    static var current: OperatingSystemName {
#if os(iOS)
#if targetEnvironment(macCatalyst)
        return OperatingSystemName.macCatalyst
#else
        return OperatingSystemName.iOS
#endif
#elseif os(macOS)
        return OperatingSystemName.macOS
#elseif os(tvOS)
        return OperatingSystemName.tvOS
#elseif os(watchOS)
        return OperatingSystemName.watchOS
#elseif os(visionOS)
        return OperatingSystemName.visionOS
#elseif os(Linux)
        return OperatingSystemName.linux
#else
        return OperatingSystemName.other
#endif
    }
}

/**
 * Operating System
 *
 * Returns all of the information around the operting system
 */
internal struct OperatingSystem: Codable {
    /// Operating System Name
    ///
    /// This returns the name of the operating system
    /// Example: iOS, macOS, tvOS, etc
    let name: OperatingSystemName

    /// Operating System Version
    ///
    /// This will follow APple's Semantic Versioning
    /// so it will return a string similar to major.minor.path (i.e. 17.5.1)
    ///
    /// Note: Linux is untested so the version will return an empty string
    let version: String

    init(
        name: OperatingSystemName,
        version: String
    ) {
        self.name = name
        self.version = version
    }

    /// Returns the current properties of the device
    static let current: OperatingSystem? = {
        return OperatingSystem(
            name: OperatingSystemName.current,
            version: Device.current.operatingSystemVersion
        )
    }()
}
