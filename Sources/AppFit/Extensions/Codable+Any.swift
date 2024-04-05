//
//  Codable+Any.swift
//  
//
//  Created by Anthony Castelli on 4/5/24.
//

import Foundation

private struct JSONCodingKeys: CodingKey {
    var stringValue: String

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

extension KeyedDecodingContainer {
    func decodeIfPresent(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any]? {
        let container = try? self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        guard let container else { return nil }
        return try container.decode(type)
    }

    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()

        for key in allKeys {
            if let boolValue = try? self.decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let intValue = try? self.decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let stringValue = try? self.decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let doubleValue = try? self.decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? self.decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? self.decode([Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            } else if let isValueNil = try? self.decodeNil(forKey: key), isValueNil == true {
                dictionary[key.stringValue] = nil
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath + [key], debugDescription: "Unable to decode value"))
            }
        }
        return dictionary
    }

    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }
}

extension UnkeyedDecodingContainer {
    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try container.decode(type)
    }

    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []

        while self.isAtEnd == false {
            if let value = try? self.decode(Bool.self) {
                array.append(value)
            } else if let value = try? self.decode(Int.self) {
                array.append(value)
            } else if let value = try? self.decode(String.self) {
                array.append(value)
            } else if let value = try? self.decode(Double.self) {
                array.append(value)
            } else if let nestedDictionary = try? self.decode([String: Any].self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? self.decodeNestedArray([Any].self) {
                array.append(nestedArray)
            } else if let isValueNil = try? self.decodeNil(), isValueNil == true {
                array.append(Optional<Any>.none as Any)
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Unable to decode value"))
            }
        }
        return array
    }

    mutating func decodeNestedArray(_ type: [Any].Type) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer()
        return try container.decode(type)
    }
}

extension KeyedEncodingContainerProtocol where Key == JSONCodingKeys {
    mutating func encode(_ value: [String: Any]) throws {
        for (key, value) in value {
            let key = JSONCodingKeys(stringValue: key)
            switch value {
            case let value as Bool:
                try self.encode(value, forKey: key)
            case let value as Int:
                try self.encode(value, forKey: key)
            case let value as String:
                try self.encode(value, forKey: key)
            case let value as Double:
                try self.encode(value, forKey: key)
            case let value as [String: Any]:
                try self.encode(value, forKey: key)
            case let value as [Any]:
                try self.encode(value, forKey: key)
            case Optional<Any>.none:
                try self.encodeNil(forKey: key)
            default:
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: self.codingPath + [key], debugDescription: "Invalid JSON value"))
            }
        }
    }
}

extension KeyedEncodingContainerProtocol {
    mutating func encodeIfPresent(_ value: [String: Any]?, forKey key: Key) throws {
        try self.encode(value, forKey: key)
    }

    mutating func encode(_ value: [String: Any]?, forKey key: Key) throws {
        guard let value = value else { return }

        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        try container.encode(value)
    }

    mutating func encode(_ value: [Any]?, forKey key: Key) throws {
        guard let value = value else { return }

        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(value)
    }
}

extension UnkeyedEncodingContainer {
    mutating func encode(_ value: [Any]) throws {
        for (index, value) in value.enumerated() {
            switch value {
            case let value as Bool:
                try self.encode(value)
            case let value as Int:
                try self.encode(value)
            case let value as String:
                try self.encode(value)
            case let value as Double:
                try self.encode(value)
            case let value as [String: Any]:
                try self.encode(value)
            case let value as [Any]:
                try self.encodeNestedArray(value)
            case Optional<Any>.none:
                try self.encodeNil()
            default:
                let keys = JSONCodingKeys(intValue: index).map({ [ $0 ] }) ?? []
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath + keys, debugDescription: "Invalid JSON value"))
            }
        }
    }

    mutating func encode(_ value: [String: Any]) throws {
        var container = nestedContainer(keyedBy: JSONCodingKeys.self)
        try container.encode(value)
    }

    mutating func encodeNestedArray(_ value: [Any]) throws {
        var container = nestedUnkeyedContainer()
        try container.encode(value)
    }
}
