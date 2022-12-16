//
//  ScorerSingleton.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/25/22.
//

import Foundation

final class ScorerSingleton {
    
    static let shared = ScorerSingleton()
    var numberOfPlayers: Int?
    var isIPad: Bool?
    var isIPhone: Bool?

    private init() { }
}
