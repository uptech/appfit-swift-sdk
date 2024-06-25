//
//  AppFitEvent+RawMetricEvent.swift
//
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

extension AppFitEvent {
    internal func convertToRawMetricEvent(
        userId: String?,
        anonymousId: String?,
        appVersion: String?,
        ipAddress: String?
    ) -> MetricEvent {
        return MetricEvent(
            occurredAt: self.date,
            payload: EventPayload(
                sourceEventId: self.id,
                eventName: self.name,
                userId: userId,
                anonymousId: anonymousId,
                properties: self.properties,
                systemProperties: EventSystemProperties(
                    appVersion: appVersion ?? App.current.version,
                    ipAddress: ipAddress
                )
            )
        )
    }
}
