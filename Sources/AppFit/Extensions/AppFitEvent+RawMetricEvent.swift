//
//  AppFitEvent+RawMetricEvent.swift
//
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

extension AppFitEvent {
    internal func convertToRawMetricEvent(userId: String?, anonymousId: String?) -> RawMetricEvent {
        // For now, we are going to hard-code the system properties with the one key that we need.
        // Eventually we need to make this dynamic and move this to another place as we will be
        // fetching system properties of the device.
        let systemProperties: [String: Any] = [
            "origin": "swift"
        ]

        return RawMetricEvent(
            occurredAt: self.date,
            payload: MetricEvent(
                eventId: self.id,
                name: self.name,
                userId: userId,
                anonymousId: anonymousId,
                properties: self.properties,
                systemProperties: systemProperties
            )
        )
    }
}
