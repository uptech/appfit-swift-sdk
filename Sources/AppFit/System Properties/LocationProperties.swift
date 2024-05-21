//
//  LocationProperties.swift
//
//
//  Created by Anthony Castelli on 5/21/24.
//

import Foundation

internal struct LocationProperties: Codable {
    /// The Continent (North America)
    let continent: String?

    /// The Country (United States of America)
    let country: String?

    /// Country Code (USA)
    let countryCode: String?

    /// Regsion/State (Florida)
    let region: String?

    /// City (Tampa)
    let city: String?

    /// Postal/Zip Code (12345)
    let postalCode: String?

    /// Latitude of the locaction (27.30810)
    let latitude: Double?

    /// Longitude of the location (-82.50982)
    let longitude: Double?
}
