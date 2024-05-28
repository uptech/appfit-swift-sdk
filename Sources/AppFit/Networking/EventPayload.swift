//
//  EventPayload.swift
//
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

enum EventPayloadVersion: String, Codable {
    case v2 = "2"
}

/**
 * An event that is tracked by AppFit.
 */
internal struct EventPayload: Codable {
    enum CodingKeys: String, CodingKey {
        case version
        case sourceEventId
        case eventName
        case origin
        case userId
        case anonymousId
        case properties
        case systemProperties
    }

    /// The version of the event payload.
    internal let version: EventPayloadVersion

    /// The unique identifier for the event.
    internal let sourceEventId: UUID

    /// The name of the event.
    internal let eventName: String

    /// he Origin of the SDK. This is a hard-coded property that will never change
    /// The value is `swift`
    internal let origin: String

    /// The user identifier for the event.
    internal let userId: String?

    /// The anonymous identifier for the event.
    internal let anonymousId: String?

    /// The properties of the event.
    internal let properties: [String: Any]?

    /// The system properties of the event.
    internal let systemProperties: EventSystemProperties?

    internal init(
        version: EventPayloadVersion = .v2,
        sourceEventId: UUID,
        eventName: String,
        origin: String = "swift",
        userId: String? = nil,
        anonymousId: String? = nil,
        properties: [String : Any]? = nil,
        systemProperties: EventSystemProperties? = EventSystemProperties()
    ) {
        self.version = version
        self.sourceEventId = sourceEventId
        self.eventName = eventName
        self.origin = origin
        self.userId = userId
        self.anonymousId = anonymousId
        self.properties = properties
        self.systemProperties = systemProperties
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.version = try values.decode(EventPayloadVersion.self, forKey: .version)
        self.sourceEventId = try values.decode(UUID.self, forKey: .sourceEventId)
        self.eventName = try values.decode(String.self, forKey: .eventName)
        self.origin = try values.decode(String.self, forKey: .origin)
        self.userId = try values.decodeIfPresent(String.self, forKey: .userId)
        self.anonymousId = try values.decodeIfPresent(String.self, forKey: .anonymousId)
        self.properties = try values.decodeIfPresent([String : Any].self, forKey: .properties)
        self.systemProperties = try values.decodeIfPresent(EventSystemProperties.self, forKey: .systemProperties)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.version, forKey: .version)
        try container.encode(self.sourceEventId, forKey: .sourceEventId)
        try container.encode(self.eventName, forKey: .eventName)
        try container.encode(self.origin, forKey: .origin)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.anonymousId, forKey: .anonymousId)
        try container.encodeIfPresent(self.properties, forKey: .properties)
        try container.encodeIfPresent(self.systemProperties, forKey: .systemProperties)
    }
}
