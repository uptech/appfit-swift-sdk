//
//  AppFitEvent.swift
//
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * An event that can be sent to AppFit
 *
 * Each event contains all of the metadata for tracking.
 * This contains all of the data from the parameters below.
 *
 * Example:
 * ```swift
 * let event = AppFitEvent(name: "event", properties: ["count": 1])
 * ```
 *
 * - Parameters:
 *   - name: The name of the event
 *   - properties: The properties of the event
 */
public struct AppFitEvent: Codable, Sendable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case name
        case properties
    }

    /// The unique identifier for the event
    internal let id: UUID

    /// The date the event was created
    internal let date: Date

    /// The name of the event
    public let name: String

    /// The properties of the event
    public let properties: [String: Sendable]?

    /**
     Initializes an AppFitEvent with the provided name and properties.
     - Parameters:
        - name: The name of the event.
        - properties: The properties of the event.
     */
    public init(
        name: String,
        properties: [String : Any]? = nil
    ) {
        self.id = UUID()
        self.date = Date()
        self.name = name
        self.properties = properties
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(UUID.self, forKey: .id)
        self.date = try values.decode(Date.self, forKey: .date)
        self.name = try values.decode(String.self, forKey: .name)
        self.properties = try values.decodeIfPresent([String: Any].self, forKey: .properties)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.properties, forKey: .properties)
    }
}

extension AppFitEvent {
    public static func == (lhs: AppFitEvent, rhs: AppFitEvent) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.date == rhs.date
    }
}
