//
//  OperatingSystem.swift
//
//
//  Created by Anthony Castelli on 5/21/24.
//

import Foundation

internal enum OperatingSystem: String, Codable {
    case iOS
    case macOS
    case macCatalyst
    case tvOS
    case watchOS
    case visionOS
    case linux
    case other

    static var current: OperatingSystem {
#if os(iOS)
#if targetEnvironment(macCatalyst)
        return OperatingSystem.macCatalyst
#else
        return OperatingSystem.iOS
#endif
#elseif os(macOS)
        return OperatingSystem.macOS
#elseif os(tvOS)
        return OperatingSystem.tvOS
#elseif os(watchOS)
        return OperatingSystem.watchOS
#elseif os(visionOS)
        return OperatingSystem.visionOS
#elseif os(Linux)
        return OperatingSystem.linux
#else
        return OperatingSystem.other
#endif
    }
}
