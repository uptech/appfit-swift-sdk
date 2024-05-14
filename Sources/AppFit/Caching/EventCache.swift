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
    /// Local in-memory cache
    private var cache: [AppFitEvent] = []

    /// Ininitializtion method
    ///
    /// This instantiates a new EventCache class
    /// - Parameters:
    ///     - writeToDiskInterval: This allows you to configure how frequently we write to disk.
    ///     This currently defaults to 5 minutes.
    internal init(
        writeToDiskInterval: TimeInterval = 5 * 60
    ) {
        Task {
            await self.read()
        }

        // Repeat every 5 minutes
        Timer.scheduledTimer(withTimeInterval: writeToDiskInterval, repeats: true) { _ in
            Task {
                await self.save()
            }
        }
    }

    /// Save everything to disk
    private func save() {
        self.writeDataToDisk()
    }

    /// Read everything from disk
    func read() {
        self.cache = self.readDataFromDisk()
    }

    /// On deinitialization we want to clean up
    deinit {
        // Clean up and write everything to disk
        Task {
            await self.writeDataToDisk()
        }
    }

    /**
     * The events that have been cached.
     */
    internal var events: [AppFitEvent] {
        return self.cache
    }

    /**
     * Adds an event to the cache.
     * - Parameters:
     *   - event: The event to add.
     */
    internal func add(event: AppFitEvent) {
        if self.cache.contains(event) {
            self.remove(event: event)
        }
        self.cache.append(event)
    }

    /**
     * Removes an event from the cache.
     * - Parameters:
     *   - id: The id of the event to remove.
     */
    internal func remove(id: String) {
        self.cache.removeAll(where: { $0.id.uuidString == id })
    }

    /**
     * Removes an event from the cache.
     * - Parameters:
     *   - event: The event to remove.
     */
    internal func remove(event: AppFitEvent) {
        self.remove(id: event.id.uuidString)
    }

    /**
     * Clears the cache.
     */
    internal func clear() {
        self.cache.removeAll()
        self.writeDataToDisk()
    }
}

// MARK: Disk IO
extension EventCache {
    /// Reads the data from disk
    func readDataFromDisk() -> [AppFitEvent] {
        do {
            let data = try Data(contentsOf: self.cachePath())
            let decoder = JSONDecoder()
            let cache = try decoder.decode([AppFitEvent].self, from: data)
            return cache
        } catch {
            return []
        }
    }

    /// Writes the data to disk
    func writeDataToDisk() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.cache)
            try data.write(to: self.cachePath(), options: [.atomic])
        } catch {
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
