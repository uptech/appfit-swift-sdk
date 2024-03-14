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

    internal init() {
        Task.detached {
            await self.readDataFromDisk()
        }
    }

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
    internal func add(event: AppFitEvent) {
        self.cache[event.id.uuidString] = event
        self.saveDataToDisk()
    }

    /**
     * Removes an event from the cache.
     * - Parameters:
     *   - id: The id of the event to remove.
     */
    internal func remove(id: String) {
        self.cache.removeValue(forKey: id)
        self.saveDataToDisk()
    }

    /**
     * Removes an event from the cache.
     * - Parameters:
     *   - event: The event to remove.
     */
    internal func remove(event: AppFitEvent) {
        self.remove(id: event.id.uuidString)
        self.saveDataToDisk()
    }

    /**
     * Clears the cache.
     */
    internal func clear() {
        self.cache.removeAll()
        self.saveDataToDisk()
    }
}

extension EventCache {
    /// Reads the data from disk
    private func readDataFromDisk() {
        do {
            let data = try Data(contentsOf: self.cachePath())
            let decoder = JSONDecoder()
            let cache = try decoder.decode([AppFitEvent].self, from: data)
            self.cache = Dictionary(uniqueKeysWithValues: cache.map({ ($0.id.uuidString, $0) }))
        } catch {
            print("[EventCache] Error reading cache: \(error)")
        }
    }

    /// Writes the data to disk
    private func saveDataToDisk() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.events)
            try data.write(to: self.cachePath(), options: [.atomic])
        } catch {
            print("[EventCache] Error writing cache \(error)")
        }
    }

    /// Helper method for building out the path directory
    func cachePath() throws -> URL {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            let documents =  URL.documentsDirectory.appending(component: "appfit")
            try FileManager.default.createDirectory(at: documents, withIntermediateDirectories: true)
            return documents.appending(component: "cache.af")
        } else {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths.first!
            let cacheFolder = documentsDirectory.appendingPathComponent("appfit")
            try FileManager.default.createDirectory(at: cacheFolder, withIntermediateDirectories: true)
            return cacheFolder.appendingPathComponent("cache.af")
        }
    }
}
