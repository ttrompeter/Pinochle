//
//  Hand.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import RealmSwift
import SwiftUI

class Hand: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var bidderWasSet = false
    @Persisted var bidWinnerPlayerNumber = 0
    @Persisted var bidWinnerTeamMeld = 0
    @Persisted var bidWinnerTeamTrickPointsText = " "
    @Persisted var dealerPlayerNumber = 0
    @Persisted var dealerName = ""
    @Persisted var handNumber = 1
    @Persisted var isCompleted = false
    @Persisted var isMeldSaved = false
    @Persisted var isTrickPointsSaved = false
    @Persisted var otherTeamTrickPointsText = " "
    @Persisted var partnerPlayerNumber = 0
    @Persisted var player1MeldText = " "
    @Persisted var player2MeldText = " "
    @Persisted var player3MeldText = " "
    @Persisted var player4MeldText = " "
    @Persisted var player5MeldText = " "
    @Persisted var player6MeldText = " "
    @Persisted var player1TrickPointsText = " "
    @Persisted var player2TrickPointsText = " "
    @Persisted var player3TrickPointsText = " "
    @Persisted var pointsNeededToMakeBid = " "
    @Persisted var selectedBidWinnerName = "Select"
    @Persisted var selectedPartnerName = "Select"
    @Persisted var selectedTrump = 2
    @Persisted var wasMisdeal = false
    @Persisted var wasRenege = false
    @Persisted var winningBidText = ""
    
    @Persisted(originProperty: "hands") var game: LinkingObjects<Game>
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

