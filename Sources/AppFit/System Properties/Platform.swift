//
//  Platform.swift
//
//
//  Created by Anthony Castelli on 5/21/24.
//

import Foundation

internal enum Platform: String, Codable {
    case apple = "Apple"
    case linux = "Linux"

    static var current: Platform {
#if os(Linux)
        return Platform.linux
#else
        return Platform.apple
#endif
    }
}
