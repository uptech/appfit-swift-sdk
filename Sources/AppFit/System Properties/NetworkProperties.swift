//
//  NetworkProperties.swift
//
//
//  Created by Anthony Castelli on 5/21/24.
//

import Foundation

/**
 * The Network Properties of the Device.
 */
internal struct NetworkProperties: Codable {
    /// The Device's current IP Address
    let ip: String
}
