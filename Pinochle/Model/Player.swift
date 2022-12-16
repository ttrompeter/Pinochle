//
//  Player.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import RealmSwift
import Foundation

class Player: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var name = ""
    @Persisted var isActive = true
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

