//
//  File.swift
//  
//
//  Created by Anthony Castelli on 6/3/24.
//

import Foundation

public enum AppFitError: Error {
    /// An invalid API key was used
    case invalidApiKey

    /// No inrternet available
    case noInternet

    /// Failed to enocde the data
    case encodingFailed

    /// Network request failed
    case networkRequestFailed

    /// Tracking an event failed
    case trackingEventFailed

    /// Failed to read the cache from disk
    case failedReadingCache

    /// Fail ed to write cache to disk
    case failedSavingCache
}

extension AppFitError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidApiKey: return "Invalid API was used. Please make sure you entered it correctly."
        case .noInternet: return "No internet available. Please make sure you have a network connection."
        case .encodingFailed: return "There was an error encoding the data."
        case .networkRequestFailed: return "The network request failed. Please try again."
        case .trackingEventFailed: return "Event tracking failed."
        case .failedReadingCache: return "Failed to read local cache."
        case .failedSavingCache: return "Failed to save cache locally."
        }
    }
}
