//
//  App.swift
//
//
//  Created by Anthony Castelli on 5/21/24.
//

import Foundation

internal struct App {
    static let current = App()

    var version: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    var build: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
