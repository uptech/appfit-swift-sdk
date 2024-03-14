//
//  EventCache.swift
//
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * EventCache caches events that have been or need to be tracked.
 */
internal actor EventCache {
    private var cache: [String: AppFitEvent] = [:]

    /**
     * The events that have been cached.
     */
    internal var events: [AppFitEvent] {
        return Array(self.cache.values)
    }

    /**
     * Adds an event to the cache.
     * - Parameters:
     *   - event: The event to add.
     */
    func add(event: AppFitEvent) {
        self.cache[event.id.uuidString] = event
    }

    /**
     * Removes an event from the cache.
     * - Parameters:
     *   - id: The id of the event to remove.
     */
    func remove(id: String) {
        self.cache.removeValue(forKey: id)
    }

    /**
     * Removes an event from the cache.
     * - Parameters:
     *   - event: The event to remove.
     */
    func remove(event: AppFitEvent) {
        self.remove(id: event.id.uuidString)
    }

    /**
     * Clears the cache.
     */
    func clear() {
        self.cache.removeAll()
    }
}
