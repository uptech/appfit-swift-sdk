//
//  AppFit.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * AppFit handles all of the event tracking for the AppFit dashboard.
 * To use the AppFit SDK, you must first initialize it with an AppFitConfiguration.
 * - Parameters:
 *   - configuration: The configuration for the AppFit SDK.
 */
public struct AppFit: Sendable {
    /// The configuration for the AppFit SDK.
    internal let configuration: AppFitConfiguration

    /// The event digester for the AppFit SDK.
    private let eventDigester: EventDigester

    /**
     * Initializes the AppFit SDK with the provided configuration.
     * - Parameters:
     *   - configuration: The configuration for the AppFit SDK.
     */
    public init(configuration: AppFitConfiguration) {
        self.configuration = configuration
        self.eventDigester = EventDigester(apiKey: configuration.apiKey)
        // Once we boot up the AppFit SDK, we need to generate an anonymousId
        // and set the userId to null. This is to ensure that we have the most
        // up-to-date information for the events.
        self.eventDigester.identify(userId: nil)
    }

    /**
     * Tracks an event with the provided eventName and properties.
     * This is used to track events in the AppFit dashboard.
     * - Parameters:
     *   - name: The name of the event.
     *   - properties: The properties of the event.
     */
    public func trackEvent(name: String, properties: [String: String]?) {
        self.track(event: AppFitEvent(name: name, properties: properties))
    }

    /**
     * Tracks an event with the provided event.
     * This is used to track events in the AppFit dashboard.
     * - Parameters:
     *   - event: The event to track.
     */
    public func track(event: AppFitEvent) {
        self.eventDigester.digest(event: event)
    }

    /**
     * Identifies the user with the provided userId.
     * This is used to identify the user in the AppFit dashboard.
     * If the userId is `nil`, the user will be un-identified,
     * resulting in the user being anonymous.
     * - Parameters:
     *   - userId: The unique identifier for the user.
     */
    public func identifyUser(userId: String?) {
        self.eventDigester.identify(userId: userId)
    }
}
