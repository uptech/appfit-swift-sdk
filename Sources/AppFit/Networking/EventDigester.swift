//
//  EventDigester.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * EventDigester takes in events, and handles the caching, posting, and
 * retrying of failed events.
 */
internal final class EventDigester: Sendable {
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
        Task.detached {
            await self.appFitCache.generateAnonymousId()
        }

        Timer.scheduledTimer(withTimeInterval: 15 * 60, repeats: true) { _ in
            self.digestCache()
        }
    }
    
    /// Digests the provided `event`.
    ///
    /// This is used to digest the provided `event` and send it to the AppFit dashboard.
    /// Before any event is sent to the AppFit dashboard, it is first added to the cache.
    /// If the event is successfully sent to the AppFit dashboard, it is removed from the cache,
    /// otherwise it will be retried later.
    internal func digest(event: AppFitEvent) {
        Task.detached {
            await self.cache.add(event: event)
            let rawMetric = await event.convertToRawMetricEvent(userId: self.appFitCache.userId, anonymousId: self.appFitCache.anonymousId)
            let result = try await self.apiClient.sendEvent(rawMetric)
            if result {
                // If the network requests succeeds, remove the event from the cache
                await self.cache.remove(event: event)
            }
        }
    }
    
    /// Identifies the user with the provided `userId`.
    ///
    /// This is used to identify the user in the AppFit dashboard.
    /// When passing is `nil`, the user will be un-identified,
    /// resulting in the user being anonymous.
    internal func identify(userId: String?) {
        Task.detached {
            await self.appFitCache.setUserId(userId)
        }
    }
    
    /// Digests the cache.
    ///
    /// This is used to digest all of the events in the cache that might have failed,
    /// or are pending to be sent to the AppFit dashboard.
    internal func digestCache() {
        Task.detached {
            await self.cache.events.forEach { value in
                self.digest(event: value)
            }
        }
    }
}
