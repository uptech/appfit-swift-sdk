//
//  BatchRawMetricEvents.swift
//
//
//  Created by Anthony Castelli on 3/19/24.
//

import Foundation

/**
 * Batch Raw Metric Events
 *
 * This creates an a new ``BatchRawMetricEvent`` model that contains
 * an array of ``RawMetricEvent's``. This allows you to send a bulk
 * list of events to the API.
 */
internal struct BatchRawMetricEvents: Codable {
    /**
     * The list of events
     */
    internal let events: [RawMetricEvent]
}
