//
//  MetricEvent.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * The version of the MetricEvent
 */
private enum MetricEventVersion: String, Codable {
    case v2 = "2"
}

/// The source of the Event
/// In this case, this will always be `appfit`.
private let AppFitEventSource: String = "appfit"

/**
 * A raw event that is tracked by AppFit.
 */
internal struct MetricEvent: Codable {
    /// Metric Event Version
    ///
    /// The version of the event payload.
    private let version: MetricEventVersion

    /// Event Source
    ///
    /// This declares where the event is coming from
    /// Since this is the AppFit SDK, we just hardcode the
    /// value of it in the `init` method to `appfit`
    internal let eventSource: String

    /// The time the event occurred.
    ///
    /// This is a UTC timestamp in ISO-8601 format.
    internal let occurredAt: Date

    /// The event payload.
    ///
    /// This is the event that is tracked by AppFit.
    internal let payload: EventPayload

    /// Creates a new instance of ``MetricEvent``.
    internal init(
        occurredAt: Date,
        payload: EventPayload
    ) {
        self.version = MetricEventVersion.v2
        self.eventSource = AppFitEventSource
        self.occurredAt = occurredAt
        self.payload = payload
    }
}
