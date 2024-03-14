//
//  AppFitCache.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/**
 * AppFitCache handles all of the internal state for User Id's and
 * anonymous Id's. This allows us to have one concise place to
 * generate and refernce it from.
 */
internal class AppFitCache {
    /// The current cached userId
    internal var userId: String? {
        get {
            UserDefaults.standard.string(forKey: "userId")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "userId")
        }
    }

    /// The current cached anonymousId.
    /// This will generate one if one doesnt exist.
    internal var anonymousId: String? {
        let id = UserDefaults.standard.string(forKey: "anonymousId")
        guard id == nil else { return id }
        return self.generateAnonymousId()
    }

    /// Generates and saves the new id to UserDefaults
    @discardableResult
    internal func generateAnonymousId() -> String {
        let id = UUID().uuidString
        let currentId = UserDefaults.standard.string(forKey: "anonymousId")
        guard currentId == nil else { return id }
        guard currentId == nil else { return id }
        UserDefaults.standard.setValue(id, forKey: "anonymousId")
        return id
    }
}
