//
//  AppFitEvent.swift
//
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * An event that can be sent to AppFit
 * - Parameters:
 *   - name: The name of the event
 *   - properties: The properties of the event
 */
public struct AppFitEvent: Codable, Sendable {
    /// The unique identifier for the event
    internal let id: UUID

    /// The date the event was created
    internal let date: Date

    /// The name of the event
    public let name: String

    /// The properties of the event
    public let properties: [String: String]?

    /**
     Initializes an AppFitEvent with the provided name and properties.
     - Parameters:
        - name: The name of the event.
        - properties: The properties of the event.
     */
    public init(
        name: String,
        properties: [String : String]? = nil
    ) {
        self.id = UUID()
        self.date = Date()
        self.name = name
        self.properties = properties
    }
}
