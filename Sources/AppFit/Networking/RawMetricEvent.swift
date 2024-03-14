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

    /// Creates a new instance of [RawMetricEvent].
    internal init(occurredAt: Date, payload: MetricEvent) {
        self.occurredAt = occurredAt
        self.payload = payload
    }
}
