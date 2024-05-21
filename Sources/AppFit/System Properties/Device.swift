//
//  Device.swift
//
//
//  Created by Anthony Castelli on 5/21/24.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

#if canImport(IOKit)
import IOKit
#endif

internal struct Device {
    static let current = Device()

    /// The Model of the Device (MacBookPro18,1 or iPhone18,1)
    var model: String {
#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        let model = UIDevice.current.model
        if model == "arm64" || model == "i386" || model == "x86_64" {
            guard let simulator = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] else {
                return "Simulator"
            }
            let cleaned = simulator
                .components(separatedBy: CharacterSet.decimalDigits)
                .joined()
                .replacingOccurrences(of: ",", with: "")
            return "\(cleaned) Simulator"
        }
        return model
#elseif os(macOS)
        return ProcessInfo.processInfo.deviceModel ?? "Unknown"
#endif
    }

    /// Operating Syetem Verison (14.4.1)
    var operatingSystemVersion: String {
#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        return UIDevice.current.systemVersion
#elseif os(macOS)
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
#endif
    }
}

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
extension UIDevice {
    var model: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        return identifier
    }
}
#elseif os(macOS)
extension ProcessInfo {
    var deviceModel: String? {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        defer {
            IOObjectRelease(service)
        }

        guard
            let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data,
            let cDeviceModel = String(data: modelData, encoding: .utf8)?.cString(using: .utf8) // Remove trailing NULL character
        else { return nil }
        return String(cString: cDeviceModel).trimmingCharacters(in: .controlCharacters)
    }
}
#endif
