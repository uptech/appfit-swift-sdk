//
//  AppFitEvent+RawMetricEvent.swift
//
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

extension AppFitEvent {
    internal func convertToRawMetricEvent(userId: String?, anonymousId: String?, systemProperties: SystemProperties?) -> RawMetricEvent {
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
