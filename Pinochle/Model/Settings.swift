//
//  Settings.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import RealmSwift
import Foundation

class Settings: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var pointsPerHand3Players = "50"
    @Persisted var pointsPerHand4Players = "50"
    @Persisted var pointsPerHand5Players = "75"
    @Persisted var pointsPerHand6Players = "75"
    @Persisted var pointsToWinGame3Players = "500"
    @Persisted var pointsToWinGame4Players = "500"
    @Persisted var pointsToWinGame5Players = "800"
    @Persisted var pointsToWinGame6Players = "500"
    @Persisted var minimumOpeningBid3Players = "25"
    @Persisted var minimumOpeningBid4Players = "25"
    @Persisted var minimumOpeningBid5Players = "50"
    @Persisted var minimumOpeningBid6Players = "50"
    @Persisted var scoreDifferentialMinimum = "71"
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

