//
//  DeviceFamily.swift
//
//
//  Created by Anthony Castelli on 5/21/24.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal enum DeviceFamily: String, Codable {
    case iPad = "iPad"
    case iPhone = "iPhone"
    case carPlay = "Car Play"
    case watch = "Apple Watch"
    case tv = "TV"
    case vision = "Apple Vision"
    case mac = "Mac"
    case other = "Other"

    static var current: DeviceFamily {
#if os(iOS)
#if targetEnvironment(macCatalyst)
        return DeviceFamily.mac
#else
        // The iOS Case can be any of these, so we need
        // to base it off of the Interface Idiom
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return DeviceFamily.iPhone
        case .pad: return DeviceFamily.iPad
        case .tv: return DeviceFamily.tv
        case .carPlay: return DeviceFamily.carPlay
        case .mac: return DeviceFamily.mac
        case .vision: return DeviceFamily.vision
        case .unspecified: return DeviceFamily.other
        @unknown default: return DeviceFamily.other
        }
#endif
#elseif os(macOS)
        return DeviceFamily.mac
#elseif os(tvOS)
        return DeviceFamily.tv
#elseif os(watchOS)
        return DeviceFamily.watch
#elseif os(visionOS)
        return DeviceFamily.vision
#else
        return DeviceFamily.other
#endif
    }
}
