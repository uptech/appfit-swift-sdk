//
//  RawMetricEvent.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * A raw event that is tracked by AppFit.
 */
internal struct RawMetricEvent: Codable {
    /// The time the event occurred.
    ///
    /// This is a UTC timestamp.
    internal let occurredAt: Date

    /// The event payload.
    ///
    /// This is the event that is tracked by AppFit.
    internal let payload: MetricEvent

    /// Event Source
    ///
    /// This declares where the event is coming from
    /// Since this is the AppFit SDK, we just hardcode the
    /// value of it in the `init` method to `appfit`
    internal let eventSource: String

    /// Creates a new instance of [RawMetricEvent].
    internal init(occurredAt: Date, payload: MetricEvent) {
        self.occurredAt = occurredAt
        self.payload = payload
        self.eventSource = "appfit"
    }
}
