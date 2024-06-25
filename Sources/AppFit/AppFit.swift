//
//  AppFit.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * AppFit handles all of the event tracking for the AppFit dashboard.
 *
 * To use the AppFit SDK, you must first initialize it with an ``AppFitConfiguration``.
 *
 * Example:
 * ```swift
 * let configuration = AppFitConfiguration(apiKey: "<key>")
 * let appFit = AppFit(configuration: configuration)
 *
 * // Tracking events
 * appFit.trackEvent(name: "event_name")
 * ```
 *
 * - Parameters:
 *   - configuration: The configuration for the AppFit SDK.
 */
public struct AppFit: Sendable {
    /// The configuration for the AppFit SDK.
    internal let configuration: AppFitConfiguration

    /// The event digester for the AppFit SDK.
    private let eventDigester: Digestible

    /**
     * Initializes the AppFit SDK with an API Key
     *
     * This is a convenience helper to quickly create a new AppFit
     * instance
     *
     * - Parameters:
     *   - apiKey: The API Key for the ``AppFitConfiguration``
     */
    public init(apiKey: String) {
        self.init(configuration: AppFitConfiguration(apiKey: apiKey))
    }

    /**
     * Initializes the AppFit SDK with the provided configuration.
     *
     * A configuration allows customization of the instance.
     * Refer to the ``AppFitConfiguration`` documentation to review
     * all options.
     *
     * - Parameters:
     *   - configuration: The configuration for the AppFit SDK.
     *   - digester: The EventDigester (used for overriding in tests)
     */
    public init(configuration: AppFitConfiguration, digester: Digestible? = nil) {
        self.configuration = configuration
        self.eventDigester = digester ?? EventDigester(apiKey: configuration.apiKey, appVersion: configuration.appVersion, enableIpTracking: configuration.enableIpTracking)
        // Once we boot up the AppFit SDK, we need to generate an anonymousId
        // and set the userId to null. This is to ensure that we have the most
        // up-to-date information for the events.
        self.eventDigester.identify(userId: nil)

        // This is a unique event that is used specifically to track when the
        // AppFit SDK has been initialized.
        // This is an internal event.
        self.trackEvent(name: "appfit_sdk_initialized")
    }

    /**
     * Tracks an event with the provided name and properties.
     *
     * This is used to track events in the AppFit dashboard.
     *
     * - Parameters:
     *   - name: The name of the event.
     *   - properties: The properties of the event.
     */
    public func trackEvent(name: String, properties: [String: Any]? = nil) {
        self.track(event: AppFitEvent(name: name, properties: properties))
    }

    /**
     * Tracks an event with the provided event.
     *
     * This is used to track events in the AppFit dashboard.
     * A event must be an ``AppFitEvent`` and conform to the
     * parameters available on the class.
     *
     * - Parameters:
     *   - event: The event to track.
     */
    public func track(event: AppFitEvent) {
        self.eventDigester.digest(event: event)
    }

    /**
     * Identifies the user with the provided userId.
     *
     * This is used to identify the user in the AppFit dashboard.
     * If the userId is `nil`, the user will be un-identified,
     * resulting in the user being anonymous.
     *
     * - Parameters:
     *   - userId: The unique identifier for the user.
     */
    public func identifyUser(userId: String?) {
        self.eventDigester.identify(userId: userId)

        // This is a unique event that is used specifically to track when the
        // AppFit SDK has been identified a user
        // This is an internal event.
        self.trackEvent(name: "appfit_user_identified")
    }
}
