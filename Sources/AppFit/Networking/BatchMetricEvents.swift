//
//  BatchMetricEvents.swift
//
//
//  Created by Anthony Castelli on 3/19/24.
//

import Foundation

/**
 * Batch Metric Events
 *
 * This creates an a new ``BatcMetricEvents`` model that contains
 * an array of ``MetricEvent's``. This allows you to send a bulk
 * list of events to the API.
 */
internal struct BatchMetricEvents: Codable {
    /**
     * The list of events
     */
    internal let events: [MetricEvent]
}
