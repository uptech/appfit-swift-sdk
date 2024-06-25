//
//  AppFitConfiguration.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * Configuration for the AppFit SDK.
 * 
 * This is used to initialize the SDK with the apiKey provided by AppFit.
 *
 * Example:
 * ```swift
 * let configuration = AppFitConfiguration(apiKey: "<key>")
 * ```
 *
 * - Parameters:
 *   - apiKey: The API key provided by AppFit.
 */
public struct AppFitConfiguration: Codable, Sendable {
    /// The API key provided by AppFit.
    internal let apiKey: String

    /// The version of the Host App
    /// Override this to pass in your own version string.
    internal let appVersion: String?

    /// IP Tracking
    /// This allows you to enable/disable IP address tracking
    ///
    /// Note: Disabling this will remove the location data from the event
    internal let enableIpTracking: Bool

    /**
     * Initializes the AppFitConfiguration with the provided API key.
     * - Parameters:
     *   - apiKey: The API key provided by AppFit.
     *   - appVersion: The version of the app implementing the SDK
     *   - enableIpTracking: Enable/Disable IP Tracking
     */
    public init(
        apiKey: String,
        appVersion: String? = nil,
        enableIpTracking: Bool = true
    ) {
        self.apiKey = apiKey
        self.appVersion = appVersion ?? App.current.version
        self.enableIpTracking = enableIpTracking
    }
}
