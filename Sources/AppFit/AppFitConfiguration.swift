//
//  AppFitConfiguration.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * Configuration for the AppFit SDK.
 * 
 * This is used to initialize the SDK with the apiKey provided by AppFit.
 * - Parameters:
 *   - apiKey: The API key provided by AppFit.
 */
public struct AppFitConfiguration: Codable {
    /// The API key provided by AppFit.
    internal let apiKey: String

    /**
     * Initializes the AppFitConfiguration with the provided API key.
     * - Parameters:
     *   - apiKey: The API key provided by AppFit.
     */
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}
