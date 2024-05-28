//
//  EventDigester.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

public protocol Digestible: Sendable {
    func digest(event: AppFitEvent)
    func identify(userId: String?)
}

/**
 * EventDigester takes in events, and handles the caching, posting, and
 * retrying of failed events.
 */
internal struct EventDigester: Digestible {
    /// The API key for the project.
    internal let apiKey: String

    /// The cache for the events.
    internal let cache = EventCache()

    /// The cache for the AppFit SDK.
    internal let appFitCache = AppFitCache()

    /// The API client for the AppFit dashboard.
    internal let apiClient: APIClient

    /// Initializes the `EventDigester` with the provided `apiKey`.
    internal init(apiKey: String) {
        self.apiKey = apiKey
        self.apiClient = APIClient(apiKey: apiKey)

        Timer.scheduledTimer(withTimeInterval: 15 * 60, repeats: true) { [self] _ in
            self.digestCache()
        }
    }
    
    /// Digests the provided `event`.
    ///
    /// This is used to digest the provided `event` and send it to the AppFit dashboard.
    /// The event is sent directly to AppFit. If it fails, we add it to the cache, and
    /// wait for the digester to perform the batch send of cached events.
    internal func digest(event: AppFitEvent) {
        Task {
            let rawMetric = await event.convertToRawMetricEvent(
                userId: self.appFitCache.userId,
                anonymousId: self.appFitCache.anonymousId
            )
            let result = try await self.apiClient.sendEvent(rawMetric)

            // If the network requests succeeds, remove the event from the cache
            switch result {
            case true: break // For now, we just do nothing.
            case false: await self.cache.add(event: event)
            }
        }
    }
    
    /// Identifies the user with the provided `userId`.
    ///
    /// This is used to identify the user in the AppFit dashboard.
    /// When passing is `nil`, the user will be un-identified,
    /// resulting in the user being anonymous.
    internal func identify(userId: String?) {
        Task {
            await self.appFitCache.setUserId(userId)
        }
    }
    
    /// Digests the cache.
    ///
    /// This is used to digest all of the events in the cache that might have failed,
    /// or are pending to be sent to the AppFit dashboard.
    internal func digestCache() {
        Task {
            let cachedEvents = await self.cache.events
            let userId = await self.appFitCache.userId
            let anonymousId = await self.appFitCache.anonymousId
            let rawEvents = cachedEvents.map({ $0.convertToRawMetricEvent(userId: userId, anonymousId: anonymousId) })
            let result = try await self.apiClient.sendEvents(rawEvents)

            // If the network requests succeeds, remove all the events from cache
            switch result {
            case true: await self.cache.clear()
            case false: break // For now, we just do nothing.
            }
        }
    }
}
