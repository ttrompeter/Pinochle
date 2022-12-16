//
//  Match.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import RealmSwift
import Foundation

class Match: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var currentGameNumber = 1
    @Persisted var currentGameArrayIndex = 0
    @Persisted var dateCreated: Date = Date()
    @Persisted var firstDealerName: String = "Select"
    @Persisted var isCompleted = false
    @Persisted var isMatchSetupCompleted = false
    @Persisted var matchNumber = 1
    @Persisted var matchPlayerNames = RealmSwift.List<String>()
    @Persisted var matchPlayerPickerNames = RealmSwift.List<String>()
    @Persisted var matchWinnerText = ""
    @Persisted var player1GamesWon = 0
    @Persisted var player2GamesWon = 0
    @Persisted var player3GamesWon = 0
    @Persisted var player4GamesWon = 0
    @Persisted var player5GamesWon = 0
    @Persisted var player6GamesWon = 0
    // Picker selection can't be empty string since genereates error - 'Picker: the selection "" is invalid and does not have an associated tag, this will give undefined results.'
    @Persisted var player1Name: String = "Select"
    @Persisted var player2Name: String = "Select"
    @Persisted var player3Name: String = "Select"
    @Persisted var player4Name: String = "Select"
    @Persisted var player5Name: String = "Select"
    @Persisted var player6Name: String = "Select"
    //TODO: - selectedHandBidWinnerName &selectedHandPartnerName should be coming from Hand not Match
    @Persisted var selectedHandBidWinnerName: String = "Select"
    @Persisted var selectedNumberOfPlayers = 4
    @Persisted var selectedPartnerName: String = "Select"
    @Persisted var team1GamesWon = 0
    @Persisted var team2GamesWon = 0
    
    // Saved earlier values for updating
    @Persisted var savedPlayer1MeldText = ""
    @Persisted var savedPlayer2MeldText = ""
    @Persisted var savedPlayer3MeldText = ""
    @Persisted var savedPlayer4MeldText = ""
    @Persisted var savedPlayer5MeldText = ""
    @Persisted var savedPlayer6MeldText = ""
    @Persisted var savedPlayer1TrickPointsText = ""
    @Persisted var savedPlayer2TrickPointsText = ""
    @Persisted var savedPlayer3TrickPointsText = ""
    @Persisted var savedBidWinnerTeamTrickPointsText = ""
    @Persisted var savedOtherTeamTrickPointsText = ""
    @Persisted var savedBidderWasSet = false

    @Persisted var showingPointsNeededToMakeBid = false
    @Persisted var showingNewGameArrow = false
    @Persisted var showingNextHandArrow = false
    @Persisted var showingMatchSetupSheet = false
    @Persisted var showingScratchPadSheet = false
    
    // Buttons
    @Persisted var isDisabledConcedeBtn = false
    @Persisted var isDisabledEditMeldBtn = false
    @Persisted var isDisabledEditSetupBtn = false
    @Persisted var isDisabledEditTrickPointsBtn = false
    @Persisted var isDisabledEndMatchBtn = false
    @Persisted var isDisabledMisDealBtn = false
    @Persisted var showingNewMatchButton = false
    @Persisted var isDisabledNextHandBtn = false
    @Persisted var showingNewGameButton = false
    @Persisted var isDisabledRenegeBtn = false
    @Persisted var isDisabledScratchPadBtn = false
    @Persisted var isDisabledSaveMeldBtn = false
    @Persisted var isDisabledSaveTricksBtn = false
    @Persisted var showingEndMatchButton = false
    @Persisted var showingNextHandButton = false
    
    // TextFields & Pickers
    @Persisted var isDisabledBidWinnerPicker = false
    @Persisted var isDisabledBidWinnerTrickPointsTextField = false
    @Persisted var isDisabledMeldTextField = false
    @Persisted var isDisabledPartnerPicker = false
    @Persisted var isDisabledPlayer1MeldTextField = false
    @Persisted var isDisabledPlayer2MeldTextField = false
    @Persisted var isDisabledPlayer3MeldTextField = false
    @Persisted var isDisabledPlayer4MeldTextField = false
    @Persisted var isDisabledPlayer5MeldTextField = false
    @Persisted var isDisabledPlayer6MeldTextField = false
    @Persisted var isDisabledPlayer1TrickPointsTextField = false
    @Persisted var isDisabledPlayer2TrickPointsTextField = false
    @Persisted var isDisabledPlayer3TrickPointsTextField = false
    @Persisted var isDisabledOtherTeamTrickPointsTextField = false
    @Persisted var isDisabledTrickPointsTextField = false
    @Persisted var isDisabledTrumpPicker = false
    @Persisted var isDisabledWinningBidTextField = false
    @Persisted var isUnfinishedMatch = false
    
    @Persisted var games = RealmSwift.List<Game>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

