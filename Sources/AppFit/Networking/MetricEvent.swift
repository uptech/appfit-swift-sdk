//
//  MetricEvent.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * An event that is tracked by AppFit.
 */
internal struct MetricEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case origin
        case eventId
        case name
        case userId
        case anonymousId
        case properties
        case systemProperties
    }

    /// The unique identifier for the event.
    internal let eventId: UUID

    /// The name of the event.
    internal let name: String

    /// The user identifier for the event.
    internal let userId: String?

    /// The anonymous identifier for the event.
    internal let anonymousId: String?

    /// The properties of the event.
    internal let properties: [String: Any]?

    /// The system properties of the event.
    internal let systemProperties: [String: Any]?

    internal init(
        eventId: UUID,
        name: String,
        userId: String? = nil,
        anonymousId: String? = nil,
        properties: [String : Any]? = nil,
        systemProperties: [String : Any]? = nil
    ) {
        self.eventId = eventId
        self.name = name
        self.userId = userId
        self.anonymousId = anonymousId
        self.properties = properties
        self.systemProperties = systemProperties
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.eventId = try values.decode(UUID.self, forKey: .eventId)
        self.name = try values.decode(String.self, forKey: .name)
        self.userId = try values.decodeIfPresent(String.self, forKey: .userId)
        self.anonymousId = try values.decodeIfPresent(String.self, forKey: .anonymousId)
        self.properties = try values.decodeIfPresent([String : Any].self, forKey: .properties)
        self.systemProperties = try values.decodeIfPresent([String : Any].self, forKey: .systemProperties)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.eventId, forKey: .eventId)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.anonymousId, forKey: .anonymousId)
        try container.encodeIfPresent(self.properties, forKey: .properties)
        try container.encodeIfPresent(self.systemProperties, forKey: .systemProperties)
    }
}
