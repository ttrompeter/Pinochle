//
//  Game.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import RealmSwift
import Foundation

class Game: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var currentHandNumber = 1
    @Persisted var currentHandArrayIndex = 0
    @Persisted var gameNumber = 1
    @Persisted var gameWinnerPlayerNumber = 0
    @Persisted var gameWinnerText = ""
    @Persisted var isCompleted = false
    @Persisted var player1Score = 0
    @Persisted var player2Score = 0
    @Persisted var player3Score = 0
    @Persisted var player4Score = 0
    @Persisted var player5Score = 0
    @Persisted var team1Score = 0
    @Persisted var team2Score = 0
    @Persisted var wasConceded = false
    
    @Persisted var hands = RealmSwift.List<Hand>()
   
    @Persisted(originProperty: "games") var match: LinkingObjects<Match>
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

