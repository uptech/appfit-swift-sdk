//
//  MetricEvent.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * An event that is tracked by AppFit.
 */
internal struct MetricEvent: Codable {
    /// The unique identifier for the event.
    internal let eventId: UUID

    /// The name of the event.
    internal let name: String

    /// The user identifier for the event.
    internal let userId: String?

    /// The anonymous identifier for the event.
    internal let anonymousId: String?

    /// The properties of the event.
    internal let properties: [String: String]?

    /// The system properties of the event.
    internal let systemProperties: [String: String]?
}
