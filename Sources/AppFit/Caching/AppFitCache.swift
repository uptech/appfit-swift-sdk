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
internal actor AppFitCache {
    /// The current cached userId
    internal var userId: String? {
        UserDefaults.standard.string(forKey: "userId")
    }

    internal func setUserId(_ id: String?) {
        UserDefaults.standard.setValue(id, forKey: "userId")
    }

    /// The current cached anonymousId.
    /// This will generate one if one doesnt exist.
    internal var anonymousId: String? {
        guard let currentId = UserDefaults.standard.string(forKey: "anonymousId") else {
            let id = self.generateAnonymousId()
            UserDefaults.standard.setValue(id, forKey: "anonymousId")
            return id
        }
        return currentId
    }

    /// Generates and saves the new id to UserDefaults
    private func generateAnonymousId() -> String {
        return UUID().uuidString
    }
}
