//
//  PinochleManager.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import RealmSwift
import SwiftUI
import Foundation


class PinochleManager: ObservableObject {
    
    private(set) var realm: Realm?
    
    @Published var game = Game()
    @Published var match = Match()
    @Published var players = [Player]()
    @Published var settings = Settings()
    @Published var proposedName = ""
    
    //@Published var isUnfinishedMatch = false
    @Published var forceViewUpdate = 0
    @Published var showingPublishedGameOverPopover = false
    @Published var showingPublishedMatchOverPopover = false
    
    @Published var handPlayBidWinnerPlayerNumber = 0
    @Published var handPlayPartnerPlayerNumber = 0
    @Published var bidWinnerTeamTrickPointsEditHandText = "" {
        didSet {
            if validateIndividualTricksTextFieldValue(textValueToValidate: bidWinnerTeamTrickPointsEditHandText) {
                print("bidWinnerTeamTrickPointsEditHandText is valid in didSet: \(bidWinnerTeamTrickPointsEditHandText)")
            } else {
                print("bidWinnerTeamTrickPointsEditHandText is NOT VALID in didSet: \(bidWinnerTeamTrickPointsEditHandText)")
                //bidWinnerTeamTrickPointsEditHandText = "X"
            }
        }
    }
    @Published var isMeldSaved = false
    @Published var isTrickPointsSaved = false
    @Published var isChangedMeld = false
    @Published var isChangedTrickPoints = false
    @Published var isEditTrickPointsButtonTapped = false
    @Published var otherTeamTrickPointsEditHandText = "" {
        didSet {
            if validateIndividualTricksTextFieldValue(textValueToValidate: otherTeamTrickPointsEditHandText) {
                print("otherTeamTrickPointsEditHandText is valid in didSet: \(otherTeamTrickPointsEditHandText)")
            } else {
                print("otherTeamTrickPointsEditHandText is NOT VALID in didSet: \(otherTeamTrickPointsEditHandText)")
            }
        }
    }
    @Published var player1MeldEditHandText = ""
    @Published var player2MeldEditHandText = ""
    @Published var player3MeldEditHandText = ""
    @Published var player4MeldEditHandText = ""
    @Published var player5MeldEditHandText = ""
    @Published var player6MeldEditHandText = ""
    @Published var player1TrickPointsEditHandText = ""
    @Published var player2TrickPointsEditHandText = ""
    @Published var player3TrickPointsEditHandText = ""
    @Published var selectedEditHandBidWinnerName = "Select"
    @Published var selectedEditHandPartnerName = "Select"
    @Published var selectedEditHandTrump = 2
    @Published var winningBidEditHandText = ""
    
    // For ZStack Picker
    @Published var showingPlayerSelector = false
    
    // Dummy player to use with Pickers to avoid errors and provide a 'Select' value at top of picker display
    var selectPlayer: Player {
        let player = Player()
        player.name = "Select"
        return player
    }
    
    //        if let realm = realm {
    //            do {
    //                try realm.write {
    //
    //                }
    //            } catch {
    //                print("ERROR adding new player in Pinochle Manager")
    //            }
    //        }
    
    init() {
        
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let realmFileUrl = docDir.appendingPathComponent("pinochle.realm")
        let config = Realm.Configuration(fileURL: realmFileUrl)
        Realm.Configuration.defaultConfiguration = config
        print(docDir.path) // Print the path to the console for acceess to the realm database in development
        do {
            realm = try Realm()
        } catch {
            print("ERROR opening default realm: ", error.localizedDescription)
        }
        
        // Check Settings and load if necessary
        if let realm = realm {
            let existingSettings = realm.objects(Settings.self)
            if existingSettings.count < 1 {
                do {
                    try realm.write {
                        realm.add(Settings())
                    }
                } catch {
                    print("ERROR saving new Settings: \(error)")
                }
            }
            settings = realm.objects(Settings.self)[0]
            //print("settings after set in PinochleManger pointsToWinGame3Players: \(settings.pointsToWinGame3Players)")
            let existingPlayers = realm.objects(Player.self).sorted(byKeyPath: "name", ascending: true)
            if existingPlayers.count < 1 {
                do {
                    try realm.write {
                        let newPlayer1 = Player()
                        newPlayer1.name = "Al A"
                        realm.add(newPlayer1)
                        let newPlayer2 = Player()
                        newPlayer2.name = "Anita R"
                        realm.add(newPlayer2)
                        let newPlayer3 = Player()
                        newPlayer3.name = "Lailani D"
                        realm.add(newPlayer3)
                        let newPlayer4 = Player()
                        newPlayer4.name = "Carol R"
                        realm.add(newPlayer4)
                        let newPlayer5 = Player()
                        newPlayer5.name = "Joyce P"
                        realm.add(newPlayer5)
                        let newPlayer6 = Player()
                        newPlayer6.name = "Tain S"
                        realm.add(newPlayer6)
                        let newPlayer7 = Player()
                        newPlayer7.name = "Rhonda C"
                        realm.add(newPlayer7)
                        let newPlayer8 = Player()
                        newPlayer8.name = "Ruth B"
                        realm.add(newPlayer8)
                        let newPlayer9 = Player()
                        newPlayer9.name = "Sandi G"
                        realm.add(newPlayer9)
                        let newPlayer10 = Player()
                        newPlayer10.name = "Tom T"
                        realm.add(newPlayer10)

                    }
                    let realmPlayers = realm.objects(Player.self).sorted(byKeyPath: "name", ascending: true)
                    
                    players = Array(realmPlayers)
                    players.insert(selectPlayer, at: 0)
                } catch {
                    print("ERROR saving new Settings: \(error)")
                }
            } else {
                players = Array(existingPlayers)
                players.insert(selectPlayer, at: 0)
            }
            
            if let unfinishedMatch = realm.objects(Match.self).where({$0.isCompleted == false}).first {
                match = unfinishedMatch
                setUnfinishedMatch()
                print("Using existing match in init() in PinochleManager - Match dateCreated: \(unfinishedMatch.dateCreated)")
            } else {
                createStartupMatch()
                print("Using new startup match in init() in PinochleManager: \(match.dateCreated)")
            }
        }
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad {
            //print("     > > > > The device is an iPad")
            ScorerSingleton.shared.isIPad = true
            ScorerSingleton.shared.isIPhone = false
        } else if deviceIdiom == .phone {
            //print("     > > > > The device is an iPhone")
            ScorerSingleton.shared.isIPad = false
            ScorerSingleton.shared.isIPhone = true
        }
    }
    
    
    // MARK: - Realm Functions
    
    func addPlayer(playerName: String) {
        if let realm = realm {
            do {
                try realm.write {
                    let newPlayer = Player()
                    newPlayer.name = playerName
                    realm.add(newPlayer)
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
        }
    }
    
    func createMatchPlayerNames() {
        if let realm = realm {
            
            do {
                try realm.write {
                    if match.matchPlayerNames.count > 0 {
                        // delete existing match players
                        match.matchPlayerNames = RealmSwift.List<String>()
                        print("Count of match players after reset in createMatchPlayers() in PinochleManager: \(match.matchPlayerNames.count)")
                    }
                    match.matchPlayerNames.append(match.player1Name)
                    match.matchPlayerNames.append(match.player2Name)
                    match.matchPlayerNames.append(match.player3Name)
                    if match.selectedNumberOfPlayers == 4 {
                        match.matchPlayerNames.append(match.player4Name)
                    } else if  match.selectedNumberOfPlayers == 5 {
                        match.matchPlayerNames.append(match.player4Name)
                        match.matchPlayerNames.append(match.player5Name)
                    } else if  match.selectedNumberOfPlayers == 6 {
                        match.matchPlayerNames.append(match.player4Name)
                        match.matchPlayerNames.append(match.player5Name)
                        match.matchPlayerNames.append(match.player6Name)
                    }
                    match.matchPlayerPickerNames = match.matchPlayerNames
                    match.matchPlayerPickerNames.insert("Select", at: 0)
                }
            } catch {
                print("ERROR adding Match in Pinochle Manager")
            }
        }
    }
    
    func createNewGame() {
        print("Starting createNewGame()")
        let newGame = Game()
        if let realm = realm {
            do {
                try realm.write {
                    let oldHandDealerPlayerNumber = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].dealerPlayerNumber
                    let newHandDealerPlayerNumber = getNextHandDealerNumber(currentDealerNumberParam: oldHandDealerPlayerNumber, numberOfPlayersParam: match.selectedNumberOfPlayers)
                    let newHand = Hand()
                    newHand.dealerPlayerNumber = newHandDealerPlayerNumber
                    switch newHandDealerPlayerNumber {
                    case 1 :
                        newHand.dealerName = match.player1Name
                    case 2 :
                        newHand.dealerName = match.player2Name
                    case 3 :
                        newHand.dealerName = match.player3Name
                    case 4 :
                        newHand.dealerName = match.player4Name
                    case 5 :
                        newHand.dealerName = match.player5Name
                    case 6 :
                        newHand.dealerName = match.player6Name
                    default:
                        print("ERROR setting newHandDealerName in createNewHand in PinochleManager")
                    }
                    newGame.hands.append(newHand)
                    let oldGameNumber = match.currentGameNumber
                    newGame.gameNumber = oldGameNumber + 1
                    match.games.append(newGame)
                    match.currentGameArrayIndex = oldGameNumber
                    match.currentGameNumber = oldGameNumber + 1
                }
            } catch {
                print("ERROR adding Game in Pinochle Manager")
            }
        }
    }
    
    func createNewHand() {
        print("Starting createNewHand()")
        if let realm = realm {
            do {
                try realm.write {
                    let oldHandNumber = match.games[match.currentGameArrayIndex].currentHandNumber
                    let oldHandDealerPlayerNumber = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].dealerPlayerNumber
                    let newHandDealerPlayerNumber = getNextHandDealerNumber(currentDealerNumberParam: oldHandDealerPlayerNumber, numberOfPlayersParam: match.selectedNumberOfPlayers)
                    let newHand = Hand()
                    newHand.handNumber = oldHandNumber + 1
                    newHand.dealerPlayerNumber = newHandDealerPlayerNumber
                    switch newHandDealerPlayerNumber {
                    case 1 :
                        newHand.dealerName = match.player1Name
                    case 2 :
                        newHand.dealerName = match.player2Name
                    case 3 :
                        newHand.dealerName = match.player3Name
                    case 4 :
                        newHand.dealerName = match.player4Name
                    case 5 :
                        newHand.dealerName = match.player5Name
                    case 6 :
                        newHand.dealerName = match.player6Name
                    default:
                        print("ERROR setting newHandDealerName in createNewHand in PinochleManager")
                    }
                    match.games[match.currentGameArrayIndex].hands.append(newHand)
                    match.games[match.currentGameArrayIndex].currentHandNumber = oldHandNumber + 1
                    match.games[match.currentGameArrayIndex].currentHandArrayIndex = oldHandNumber
                }
            } catch {
                print("ERROR adding Game in Pinochle Manager")
            }
        }
    }
    
    func createStartupMatch() {
        //print("Starting createStartupMatch()")
        if let realm = realm {
            do {
                try realm.write {
                    let newMatch = Match()
                    newMatch.matchNumber = match.matchNumber + 1
                    let game = Game()
                    let hand = Hand()
                    game.hands.append(hand)
                    newMatch.games.append(game)
                    realm.add(newMatch)
                    match = newMatch
                }
            } catch {
                print("ERROR adding startup Match in Pinochle Manager")
            }
        }
    }
    
    func createNewMatch() {
        //print("Starting createNewMatch()")
        if let realm = realm {
            do {
                try realm.write {
                    let newMatch = Match()
                    newMatch.matchNumber = match.matchNumber + 1
                    let game = Game()
                    let hand = Hand()
                    game.hands.append(hand)
                    newMatch.games.append(game)
                    realm.add(newMatch)
                    match = newMatch
                    let realmPlayersResults = realm.objects(Player.self).sorted(byKeyPath: "name", ascending: true)
                    players = Array(realmPlayersResults)
                    players.insert(selectPlayer, at: 0)
                }
            } catch {
                print("ERROR adding Match in Pinochle Manager")
            }
            
            let matchesResults = realm.objects(Match.self).where({$0.isCompleted == true})
            for matchToDelete in matchesResults {
                deleteMatch(matchToDelete: matchToDelete)
            }
        }
        print("End of createNewMatch()")
    }
    
    func deleteMatchPlayers() {
        if let realm = realm {
            
            do {
                try realm.write {
                    match.matchPlayerNames.removeAll()
                }
            } catch {
                print("ERROR deleting match players in Pinochle Manager")
            }
        }
    }
    
    func deleteMatch(matchToDelete: Match) {
        //print("Starting deleteMatch()")
        if let realm = realm {
            do {
                try realm.write {
                    let gamesToBeDeleted = Array(matchToDelete.games)
                    for game in gamesToBeDeleted {
                        let handsToBeDeleted = game.hands
                        for hand in handsToBeDeleted {
                            realm.delete(hand)
                        }
                        //print("after hands deleted in deleteMatch()")
                        realm.delete(game)
                    }
                    //print("after games deleted in deleteMatch()")
                    realm.delete(matchToDelete)
                }
            } catch {
                print("ERROR deleting match in deleteMatch() in Pinochle Manager")
            }
        }
    }
    
    // MARK: - View Support Functions
    
    func trickPointsEditDisabled() -> Bool {
        var numberEmptyFields = 0
        if player1TrickPointsEditHandText.isEmpty {
            numberEmptyFields += 1
        }
        if player2TrickPointsEditHandText.isEmpty {
            numberEmptyFields += 1
        }
        if player3TrickPointsEditHandText.isEmpty {
            numberEmptyFields += 1
        }
        if numberEmptyFields > 1 {
            return true
        }
        return false
    }
    
    func getCurrentGame(gameNumber: Int) -> Game {
        var gameToReturn = Game()
        if let realm = realm {
            do {
                try realm.write {
                    gameToReturn = realm.objects(Game.self).where({$0.gameNumber == gameNumber}).first!
                    //print("gameToReturn: \(gameToReturn)")
                }
            } catch {
                print("ERROR getting current game in Pinochle Manager")
            }
        }
        return gameToReturn
    }
    
    func getNextHandDealerNumber(currentDealerNumberParam: Int, numberOfPlayersParam: Int) -> Int {
        var nextHandDealerPlayerNumber = 0
        if numberOfPlayersParam == 3 {
            switch currentDealerNumberParam {
            case 1:
                nextHandDealerPlayerNumber = 2
            case 2:
                nextHandDealerPlayerNumber = 3
            case 3:
                nextHandDealerPlayerNumber = 1
            default:
                print("ERROR in determineNextDealer() for 3 players")
            }
        }
        if numberOfPlayersParam == 4 {
            switch currentDealerNumberParam {
            case 1:
                nextHandDealerPlayerNumber = 2
            case 2:
                nextHandDealerPlayerNumber = 3
            case 3:
                nextHandDealerPlayerNumber = 4
            case 4:
                nextHandDealerPlayerNumber = 1
            default:
                print("ERROR in determineNextDealer() for 4 players")
            }
        }
        if numberOfPlayersParam == 5 {
            switch currentDealerNumberParam {
            case 1:
                nextHandDealerPlayerNumber = 2
            case 2:
                nextHandDealerPlayerNumber = 3
            case 3:
                nextHandDealerPlayerNumber = 4
            case 4:
                nextHandDealerPlayerNumber = 5
            case 5:
                nextHandDealerPlayerNumber = 1
            default:
                print("ERROR in determineNextDealer() for 5 players")
            }
        }
        if numberOfPlayersParam == 6 {
            switch currentDealerNumberParam {
            case 1:
                nextHandDealerPlayerNumber = 2
            case 2:
                nextHandDealerPlayerNumber = 3
            case 3:
                nextHandDealerPlayerNumber = 4
            case 4:
                nextHandDealerPlayerNumber = 5
            case 5:
                nextHandDealerPlayerNumber = 6
            case 6:
                nextHandDealerPlayerNumber = 1
            default:
                print("ERROR in determineNextDealer() for 6 players")
            }
        }
        return nextHandDealerPlayerNumber
    }
    
    func concedeGame() {
        
        if let realm = realm {
            do {
                try realm.write {
                    let concedeGameWinner = getConcedeGameWinnerText()
                    
                    if match.selectedNumberOfPlayers == 3 {
                        switch concedeGameWinner {
                        case match.player1Name:
                            match.games[match.currentGameArrayIndex].player1Score = Int(settings.pointsToWinGame3Players)!
                        case match.player2Name:
                            match.games[match.currentGameArrayIndex].player2Score = Int(settings.pointsToWinGame3Players)!
                        case match.player3Name:
                            match.games[match.currentGameArrayIndex].player3Score = Int(settings.pointsToWinGame3Players)!
                        default:
                            print("ERROR in switch statement 3 players of concedeGame() in PinochleManger")
                        }
                    } else if match.selectedNumberOfPlayers == 4 {
                        if concedeGameWinner == Constants.TEAM_1 {
                            match.games[match.currentGameArrayIndex].team1Score = Int(settings.pointsToWinGame4Players)!
                        } else if concedeGameWinner == Constants.TEAM_2 {
                            match.games[match.currentGameArrayIndex].team2Score = Int(settings.pointsToWinGame4Players)!
                        }
                    } else if match.selectedNumberOfPlayers == 5 {
                        switch concedeGameWinner {
                        case match.player1Name:
                            match.games[match.currentGameArrayIndex].player1Score = Int(settings.pointsToWinGame5Players)!
                        case match.player2Name:
                            match.games[match.currentGameArrayIndex].player2Score = Int(settings.pointsToWinGame5Players)!
                        case match.player3Name:
                            match.games[match.currentGameArrayIndex].player3Score = Int(settings.pointsToWinGame5Players)!
                        case match.player4Name:
                            match.games[match.currentGameArrayIndex].player4Score = Int(settings.pointsToWinGame5Players)!
                        case match.player5Name:
                            match.games[match.currentGameArrayIndex].player5Score = Int(settings.pointsToWinGame5Players)!
                        default:
                            print("ERROR in switch statement 5 players of concedeGame() in PinochleManger")
                        }
                    } else if match.selectedNumberOfPlayers == 6 {
                        if concedeGameWinner == Constants.TEAM_1 {
                            match.games[match.currentGameArrayIndex].team1Score = Int(settings.pointsToWinGame6Players)!
                        } else if concedeGameWinner == Constants.TEAM_2 {
                            match.games[match.currentGameArrayIndex].team2Score = Int(settings.pointsToWinGame6Players)!
                        }
                    }
                }
            } catch {
                print("ERROR setting conced game score in Pinochle Manager")
            }
            
            if checkIfGameWinner() {
                print("checkIfGameWinner() is true in Concede button so check if match completed")
                // Check if match winner
                if checkIfMatchCompleted() {
                    showingPublishedMatchOverPopover = true
                } else {
                    // Game is over but match is not over
                    showingPublishedGameOverPopover = true
                }
            }
        }
    }
    
    func setUnfinishedMatch() {
        if let realm = realm {
            do {
                try realm.write {
                    match.isUnfinishedMatch = true
                }
            } catch {
                print("ERROR updating unfinishedMatch in Pinochle Manager")
            }
        }
    }
    
    //    func shouldConcedeGame() -> Bool {
    //        /*
    //         1. Any tied scores
    //         2. Any score within scoreDifferential
    //         3. Set messages
    //         4. Show proper alert
    //         */
    //
    //        var shouldConcede = true
    //        if match.selectedNumberOfPlayers == 3 || match.selectedNumberOfPlayers == 5 {
    //            var playerCount = 5
    //            if match.selectedNumberOfPlayers == 3 {
    //                playerCount = 3
    //            }
    //            // The playersWithScoreArray can contain duplicates, but only the first value will be reported a maxValue.
    //            // So, while the playersWithScoreArray will provide the maxValue, it does not address duplicates.
    //            let playersWithScoreArray = [
    //                PlayerWithScore(playerName: match.player1Name, playerScore: match.games[match.currentGameArrayIndex].player1Score),
    //                PlayerWithScore(playerName: match.player2Name, playerScore: match.games[match.currentGameArrayIndex].player2Score),
    //                PlayerWithScore(playerName: match.player3Name, playerScore: match.games[match.currentGameArrayIndex].player3Score),
    //                PlayerWithScore(playerName: match.player4Name, playerScore: match.games[match.currentGameArrayIndex].player4Score),
    //                PlayerWithScore(playerName: match.player5Name, playerScore: match.games[match.currentGameArrayIndex].player5Score),
    //
    //            ]
    //            let maxValue = playersWithScoreArray.max(by: { (firstPlayer, secondPlayer) -> Bool in
    //                return firstPlayer.playerScore < secondPlayer.playerScore
    //            })
    //            let scoresSet: Set = [match.games[match.currentGameArrayIndex].player1Score, match.games[match.currentGameArrayIndex].player2Score, match.games[match.currentGameArrayIndex].player3Score, match.games[match.currentGameArrayIndex].player4Score, match.games[match.currentGameArrayIndex].player5Score]
    //
    //            // Check if tied score
    //            if scoresSet.count < playerCount {
    //                // There is a duplicate. Set only holds unique values, so if there are 5 values in the Set there can be no duplicate.
    //                // But if the Set count is less than 5, there is at least 1 duplicate.
    //                for score in scoresSet {
    //                    if score == maxValue!.playerScore {
    //                        // Equals max value. At least 2 scores are tied so shouldn't concede
    //                        shouldConcede = false
    //                    }
    //                }
    //            }
    //
    //            // Check if score too close to concede - the score difference is less than the score differenrtial in settings
    //            for player in playersWithScoreArray {
    //                if ((maxValue!.playerScore - player.playerScore) < Int(settings.scoreDifferentialMinimum)!) && (maxValue!.playerScore != player.playerScore) {
    //                    shouldConcede = false
    //                }
    //            }
    //        } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
    //            let team1ScoreAmount = match.games[match.currentGameArrayIndex].team1Score
    //            let team2ScoreAmount = match.games[match.currentGameArrayIndex].team2Score
    //
    //            // Check if score is tied
    //            if team1ScoreAmount == team2ScoreAmount {
    //                // Score is tied so shouldn't concede
    //                shouldConcede = false
    //                //concedeMessageText = "The score is tied. Should not concede."
    //            }
    //            // Check if score too close to concede - the score difference is less than the score differenrtial in settings
    //            if abs(team1ScoreAmount - team2ScoreAmount) < Int(settings.scoreDifferentialMinimum)! {
    //                // Scores too close
    //                //  Warning for below code:  Modifying state during view update, this will cause undefined behavior.
    //                //concedeMessageText = "The score is close. Should not concede."
    //                shouldConcede = false
    //            }
    //        }
    //        return shouldConcede
    //    }
    
    func getConcedeGameWinnerText() -> String {
        var gameWinnerText = ""
        if match.selectedNumberOfPlayers == 3 || match.selectedNumberOfPlayers == 5 {
            let playersWithScoreArray = [
                PlayerWithScore(playerName: match.player1Name, playerScore: match.games[match.currentGameArrayIndex].player1Score),
                PlayerWithScore(playerName: match.player2Name, playerScore: match.games[match.currentGameArrayIndex].player2Score),
                PlayerWithScore(playerName: match.player3Name, playerScore: match.games[match.currentGameArrayIndex].player3Score),
                PlayerWithScore(playerName: match.player4Name, playerScore: match.games[match.currentGameArrayIndex].player4Score),
                PlayerWithScore(playerName: match.player5Name, playerScore: match.games[match.currentGameArrayIndex].player5Score),
                
            ]
            let maxValue = playersWithScoreArray.max(by: { (firstPlayer, secondPlayer) -> Bool in
                return firstPlayer.playerScore < secondPlayer.playerScore
            })
            gameWinnerText = maxValue!.playerName
        }
        if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
            if match.games[match.currentGameArrayIndex].team1Score  > match.games[match.currentGameArrayIndex].team2Score {
                gameWinnerText = Constants.TEAM_1
            } else {
                gameWinnerText = Constants.TEAM_2
            }
        }
        return gameWinnerText
    }
    
    
    func validateMatchSetup() -> Bool {
        
        //print("Starting validateMatchSetup")
        var isPassValidation = true
        
        // Validate that valid names have been selected in the picker views
        var matchPlayerNamesSet = Set<String>()
        
        for name in match.matchPlayerNames {
            matchPlayerNamesSet.insert(name)
        }
        
        //print("Match players in validateMatchSetup in MatchSetupSheet \(matchPlayerNamesSet)")
        if !validateNameSelectionsInSetup(playerNamesSetParam: matchPlayerNamesSet, firstDealerNameParam: match.firstDealerName) {
            print("Failed valid names in validateMatchSetup")
            isPassValidation = false
        }
        
        // Validate that matchPlayerNames are set correctly - that the player names are unique (no duplicates)
        // Since a Set only contains unique values, if there are four players they must be unique
        if !validatePlayerNamesCountInSetup(matchPlayerNamesSetParam: matchPlayerNamesSet, numOfPlayersParam: match.selectedNumberOfPlayers) {
            print("Failed unique names in validateMatchSetup")
            isPassValidation = false
        }
        
        // Validate that the firstDealer selected in the pickerView is one of the players selected
        if !validateFirstDealerNameSelectionInSetup(matchPlayerNamesSetParam: matchPlayerNamesSet, firstDealerNameParam: match.firstDealerName) {
            print("Failed first dealer names in validateMatchSetup")
            isPassValidation = false
        }
        
        return isPassValidation
    }
    
    // MARK: - Trick Points Functions
    
    func updateScoreWithTrickPoints() {
        print("Starting updateScoreWithTrickPoints()")
        print("bidderWasSet at start of updateScoreWithTrickPoints(): \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet)")
        if let realm = realm {
            do {
                try realm.write {
                    // Save trick points and update scores in Game
                    if match.selectedNumberOfPlayers == 3 {
                        if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                            // Need to adjust player's score for the bid winner who was set back to pre-set value
                            // For other players it is just a matter of subtracting the previous trick points which was already done in saveEditHandPlayTrickPoints
                            // For bidder who was set, also need to also adjust for the prior meld and bid amount that were subtracted from the player's score
                            switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
                            case 1:
                                print("player1Score case 1 after being set at start:    \(match.games[match.currentGameArrayIndex].player1Score)")
                                print("winningBidText case 1:  \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)")
                                print("player1MeldText case 1: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)")
                                print("player1TrickPointsText case 1: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)")
                                // Add back bid amount that was subtracted during bid set process
                                match.games[match.currentGameArrayIndex].player1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                                // Add back the meld points that were subtracted during bid set process
                                match.games[match.currentGameArrayIndex].player1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                                // Add back the original saved trick points that were subtracted during bid set - not the new trick points
                                match.games[match.currentGameArrayIndex].player1Score += Int(match.savedPlayer1TrickPointsText)!
                                print("savedPlayer1TrickPointsText: \(match.savedPlayer1TrickPointsText)")
                                print("player1 score after adjustment for being set: \(match.games[match.currentGameArrayIndex].player1Score)")
                            case 2:
                                // Add back bid amount that was subtracted during bid set process
                                match.games[match.currentGameArrayIndex].player2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                                // Add back the meld points that were subtracted during bid set process
                                match.games[match.currentGameArrayIndex].player2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                                // Add back the original saved trick points that were subtracted during bid set - not the new trick points
                                match.games[match.currentGameArrayIndex].player2Score += Int(match.savedPlayer2TrickPointsText)!
                            case 3:
                                // Add back bid amount that was subtracted during bid set process
                                match.games[match.currentGameArrayIndex].player3Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                                // Add back the meld points that were subtracted during bid set process
                                match.games[match.currentGameArrayIndex].player3Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                                // Add back the original saved trick points that were subtracted during bid set - not the new trick points
                                match.games[match.currentGameArrayIndex].player3Score += Int(match.savedPlayer3TrickPointsText)!
                            default:
                                print("ERROR in switch statement of 3 players game in updateScoreWithTrickPoints of PinochleManager")
                            }
                            
                            // Reset bidder was set flag back to false
                            match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet = false
                        }
                        match.games[match.currentGameArrayIndex].player1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)!
                        print("player1 score after being set in updateScoreWithTrickPoints(): \(match.games[match.currentGameArrayIndex].player1Score)")
                        match.games[match.currentGameArrayIndex].player2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)!
                        match.games[match.currentGameArrayIndex].player3Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!
                    } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
                        // 4 & 6 players Game
                        print("In 4 or 6 players statement of upateScoreWithTrickPoints")
                        calculateTrickPoints()
                        //checkIfBidderWasSet()
                        
                        if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                            print("team1Score at start of bidderWasSet: \(match.games[match.currentGameArrayIndex].team1Score)")
                            print("winningBidText at start of bidderWasSet: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)")
                            print("player1MeldText at start of bidderWasSet: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)")
                            print("player2MeldText at start of bidderWasSet: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)")
                            print("player3MeldText at start of bidderWasSet: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)")
                            print("player4MeldText at start of bidderWasSet: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)")
                            print("player5MeldText at start of bidderWasSet: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)")
                            print("player6MeldText at start of bidderWasSet: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)")
                            print("savedBidWinnerTeamTrickPointsText at start of bidderWasSet: \(match.savedBidWinnerTeamTrickPointsText)")
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 1 || match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 3 || match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 5 {
                                //Adjust the score for the team the was set, in this case Team 1
                                // Add back bid amount that was subtracted during bid set process
                                match.games[match.currentGameArrayIndex].team1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                                // Add back the meld points that were subtracted during bid set process
                                match.games[match.currentGameArrayIndex].team1Score += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!)
                                if match.selectedNumberOfPlayers == 6 {
                                    match.games[match.currentGameArrayIndex].team1Score +=  Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                                }
                                // Add back the original saved trick points that were subtracted during bid set - not the new trick points
                                match.games[match.currentGameArrayIndex].team1Score += Int(match.savedBidWinnerTeamTrickPointsText)!
                            } else {
                                //Adjust the score for the team the was set, in this case Team 1
                                // Add back bid amount that was subtracted during bid set process
                                match.games[match.currentGameArrayIndex].team2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                                // Add back the meld points that were subtracted during bid set process
                                match.games[match.currentGameArrayIndex].team2Score += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!)
                                if match.selectedNumberOfPlayers == 6 {
                                    match.games[match.currentGameArrayIndex].team2Score +=  Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)!
                                }
                                // Add back the original saved trick points that were subtracted during bid set - not the new trick points
                                match.games[match.currentGameArrayIndex].team2Score += Int(match.savedBidWinnerTeamTrickPointsText)!
                            }
                            
                            // Reset bidder was set flag back to false
                            match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet = false
                        }
                        if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 1 || match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 3 || match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 5 {
                            // Team 1 is bid winner - set score for Team 1 and Team 2
                            match.games[match.currentGameArrayIndex].team1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            match.games[match.currentGameArrayIndex].team2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        } else {
                            // Team 2 is bid winner - set score for Team 1 and Team 2
                            match.games[match.currentGameArrayIndex].team1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                            match.games[match.currentGameArrayIndex].team2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                        }
                           
                        
                    } else if match.selectedNumberOfPlayers == 5 {
                        // 5 Players Game
                        calculateTrickPoints()
                        calculateBidWinnerTeamMeld()
                        
                        var losingPlayersNumbersArray = [1, 2, 3, 4, 5]
                        
                        // Add trick points to the Bid Winner's score
                        switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                match.games[match.currentGameArrayIndex].player1Score += (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)! + Int(match.savedPlayer1MeldText)! + Int(match.savedBidWinnerTeamTrickPointsText)! )
                            }
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 1 }
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                match.games[match.currentGameArrayIndex].player2Score += (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)! + Int(match.savedPlayer2MeldText)! + Int(match.savedBidWinnerTeamTrickPointsText)! )
                            }
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 2 }
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                match.games[match.currentGameArrayIndex].player3Score += (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)! + Int(match.savedPlayer3MeldText)! + Int(match.savedBidWinnerTeamTrickPointsText)! )
                            }
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 3 }
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                match.games[match.currentGameArrayIndex].player4Score += (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)! + Int(match.savedPlayer4MeldText)! + Int(match.savedBidWinnerTeamTrickPointsText)! )
                            }
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 4 }
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                match.games[match.currentGameArrayIndex].player5Score += (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)! + Int(match.savedPlayer5MeldText)! + Int(match.savedBidWinnerTeamTrickPointsText)! )
                            }
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 5 }
                        default:
                            print("ERROR assigning trick points in updateScoreWithTrickPoints() of HandPlayManager")
                        }
                        // Add trick points to the Bid Winner's Partner's score
                        //print("partnerPlayerNumber: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber)")
                        switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                match.games[match.currentGameArrayIndex].player1Score += (Int(match.savedPlayer1MeldText)! + Int(match.savedBidWinnerTeamTrickPointsText)!)
                            }
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 1 }
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                match.games[match.currentGameArrayIndex].player2Score += (Int(match.savedPlayer2MeldText)! + Int(match.savedBidWinnerTeamTrickPointsText)! )
                            }
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 2 }
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                match.games[match.currentGameArrayIndex].player3Score += (Int(match.savedPlayer3MeldText)! + Int(match.savedBidWinnerTeamTrickPointsText)!)
                            }
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 3 }
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                match.games[match.currentGameArrayIndex].player4Score += (Int(match.savedPlayer4MeldText)! + Int(match.savedBidWinnerTeamTrickPointsText)!)
                            }
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 4 }
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                match.games[match.currentGameArrayIndex].player5Score += (Int(match.savedPlayer5MeldText)! + Int(match.savedBidWinnerTeamTrickPointsText)!)
                            }
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 5 }
                        default:
                            print("ERROR assigning trick points in updateScoreWithTrickPoints() of HandPlayManager")
                        }
                        // Add trick points to the losers scores (The other 3 players who are not the Bid Winner or the Partner)
                        // The losingPlayersNumbers array should now only contain the other 3 players
                        let firstBidLoserPlayerNumber = losingPlayersNumbersArray[0]
                        switch firstBidLoserPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        default:
                            print("ERROR assigning trick points in updateScoreWithTrickPoints() of HandPlayManager")
                        }
                        
                        let secondBidLoserPlayerNumber = losingPlayersNumbersArray[1]
                        switch secondBidLoserPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        default:
                            print("ERROR assigning trick points in updateScoreWithTrickPoints() of HandPlayManager")
                        }
                        
                        let thirdBidLoserPlayerNumber = losingPlayersNumbersArray[2]
                        switch thirdBidLoserPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        default:
                            print("ERROR assigning trick points in updateScoreWithTrickPoints() of HandPlayManager")
                        }
                        
                        // Reset bidder was set flag back to false
                        if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                            match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet = false
                        }
                        
                        print("player1Score at end of 5 players in updteScoreWithTrickPoints: \(match.games[match.currentGameArrayIndex].player1Score)")
                        print("player2Score at end of 5 players in updteScoreWithTrickPoints: \(match.games[match.currentGameArrayIndex].player2Score)")
                        print("player3Score at end of 5 players in updteScoreWithTrickPoints: \(match.games[match.currentGameArrayIndex].player3Score)")
                        print("player4Score at end of 5 players in updteScoreWithTrickPoints: \(match.games[match.currentGameArrayIndex].player4Score)")
                        print("player5Score at end of 5 players in updteScoreWithTrickPoints: \(match.games[match.currentGameArrayIndex].player5Score)")
                        
                    }
                    // Set hand to completed, and show next hand arrow
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].isCompleted = true
                    // Check if bid winner was set
                    checkIfBidderWasSet()
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].isTrickPointsSaved = true
                    
                    // Force refresh of HandView to show updated score
                    forceViewUpdate = Int.random(in: 999..<99999)
                    
                    // Update the selected bid winner name in the Hand from the value saved in Match
                    // TODO: - Fix this so only use  value in Hand and not use Match - issue is with Picker not working with Hand value
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].selectedBidWinnerName = match.selectedHandBidWinnerName
                }
            } catch {
                print("ERROR saving trick points in updateScoreWithTrickPoints() in PinochleManger")
            }
        }
    }
    
    func calculateTrickPoints() {
        print("bidWinnerTeamTrickPointsText at start of calculateTrickPoints(): \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)")
        print("otherTeamTrickPointsText at start of calculateTrickPoints(): \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)")
        
        var bidWinerTrickPointsValue = 0
        var otherTeamTrickPointsValue = 0
        if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
            bidWinerTrickPointsValue = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
        }
        if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
            otherTeamTrickPointsValue = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
        }
        //        print("bidWinerTrickPointsValue before calaculateTrickPoints: \(bidWinerTrickPointsValue)")
        //        print("otherTeamTrickPointsValue before calaculateTrickPoints: \(otherTeamTrickPointsValue)")
        // If only one trick points TextField is used. Calculate other teams trick points
        if match.selectedNumberOfPlayers == 4 {
            
            if bidWinerTrickPointsValue == 0 && otherTeamTrickPointsValue != 0 {
                //print("[4] otherTeamTrickPointsValue != 0 - \(otherTeamTrickPointsValue)")
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText = String(Int(settings.pointsPerHand4Players)! - otherTeamTrickPointsValue)
            } else if otherTeamTrickPointsValue == 0 && bidWinerTrickPointsValue != 0 {
                //print("[4-2] math result: \(String(Int(settings.pointsPerHand4Players)! - bidWinerTrickPointsValue))")
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText = String(Int(settings.pointsPerHand4Players)! - bidWinerTrickPointsValue)
            }
        } else if match.selectedNumberOfPlayers == 5 {
            if bidWinerTrickPointsValue == 0 && otherTeamTrickPointsValue != 0 {
                //print("otherTeamTrickPointsText != 0 - \(otherTeamTrickPointsValue)")
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText = String(Int(settings.pointsPerHand5Players)! - otherTeamTrickPointsValue)
            } else if otherTeamTrickPointsValue == 0 && bidWinerTrickPointsValue != 0 {
                //print("[5] bidWinnerTeamTrickPointsText != 0 - \(bidWinerTrickPointsValue)")
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText = String(Int(settings.pointsPerHand5Players)! - bidWinerTrickPointsValue)
            }
        } else if match.selectedNumberOfPlayers == 6 {
            if bidWinerTrickPointsValue == 0 && otherTeamTrickPointsValue != 0 {
                //print("[6]otherTeamTrickPointsText != 0 - \(otherTeamTrickPointsValue)")
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText = String(Int(settings.pointsPerHand6Players)! - otherTeamTrickPointsValue)
            } else if otherTeamTrickPointsValue == 0 && bidWinerTrickPointsValue != 0 {
                //print("[6-2]bidWinnerTeamTrickPointsText != 0 - \(bidWinerTrickPointsValue)")
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText = String(Int(settings.pointsPerHand6Players)! - bidWinerTrickPointsValue)
            }
            
        }
        print("bidWinnerTeamTrickPointsText at end of calculateTrickPoints(): \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)")
        print("otherTeamTrickPointsText at end of calculateTrickPoints(): \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)")
    }
    
    func checkIfBidderWasSet() {
        
        // Determine if bidWinner was set. If so, adjust scores
        // For 3 Players Game
        if match.selectedNumberOfPlayers == 3 {
            switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
            case 1:
                // Determne if bidder was set, and if so how much to deduct from bid winner's score
                let amountBid = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                let bidWinnerMeldPoints = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                let bidWinnerTrickPoints = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)!
                if amountBid > (bidWinnerMeldPoints + bidWinnerTrickPoints) {
                    // Bidder was set
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet = true
                    match.games[match.currentGameArrayIndex].player1Score -= (amountBid + bidWinnerMeldPoints + bidWinnerTrickPoints)
                }
            case 2:
                let amountBid = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                let bidWinnerMeldPoints = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                let bidWinnerTrickPoints = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)!
                if amountBid > (bidWinnerMeldPoints + bidWinnerTrickPoints) {
                    // Bidder was set
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet = true
                    match.games[match.currentGameArrayIndex].player2Score -= (amountBid + bidWinnerMeldPoints + bidWinnerTrickPoints)
                }
            case 3:
                let amountBid = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                let bidWinnerMeldPoints = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                let bidWinnerTrickPoints = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!
                if amountBid > (bidWinnerMeldPoints + bidWinnerTrickPoints) {
                    // Bidder was set
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet = true
                    match.games[match.currentGameArrayIndex].player3Score -= (amountBid + bidWinnerMeldPoints + bidWinnerTrickPoints)
                }
            default:
                print("ERROR defult case option in checkIfBidderWasSet()")
            }
        } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
            // For 4 & 6 Players Game
            let amountBid = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
            let teamMeldPoints = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld
            let teamTrickPoints = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
            if amountBid > (teamMeldPoints + teamTrickPoints) {
                // Bidder was set so adjust score. Remove meld and trick points and bid amount from team score
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet = true
                var deductionAmount = 0
                //let bidWinnerTeamTrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText
                //let otherTeamTrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText
                
                switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
                case 1:
                    // Determne how much to deduct from bid winner's team's score
                    deductionAmount = (amountBid + teamTrickPoints + teamMeldPoints)
                    //deductionAmount = amountBid + teamTrickPoints + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                    match.games[match.currentGameArrayIndex].team1Score -= deductionAmount
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText = ""
                case 2:
                    // Determne how much to deduct from bid winner's score
                    deductionAmount = (amountBid + teamTrickPoints + teamMeldPoints)
                    //deductionAmount = amountBid + teamTrickPoints + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                    match.games[match.currentGameArrayIndex].team2Score -= deductionAmount
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText = ""
                case 3:
                    // Determne how much to deduct from bid winner's score
                    deductionAmount = (amountBid + teamTrickPoints + teamMeldPoints)
                    //deductionAmount = amountBid + teamTrickPoints + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                    match.games[match.currentGameArrayIndex].team1Score -= deductionAmount
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText = ""
                case 4:
                    // Determne how much to deduct from bid winner's score
                    deductionAmount = (amountBid + teamTrickPoints + teamMeldPoints)
                    //deductionAmount = amountBid + teamTrickPoints + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
                    match.games[match.currentGameArrayIndex].team2Score -= deductionAmount
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText = ""
                case 5:
                    // Determne how much to deduct from bid winner's score
                    deductionAmount = (amountBid + teamTrickPoints + teamMeldPoints)
                    //deductionAmount = amountBid + teamTrickPoints + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!
                    match.games[match.currentGameArrayIndex].team1Score -= deductionAmount
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText = ""
                case 6:
                    // Determne how much to deduct from bid winner's team's score
                    deductionAmount = (amountBid + teamTrickPoints + teamMeldPoints)
                    //deductionAmount = amountBid + teamTrickPoints + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)!
                    match.games[match.currentGameArrayIndex].team2Score -= deductionAmount
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText = ""
//                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText = ""
                default:
                    print("ERROR defult case option in checkIfBidderWasSet()")
                }
                print("Team 1 score at end of checkIfBidderWasSet: \(match.games[match.currentGameArrayIndex].team1Score)")
                print("Team 2 score at end of checkIfBidderWasSet: \(match.games[match.currentGameArrayIndex].team2Score)")
            }
        } else if match.selectedNumberOfPlayers == 5 {
            // For 5 Players Game
            let amountBid = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
            let teamMeldPoints = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld
            let teamTrickPoints = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
            if amountBid > (teamMeldPoints + teamTrickPoints) {
                // Bidder was set so adjust score. Remove meld and trick points and bid amount from team score
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet = true
                var deductionAmount = 0
                //let bidWinnerTeamTrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText
                //let otherTeamTrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText
                
                switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
                case 1:
                    // Determne how much to deduct from bid winner's team's score
                    deductionAmount = amountBid + teamTrickPoints + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                    match.games[match.currentGameArrayIndex].player1Score -= deductionAmount
                    deductPartnerTrickPoints(deductionAmount: deductionAmount)
                case 2:
                    // Determne how much to deduct from bid winner's score
                    deductionAmount = amountBid + teamTrickPoints + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                    match.games[match.currentGameArrayIndex].player2Score -= deductionAmount
                    deductPartnerTrickPoints(deductionAmount: deductionAmount)
                case 3:
                    // Determne how much to deduct from bid winner's score
                    deductionAmount = amountBid + teamTrickPoints + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                    match.games[match.currentGameArrayIndex].player3Score -= deductionAmount
                    deductPartnerTrickPoints(deductionAmount: deductionAmount)
                case 4:
                    // Determne how much to deduct from bid winner's score
                    deductionAmount = amountBid + teamTrickPoints + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
                    match.games[match.currentGameArrayIndex].player4Score -= deductionAmount
                    deductPartnerTrickPoints(deductionAmount: deductionAmount)
                case 5:
                    // Determne how much to deduct from bid winner's score
                    deductionAmount = amountBid + teamTrickPoints + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!
                    match.games[match.currentGameArrayIndex].player5Score -= deductionAmount
                    deductPartnerTrickPoints(deductionAmount: deductionAmount)
                default:
                    print("ERROR defult case option in checkIfBidderWasSet()")
                }
            }
        }
        print("End of checkIfBidderWasSet")
    }
    
    func deductPartnerTrickPoints(deductionAmount: Int) {
        switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber {
        case 1:
            match.games[match.currentGameArrayIndex].player1Score -= (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!)
        case 2:
            match.games[match.currentGameArrayIndex].player2Score -= (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!)
        case 3:
            match.games[match.currentGameArrayIndex].player3Score -= (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!)
        case 4:
            match.games[match.currentGameArrayIndex].player4Score -= (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!)
        case 5:
            match.games[match.currentGameArrayIndex].player5Score -= (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!)
        default:
            print("ERROR default case option in deductPartnerTrickPoints()")
        }
    }
    
    func checkIfGameWinner() -> Bool {
        print("Starting checkIfGameWinner()")
        // Check if there is a game winner. If so, save info to database.
        // Do not create new game or hand here. It is done in checkIfMatchCompleted.
        
        // Check if there is a game winner and if so ...
        var isAGameWinner = false
        var gameWinningTeam = ""
        
        if match.selectedNumberOfPlayers == 3 {
            if match.games[match.currentGameArrayIndex].player1Score >= Int(settings.pointsToWinGame3Players)! {
                gameWinningTeam = match.player1Name
                isAGameWinner = true
            } else if match.games[match.currentGameArrayIndex].player2Score >= Int(settings.pointsToWinGame3Players)! {
                gameWinningTeam = match.player2Name
                isAGameWinner = true
            } else if match.games[match.currentGameArrayIndex].player3Score >= Int(settings.pointsToWinGame3Players)! {
                gameWinningTeam = match.player3Name
                isAGameWinner = true
            }
            
        } else if match.selectedNumberOfPlayers == 4 {
            if match.games[match.currentGameArrayIndex].team1Score >= Int(settings.pointsToWinGame4Players)! {
                gameWinningTeam = Constants.TEAM_1
                isAGameWinner = true
            }
            if match.games[match.currentGameArrayIndex].team2Score >= Int(settings.pointsToWinGame4Players)! {
                gameWinningTeam = Constants.TEAM_2
                isAGameWinner = true
            }
            if match.games[match.currentGameArrayIndex].team1Score > match.games[match.currentGameArrayIndex].team2Score {
                gameWinningTeam = Constants.TEAM_1
            }
        } else if match.selectedNumberOfPlayers == 5 {
            if match.games[match.currentGameArrayIndex].player1Score >= Int(settings.pointsToWinGame5Players)! {
                gameWinningTeam = match.player1Name
                isAGameWinner = true
            } else if match.games[match.currentGameArrayIndex].player2Score >= Int(settings.pointsToWinGame5Players)! {
                gameWinningTeam = match.player2Name
                isAGameWinner = true
            } else if match.games[match.currentGameArrayIndex].player3Score >= Int(settings.pointsToWinGame5Players)! {
                gameWinningTeam = match.player3Name
                isAGameWinner = true
            } else if match.games[match.currentGameArrayIndex].player4Score >= Int(settings.pointsToWinGame5Players)! {
                gameWinningTeam = match.player4Name
                isAGameWinner = true
            } else if match.games[match.currentGameArrayIndex].player5Score >= Int(settings.pointsToWinGame5Players)! {
                gameWinningTeam = match.player5Name
                isAGameWinner = true
            }
        } else if match.selectedNumberOfPlayers == 6 {
            if match.games[match.currentGameArrayIndex].team1Score >= Int(settings.pointsToWinGame6Players)! {
                gameWinningTeam = Constants.TEAM_1
                isAGameWinner = true
            }
            if match.games[match.currentGameArrayIndex].team2Score >= Int(settings.pointsToWinGame6Players)! {
                gameWinningTeam = Constants.TEAM_2
                isAGameWinner = true
            }
            if match.games[match.currentGameArrayIndex].team1Score > match.games[match.currentGameArrayIndex].team2Score {
                gameWinningTeam = Constants.TEAM_1
            }
        }
        
        if isAGameWinner {
            //print("Inside isAGameWinner")
            if let realm = realm {
                do {
                    try realm.write {
                        match.games[match.currentGameArrayIndex].isCompleted = true
                        match.games[match.currentGameArrayIndex].gameWinnerText = gameWinningTeam
                        switch gameWinningTeam {
                        case Constants.TEAM_1:
                            match.team1GamesWon += 1
                        case Constants.TEAM_2:
                            match.team2GamesWon += 1
                        case match.player1Name:
                            match.player1GamesWon += 1
                        case match.player2Name:
                            match.player2GamesWon += 1
                        case match.player3Name:
                            match.player3GamesWon += 1
                        case match.player4Name:
                            match.player4GamesWon += 1
                        case match.player5Name:
                            match.player5GamesWon += 1
                        default:
                            print("ERROR in switch statement for gameWinningTeam of saveMeld in checkIfGameWinner of PinochleManager")
                        }
                        // Set flags that current game is over
                        match.showingNewGameButton = true
                        match.showingNewGameArrow = true
                        match.isDisabledNextHandBtn = false
                        match.isDisabledRenegeBtn = true
                        //forceViewUpdate = 267
                        //showingPublishedNewGameButton = true
                        //showingPublishedNewGameArrow = true
                        //isDisabledPublishedNextHandBtn = false
                        //isDisabledPublishedRenegeBtn = true
                    }
                } catch {
                    print("ERROR in isAGameWinner in checkIfGameWinner() in Pinochle Manager")
                }
            }
        }
        //print("End of checkIfGameWinner()")
        return isAGameWinner
        
    }
    
    func checkIfMatchCompleted() -> Bool {
        print("Starting checkIfMatchCompleted")
        var isMatchWinner = false
        if let realm = realm {
            do {
                try realm.write {
                    // Determine if there is a match winner when each game is completed
                    // Match is won when a team or player wins 2 games in the match
                    var matchWinner = ""
                    if match.team1GamesWon == 2 {
                        // Match over Team 1 wins
                        matchWinner = Constants.TEAM_1
                        isMatchWinner = true
                    } else if match.team2GamesWon == 2 {
                        // Match over Team 2 wins
                        matchWinner = Constants.TEAM_2
                        isMatchWinner = true
                    } else if match.player1GamesWon == 2 {
                        matchWinner = match.player1Name
                        isMatchWinner = true
                    } else if match.player2GamesWon == 2 {
                        matchWinner = match.player2Name
                        isMatchWinner = true
                    } else if match.player3GamesWon == 2 {
                        matchWinner = match.player3Name
                        isMatchWinner = true
                    } else if match.player4GamesWon == 2 {
                        matchWinner = match.player4Name
                        isMatchWinner = true
                    } else if match.player5GamesWon == 2 {
                        matchWinner = match.player5Name
                        isMatchWinner = true
                    } else if match.player6GamesWon == 2 {
                        matchWinner = match.player6Name
                        isMatchWinner = true
                    }
                    if isMatchWinner {
                        print("There is a match winner so match is over in checkifMatchCompleted")
                        //print("matchWinner in checkifMatchCompleted in Hand+Extension: \(matchWinner)")
                        // Set match completed to true
                        match.isCompleted = true
                        match.matchWinnerText = matchWinner
                        // Set flags for match over, game over and hand over
                        match.showingNewMatchButton = true
                        match.showingNewGameButton = false
                        match.showingNewGameArrow = false
                        match.showingNextHandArrow = false
                        match.isDisabledNextHandBtn = true
                    }
                }
            } catch {
                print("ERROR checkIfMartchCompleted() in Pinochle Manager")
            }
        }
        print("End of checkIfMatchCompleted")
        return isMatchWinner
    }
    
    
    func validateTrickPointsValues() -> Bool {
        //print("Starting validateTrickPointsValues()")
        
        /*
         First Check. Check if the bid winner trick points text field has a value. If so, validate it and if valid return true.
         Second Check. If bid winner field was empty, check if other team text field has a value. If so, validate it and if valid return true.
         Third Check. If bid winner field had value but was invalid, check if other team text field has a value. If so, validate it and if valid return true.
         Valid Number Check. Make sure is a number value and is between 0-999.
         Total Check. Make sure the total of both trick points text fields is valid if used entered values in both fields.
         
         User can leave either Bid Winner Team Trick Points field empty or Other Team Trick Points field empty and other value will be calculated;
         but one of the fields must have a value. If user enters values for both fields then just use the bid winner value.
         */
        var isValid = true
        if let realm = realm {
            do {
                try realm.write {
                    let bidWinnerTeamTrickPointsAsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText
                    let otherTeamTrickPointsAsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText
                    var emptyTrickPointsValuesCount = 0
                    
                    //print("bidWinnerTeamTrickPointsAsText: \(bidWinnerTeamTrickPointsAsText) in validateTrickPointsValues()")
                    //print("otherTeamTrickPointsAsText: \(otherTeamTrickPointsAsText) in validateTrickPointsValues()")
                    
                    if match.selectedNumberOfPlayers == 3 {
                        if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText.isEmpty {
                            if !validateIndividualTricksTextFieldValue(textValueToValidate: match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText) {
                                isValid = false
                            }
                        } else {
                            emptyTrickPointsValuesCount += 1
                        }
                        if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText.isEmpty {
                            if !validateIndividualTricksTextFieldValue(textValueToValidate: match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText) {
                                isValid = false
                            }
                        } else {
                            emptyTrickPointsValuesCount += 1
                        }
                        if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText.isEmpty {
                            if !validateIndividualTricksTextFieldValue(textValueToValidate: match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText) {
                                isValid = false
                            }
                        } else {
                            emptyTrickPointsValuesCount += 1
                        }
                        // Only one player may have empty string value
                        if !(emptyTrickPointsValuesCount < 2) {
                            // At least 2 of the 3 players trick points values are empty so it is invalid
                            isValid = false
                        }
                        
                        if isValid {
                            // Passed validation so far so proceed to validate that total trick points entered do not exceed maximum
                            var player1Value = 0
                            var player2Value = 0
                            var player3Value = 0
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText.isEmpty {
                                player1Value = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)!
                            } else {
                                //player1TrickPoitsText is empty so calculate its value and save it
                                player1Value = (Int(settings.pointsPerHand3Players)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!)
                                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText = String(player1Value)
                            }
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText.isEmpty {
                                player2Value = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)!
                            } else {
                                //player2TrickPoitsText is empty so calculate its value and save it
                                player2Value = (Int(settings.pointsPerHand3Players)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!)
                                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText = String(player2Value)
                            }
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText.isEmpty {
                                player3Value = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!
                            } else {
                                player3Value = (Int(settings.pointsPerHand3Players)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)!)
                                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText = String(player3Value)
                            }
                            if  (Int(settings.pointsPerHand3Players)! != (player1Value + player2Value + player3Value)) {
                                isValid = false
                            }
                        }
                        
                    } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 5 || match.selectedNumberOfPlayers == 6 {
                        //print("in validateTrickPointsValues for 4, 5 or 6 players")
                        // Start by arbitrarily checking if the bid winner trick points text field is empty. If not, then validate it. If it passes validation then done with checking and return true
                        if !bidWinnerTeamTrickPointsAsText.isEmpty {
                            // Bid winner text field has a value so validate it
                            //print("bidWinnerTeamTrickPointsAsText is not empty in validateTrickPointsValues()")
                            if !validateTeamTricksTextFieldValues(valueToValidate: bidWinnerTeamTrickPointsAsText) {
                                isValid = false
                            }
                            // Bid winner text field is empty so check the Other Team text field
                        }  // else
                        if !otherTeamTrickPointsAsText.isEmpty {
                            //print("in else if in validateTrickPointsValues for 4, 5 or 6 players")
                            // Other team text field has a value so validate it
                            if !validateTeamTricksTextFieldValues(valueToValidate: match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText) {
                                isValid = false
                            }
                            // Confirm both trick points text fields are empty and set validation to false
                        }   // else
                        if bidWinnerTeamTrickPointsAsText.isEmpty && otherTeamTrickPointsAsText.isEmpty {
                            //print("in final else in validateTrickPointsValues for 4, 5 or 6 players")
                            isValid = false
                        }
                    }
                }
            } catch {
                print("ERROR archiving Match in Pinochle Manager")
            }
        }
        return isValid
    }
    
    func validateTeamTricksTextFieldValues(valueToValidate: String) -> Bool {
        
        if !validateIsNumbersString(testStringParam: valueToValidate) {
            //print("!validateIsNumbersString()")
            return false
        }
        if !(1..<76 ~= Int(valueToValidate)!) {
            //print("!1..<999")
            return false
        }
        if match.selectedNumberOfPlayers == 3 {
            if !(Int(valueToValidate)! < Int(settings.pointsPerHand3Players)!) {
                //print("!validateIsNumbersString()")
                return false
            }
        } else if match.selectedNumberOfPlayers == 4 {
            if !(Int(valueToValidate)! < Int(settings.pointsPerHand4Players)!) {
                //print("!validateIsNumbersString()")
                return false
            }
        } else if match.selectedNumberOfPlayers == 5 {
            if !(Int(valueToValidate)! < Int(settings.pointsPerHand5Players)!) {
                print("!validateIsNumbersString()")
                return false
            }
        } else if match.selectedNumberOfPlayers == 3 {
            if !(Int(valueToValidate)! < Int(settings.pointsPerHand6Players)!) {
                //print("!validateIsNumbersString()")
                return false
            }
        }
        return true
    }
    
    func validateIndividualTricksTextFieldValue(textValueToValidate: String) -> Bool {
        
        //var isValid = true
        if !validateIsNumbersString(testStringParam: textValueToValidate) {
            //isValid = false
            return false
        }
        if !(0..<999 ~= Int(textValueToValidate)!) {
            //isValid = false
            return false
        }
        if match.selectedNumberOfPlayers == 3 {
            if !(Int(textValueToValidate)! < Int(settings.pointsPerHand3Players)!) {
                //isValid = false
                return false
            }
        }
        if match.selectedNumberOfPlayers == 4 {
            if !(Int(textValueToValidate)! < Int(settings.pointsPerHand4Players)!) {
                //isValid = false
                return false
            }
        }
        if match.selectedNumberOfPlayers == 5 {
            if !(Int(textValueToValidate)! < Int(settings.pointsPerHand5Players)!) {
                print("textValueToValidate less than pointsPerHand5Players ")
                //isValid = false
                return false
            }
        }
        if match.selectedNumberOfPlayers == 6 {
            if !(Int(textValueToValidate)! < Int(settings.pointsPerHand6Players)!) {
                //isValid = false
                return false
            }
        }
        
        //return isValid
        return true
    }
    
    // MARK: - Meld Points Functions
    
    
    func updateScoreWithMeld() {
        
//        print("player1MeldText at start of updateScoreWithMeld: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)")
//        print("player2MeldText at start of updateScoreWithMeld: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)")
//        print("player3MeldText at start of updateScoreWithMeld: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)")
//        print("player4MeldText at start of updateScoreWithMeld: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)")
//        print("player5MeldText at start of updateScoreWithMeld: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)")
//        print("player6MeldText at start of updateScoreWithMeld: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)")
        
        if let realm = realm {
            do {
                try realm.write {
                    print("Starting updateScoreWithMeld")
                    // Update scores in Game and team meld in Hand
                    var team1Meld = 0
                    var team2Meld = 0
                    if match.selectedNumberOfPlayers == 3 {
                        match.games[match.currentGameArrayIndex].player1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                        match.games[match.currentGameArrayIndex].player2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                        match.games[match.currentGameArrayIndex].player3Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                    } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
                        // Update Team 1 and Team 2 scores by adding meld
                        team1Meld += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!)
                        team2Meld += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!)
                        
                        if match.selectedNumberOfPlayers == 6 {
                            team1Meld += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!
                            team2Meld += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)!
                        }
//                        print("team1Meld after math before set to score in updateScoreWithMeld: \(team1Meld)")
//                        print("team2Meld after math before set to score in updateScoreWithMeld: \(team2Meld)")
                        match.games[match.currentGameArrayIndex].team1Score += team1Meld
                        match.games[match.currentGameArrayIndex].team2Score += team2Meld
//                        print("team1Score after set to score in updateScoreWithMeld: \(match.games[match.currentGameArrayIndex].team1Score)")
//                        print("team2Score after set to score in updateScoreWithMeld: \(match.games[match.currentGameArrayIndex].team2Score)")
                        
                        // Update bid winner team meld
                        if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 1 || match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 3 {
                            // Bid winner is Team 1 player
                            match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld = team1Meld
                        } else {
                            // Bid winnr is Team 2 player
                            match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld = team2Meld
                        }
                    } else if match.selectedNumberOfPlayers == 5 {
                        match.games[match.currentGameArrayIndex].player1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                        match.games[match.currentGameArrayIndex].player2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                        match.games[match.currentGameArrayIndex].player3Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                        match.games[match.currentGameArrayIndex].player4Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
                        match.games[match.currentGameArrayIndex].player5Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!
                    }
                    
                    // Determine and set the points needed to make bid
                    calculateBidWinnerTeamMeld()
                    
                    var pointsNeeded = 0
                    if match.selectedNumberOfPlayers == 3 {
                        switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
                        case 1:
                            pointsNeeded = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)! -  Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                        case 2:
                            pointsNeeded = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)! -  Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                        case 3:
                            pointsNeeded = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)! -  Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                        default:
                            print("ERROR setting points needed to make bid for 3 players game in updateScoreWithMeld() of Hand+Extension")
                        }
                    } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 5 || match.selectedNumberOfPlayers == 6 {
                        pointsNeeded = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)! -  match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld
                    }
                    
                    // If more than 1 point needed then use pointsNeeded value, otherwise use "1 Trick Point"
                    if pointsNeeded > 1 {
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].pointsNeededToMakeBid = "\(pointsNeeded) Trick Points"
                    } else {
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].pointsNeededToMakeBid = "1 Trick Point"
                    }
                    
                    // Set isMeldSaved flag to true
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].isMeldSaved = true

                    // Force refresh of HandView to show updated score
                    forceViewUpdate = Int.random(in: 999..<99999)
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
        }
    }
    
    func calculateBidWinnerTeamMeld() {
        switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
        case 1:
            match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
            if match.selectedNumberOfPlayers == 4 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
            } else if match.selectedNumberOfPlayers == 5 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += getPartnerMeld()
            } else if match.selectedNumberOfPlayers == 6 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!)
            }
        case 2:
            match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
            if match.selectedNumberOfPlayers == 4 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
            } else if match.selectedNumberOfPlayers == 5 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += getPartnerMeld()
            } else if match.selectedNumberOfPlayers == 6 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!)
            }
        case 3:
            match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
            if match.selectedNumberOfPlayers == 4 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
            } else if match.selectedNumberOfPlayers == 5 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += getPartnerMeld()
            } else if match.selectedNumberOfPlayers == 6 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!)
            }
        case 4:
            match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
            if match.selectedNumberOfPlayers == 4 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
            } else if match.selectedNumberOfPlayers == 5 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += getPartnerMeld()
            } else if match.selectedNumberOfPlayers == 6 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!)
            }
        case 5:
            match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!
            if match.selectedNumberOfPlayers == 5 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += getPartnerMeld()
            } else if match.selectedNumberOfPlayers == 6 {
                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld += (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)! )
            }
        case 6:
            match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld = (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!  + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)!)
        default:
            print("ERROR in bidWinnerPlayerNumber switch statement")
        }
        //print("bidWinnerTeamMeld in calcualteBidWinnerTeamMeld(): \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld)")
        
    }
    
    
    func getPartnerMeld() -> Int {
        switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber {
        case 1:
            return Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
        case 2:
            return Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
        case 3:
            return Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
        case 4:
            return Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
        case 5:
            return Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!
        default:
            print("ERROR getting partner meld in getPartnerMeld() of Hand+Extension")
        }
        return 0
    }
    
    func setBidWinnerPlayerNumber() {
        // Set Bid Winner player number
        //print("bidWinnerName in setBidWinnerPlayerNumber: \(match.selectedHandBidWinnerName)")
        if let realm = realm {
            do {
                try realm.write {
                    switch match.selectedHandBidWinnerName {
                    case match.player1Name :
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 1
                    case match.player2Name :
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 2
                    case match.player3Name:
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 3
                    case match.player4Name:
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 4
                    case match.player5Name:
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 5
                    default:
                        print("ERROR in switch statement for selectedHandBidWinnerName of setBidWinnerPlayerNumber in PinochleManager - selectedHandBidWinnerName \(match.selectedHandBidWinnerName)")
                    }
                    
//                    if match.selectedHandBidWinnerName == match.player1Name {
//                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 1
//                    } else if match.selectedHandBidWinnerName == match.player2Name {
//                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 2
//                    } else if match.selectedHandBidWinnerName == match.player3Name {
//                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 3
//                    } else if match.selectedHandBidWinnerName == match.player4Name {
//                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 4
//                    } else if match.selectedHandBidWinnerName == match.player5Name {
//                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 5
//                    } else if match.selectedHandBidWinnerName == match.player6Name {
//                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 6
//                    }
                }
            } catch {
                print("ERROR setting bid winner player number in setBidWinnerPlayerNumber() in Pinochle Manager")
            }
        }
    }
    
    func setPartnerPlayerNumber() {
        // Set Bid Winner Partner player number
        //print("bidWinnerName in setBidWinnerPlayerNumber: \(match.selectedHandBidWinnerName)")
        if let realm = realm {
            do {
                try realm.write {
                    switch match.selectedPartnerName {
                    case match.player1Name :
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber = 1
                    case match.player2Name :
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber = 2
                    case match.player3Name:
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber = 3
                    case match.player4Name:
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber = 4
                    case match.player5Name:
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber = 5
                    default:
                        print("ERROR in switch statement for selectedPartnerName of setPartnerPlayerNumber in PinochleManager - selectedPartnerName \(match.selectedPartnerName)")
                    }
                }
            } catch {
                print("ERROR setting partner player number in setPartnerPlayerNumber() in Pinochle Manager")
            }
        }
    }
    func validateMeldPointEntries() -> Bool {
        var isValid = false
        var meldPointsArray = [String]()
        
        // Convert winning bid to an array to use in validator
        if match.selectedNumberOfPlayers == 3 {
            meldPointsArray = [match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText
            ]
        } else if match.selectedNumberOfPlayers == 4 {
            meldPointsArray = [match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText
            ]
        } else if match.selectedNumberOfPlayers == 5 {
            meldPointsArray = [match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText
            ]
        } else if match.selectedNumberOfPlayers == 6 {
            meldPointsArray = [match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText,
                               match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText
            ]
        }
        
        isValid = validateNumberTextFieldValues(numbersArrayParam: meldPointsArray)
        if Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)! < Int(settings.minimumOpeningBid4Players)! {
            isValid = false
        }
        
        return isValid
    }
    
    func validateWinningBidEntry(winningBidEntry: String) -> Bool {
        print("winngBidEntry in validateWinningBidEntryof PinochleManager: \(winningBidEntry)")
        //print("Int value of winningBidEntry: \(Int(winningBidEntry)!)")
        var isValid = false
        // Convert winning bid to an array to use in validator
        let trimmedWinningBidText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText.trimmingCharacters(in: .whitespacesAndNewlines)
        print("trimmedWinningBidText in validateWinningBidEntryof PinochleManager: \(trimmedWinningBidText)")
        //let winningBidArray = [match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText]
        let winningBidArray = [trimmedWinningBidText]
        isValid = validateNumberTextFieldValues(numbersArrayParam: winningBidArray)
        if isValid {
            // Since isValid the text value can't be empty so OK to force unwrap it to and Int
            switch match.selectedNumberOfPlayers {
            case 3:
                if Int(winningBidEntry)! < Int(settings.minimumOpeningBid3Players)! {
                    isValid = false
                }
            case 4:
                if Int(trimmedWinningBidText)! < Int(settings.minimumOpeningBid4Players)! {
                    isValid = false
                }
            case 5:
                if Int(winningBidEntry)! < Int(settings.minimumOpeningBid5Players)! {
                    isValid = false
                }
            case 6:
                if Int(winningBidEntry)! < Int(settings.minimumOpeningBid6Players)! {
                    isValid = false
                }
            default:
                print("ERROR validating winning bid is at least equal to the minimum opening bid in validteWinningBidEntry() of Hand+Extension")
            }
        }
        return isValid
    }
    
    func lockMeld() {
        
        if let realm = realm {
            do {
                try realm.write {
                    match.isDisabledBidWinnerPicker = true
                    match.isDisabledPartnerPicker = true
                    match.isDisabledPlayer1MeldTextField = true
                    match.isDisabledPlayer2MeldTextField = true
                    match.isDisabledPlayer3MeldTextField = true
                    match.isDisabledPlayer4MeldTextField = true
                    match.isDisabledPlayer5MeldTextField = true
                    match.isDisabledPlayer6MeldTextField = true
                    match.isDisabledTrumpPicker = true
                    match.isDisabledWinningBidTextField = true
                    match.isDisabledSaveMeldBtn = true
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
        }
    }
    
    func lockTrickPoints() {
        if let realm = realm {
            do {
                try realm.write {
                    match.isDisabledBidWinnerTrickPointsTextField = true
                    match.isDisabledOtherTeamTrickPointsTextField = true
                    match.isDisabledPlayer1TrickPointsTextField = true
                    match.isDisabledPlayer2TrickPointsTextField = true
                    match.isDisabledPlayer3TrickPointsTextField = true
                    match.isDisabledSaveTricksBtn = true
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
        }
    }
    
    func unlockMeld() {
        if let realm = realm {
            do {
                try realm.write {
                    match.isDisabledBidWinnerPicker = false
                    match.isDisabledPartnerPicker = false
                    match.isDisabledPlayer1MeldTextField = false
                    match.isDisabledPlayer2MeldTextField = false
                    match.isDisabledPlayer3MeldTextField = false
                    match.isDisabledPlayer4MeldTextField = false
                    match.isDisabledPlayer5MeldTextField = false
                    match.isDisabledPlayer6MeldTextField = false
                    match.isDisabledTrumpPicker = false
                    match.isDisabledWinningBidTextField = false
                    match.isDisabledSaveMeldBtn = false
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
        }
    }
    
    func unlockTrickPoints() {
        if let realm = realm {
            do {
                try realm.write {
                    match.isDisabledBidWinnerTrickPointsTextField = false
                    match.isDisabledOtherTeamTrickPointsTextField = false
                    match.isDisabledPlayer1TrickPointsTextField = false
                    match.isDisabledPlayer2TrickPointsTextField = false
                    match.isDisabledPlayer3TrickPointsTextField = false
                    match.isDisabledSaveTricksBtn = false
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
        }
    }
}


// MARK: - Extension of PinochleManger

extension PinochleManager {
    
    func applyMisdeal() {
        /*
         Misdeal is where the dealer did not correctly give the right number of cards to each player. This is usually discovered during play of the hand,
         but sometimes is discovered during the meld process before hand play starts.
         The remedy if it occurs during hand play is to cancel the hand with no player getting meld or trick points and having the next dealer deal a new hand
         1. Set isCompeted for hand to true
         2. Set the wasMisdeal flag for hand to true. This is used to exclude this hand from any computations and lists
         3. Subtract any meld from team scores to which it might have been previously added, i.e. 4 & 6 player games
         4. Subtract any meld from player score to which it might have been previously added, i.e. 3 & 5 player games
         5. Reset all hand values to default values - so they won't be used by mistake in other displayes or calculations
         */
        
        if let realm = realm {
            do {
                try realm.write {
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].isCompleted = true
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].wasMisdeal = true
                    // Check meld for each player to see if not 0, and if so make correction to score and meld
                    if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText.isEmpty {
                        // Player has meld so subtract it from appropriate score
                        if match.selectedNumberOfPlayers == 3 || match.selectedNumberOfPlayers == 5 {
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                        } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
                            // Player is always part of Team 1 so subtract the meld from Team 1 score
                            match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                        }
                    }
                    if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText.isEmpty {
                        // Player has meld so subtract it from appropriate score
                        if match.selectedNumberOfPlayers == 3 || match.selectedNumberOfPlayers == 5 {
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                        } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
                            // Player is always part of Team 2 so subtract the meld from Team 2 score
                            match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                        }
                    }
                    if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText.isEmpty {
                        // Player has meld so subtract it from appropriate score
                        if match.selectedNumberOfPlayers == 3 || match.selectedNumberOfPlayers == 5 {
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                        } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
                            // Player is always part of Team 1 so subtract the meld from Team 1 score
                            match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                        }
                    }
                    if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText.isEmpty {
                        // Player has meld so subtract it from appropriate score
                        if match.selectedNumberOfPlayers == 3 || match.selectedNumberOfPlayers == 5 {
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
                        } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
                            // Player is always part of Team 2 so subtract the meld from Team 2 score
                            match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
                        }
                    }
                    if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText.isEmpty {
                        // Player has meld so subtract it from appropriate score
                        if match.selectedNumberOfPlayers == 3 || match.selectedNumberOfPlayers == 5 {
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!
                        } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
                            // Player is always part of Team 1 so subtract the meld from Team 1 score
                            match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!
                        }
                    }
                    if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText.isEmpty {
                        // Player has meld so subtract it from appropriate score - Player 6 only applies to 6 player game
                        match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)!
                    }
                    
                    // Reset all hand values to defaults
                    // Except :
                    //     dealerPlayerNumber = 0
                    //     dealerName = ""
                    //     handNumber = 1
                    
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet = false
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber = 0
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamMeld = 0
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].isMeldSaved = false
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].isTrickPointsSaved = false
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].selectedBidWinnerName = "Select"
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].selectedPartnerName = "Select"
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber = 0
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].pointsNeededToMakeBid = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].selectedTrump = 2
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText = ""
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
        }
        createNewHand()
        setHandPlayNewHandStatus()
    }
    
    func applyRenege(playerName: String) {
        print("playerName: \(playerName)")
        
        /*
         1. For reneging player, deduct meld from appropriate score
         2. If reneging player is bid winner, deduct bid from appropriate score
         2. Set all players meld to ""
         3. End current hand
         4. Start new hand
         */
        
        if let realm = realm {
            do {
                try realm.write {
                    // Deduct meld from appropriate score
                    // If reneging player if bid winner, deduct bid from appropriate score
                    if match.selectedNumberOfPlayers == 3 {
                        switch playerName {
                        case match.player1Name :
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 1 {
                                match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        case match.player2Name :
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 2 {
                                match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        case match.player3Name:
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 3 {
                                match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        default:
                            print("ERROR: defult case option for 3 players in adjustRenegeScores() in RenegeSheet")
                        }
                    } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
                        switch playerName {
                        case match.player1Name :
                            match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 1 {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        case match.player2Name :
                            match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 2 {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        case match.player3Name :
                            match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 3 {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        case match.player4Name :
                            match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 4 {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        case match.player5Name :
                            match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 5 {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        case match.player6Name :
                            match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 6 {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        default:
                            print("ERROR: defult case option for 4 or 6 players in adjustRenegeScores() in RenegeSheet")
                        }
                    } else if match.selectedNumberOfPlayers == 5 {
                        switch playerName {
                        case match.player1Name :
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 1 {
                                match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        case match.player2Name :
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 2 {
                                match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        case match.player3Name :
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 3 {
                                match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        case match.player4Name :
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 4 {
                                match.games[match.currentGameArrayIndex].player4Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        case match.player5Name :
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!
                            
                            if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 5 {
                                match.games[match.currentGameArrayIndex].player5Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
                            }
                        default:
                            print("ERROR: defult case option for 5 players in adjustRenegeScores() in RenegeSheet")
                        }
                    }
                    
                    // Set current hand to wasRenege = true and isCompleted = true
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].wasRenege = true
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].isCompleted = true
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
        }
        // create a new hand to use
        createNewHand()
        setHandPlayNewHandStatus()
        
    }
    
    func changedBidWinner() {
        
        switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
        case 1:
            print("case 1")
        case 2:
            print("case 2")
        case 3:
            print("case 3")
        case 4:
            print("case 4")
        case 5:
            print("case 5")
        case 6:
            print("case 6")
        default:
            print("ERROR in default of switch on bidWinnerPlayerNumber in chagneBidWinner() of PinochleManager")
        }
        
        if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 1 {
            
        } else if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber == 2 {
            
        }
        //setBidWinnerPlayerNumber()
        print("bidWinnerPlayerNumber in changedBidWiner() of PinochleManager: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber)")
        //match.selectedHandBidWinnerName = ""
        
        print("bidWinnerPlayerNumber after set in changedBidWiner() of PinochleManager: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber)")
        if match.selectedNumberOfPlayers == 4 {
            
        }
    }
    
    func endMatch() {
        if let realm = realm {
            do {
                try realm.write {
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].isCompleted = true
                    match.games[match.currentGameArrayIndex].isCompleted = true
                    match.matchWinnerText = "None - Match Ended"
                    match.isCompleted = true
                    print("match.isCompleted after set to true in endMatch() in Hand+Extension: \(match.isCompleted) | \(match.id)")
                    
                    // Set flags for match over, game over and hand over
                    match.showingNewMatchButton = true
                    match.showingNewGameButton = false
                    match.showingNewGameArrow = false
                    match.showingNextHandArrow = false
                    match.isDisabledNextHandBtn = true
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
            setHandPlayNewMatchStatus()
        }
        
        //        showingPublishedNewMatchButton = true
        //        showingPublishedNewGameButton = false
        //        showingPublishedNewGameArrow = false
        //        showingPublishedNextHandArrow = false
        //        isDisabledPublishedNextHandBtn = true
    }
    
    func saveHandViewEditedMeld() {
        print("Starting saveHandViewEditedMeld")
        print("team1Score at start of saveHandViewEditedMeld: \(match.games[match.currentGameArrayIndex].team1Score)")
        print("team2Score at start of saveHandViewEditedMeld: \(match.games[match.currentGameArrayIndex].team2Score)")
        
        if let realm = realm {
            do {
                try realm.write {
                    /*
                     The edited meld values (including bid winner and winning bid) have already been changed in realm when changed in the HandView, but the score is wrong if any meld point values have been changed
                     To fix this, first subtract the meld points already added to the score; and second, add both the changed and unchanged meld values to score
                     This function will subtract the meld points previously added to the score and then will call the updateScoreWithMeld() function to again add the current meld points to the score
                     */
                    if match.selectedNumberOfPlayers == 3 {
                        // Subtract the meld already added to score
                        match.games[match.currentGameArrayIndex].player1Score -= Int(match.savedPlayer1MeldText)!
                        match.games[match.currentGameArrayIndex].player2Score -= Int(match.savedPlayer2MeldText)!
                        match.games[match.currentGameArrayIndex].player3Score -= Int(match.savedPlayer3MeldText)!
                    } else if match.selectedNumberOfPlayers == 4 {
                        match.games[match.currentGameArrayIndex].team1Score -= (Int(match.savedPlayer1MeldText)! + Int(match.savedPlayer3MeldText)!)
                        match.games[match.currentGameArrayIndex].team2Score -= (Int(match.savedPlayer2MeldText)! + Int(match.savedPlayer4MeldText)!)
                    } else if match.selectedNumberOfPlayers == 5 {
                        match.games[match.currentGameArrayIndex].player1Score -= Int(match.savedPlayer1MeldText)!
                        match.games[match.currentGameArrayIndex].player2Score -= Int(match.savedPlayer2MeldText)!
                        match.games[match.currentGameArrayIndex].player3Score -= Int(match.savedPlayer3MeldText)!
                        match.games[match.currentGameArrayIndex].player4Score -= Int(match.savedPlayer4MeldText)!
                        match.games[match.currentGameArrayIndex].player5Score -= Int(match.savedPlayer5MeldText)!
                    } else if match.selectedNumberOfPlayers == 6 {
                        match.games[match.currentGameArrayIndex].team1Score -= (Int(match.savedPlayer1MeldText)! + Int(match.savedPlayer3MeldText)! + Int(match.savedPlayer5MeldText)!)
                        match.games[match.currentGameArrayIndex].team2Score -= (Int(match.savedPlayer2MeldText)! + Int(match.savedPlayer4MeldText)! + Int(match.savedPlayer6MeldText)!)
                    }
                    print("Team 1 score after subtract meld in saveHandViewEditedMeld: \(match.games[match.currentGameArrayIndex].team1Score)")
                    print("Team 2 score after subtract meld in saveHandViewEditedMeld: \(match.games[match.currentGameArrayIndex].team2Score)")
                    print("player1Score after subtract meld in saveHandViewEditedMeld: \(match.games[match.currentGameArrayIndex].player1Score)")
                    print("player2Score after subtract meld in saveHandViewEditedMeld: \(match.games[match.currentGameArrayIndex].player2Score)")
                    print("player3Score after subtract meld in saveHandViewEditedMeld: \(match.games[match.currentGameArrayIndex].player3Score)")
                    print("player4Score after subtract meld in saveHandViewEditedMeld: \(match.games[match.currentGameArrayIndex].player4Score)")
                    print("player5Score after subtract meld in saveHandViewEditedMeld: \(match.games[match.currentGameArrayIndex].player5Score)")
                }
            
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
            // In case the bid winner was changed, update the player number of the bid winner (just changing the bid winner picker does not update the player number
            //setBidWinnerPlayerNumber()
            // What about PartnerPlayerNumber if handling BidWinnerPlayerNumber
            
            // Save the new meld values in the same way they are saved from the Hand Play view
            //        print("team1Score at end of saveEditedMeld: \(match.games[match.currentGameArrayIndex].team1Score)")
            //        print("team2Score at end of saveEditedMeld: \(match.games[match.currentGameArrayIndex].team2Score)")
            updateScoreWithMeld()
        }
    }
    
    
    func adjustScoreForEditedMeld() {
        print("Starting adjustScoreForEditedMeld")
        /*
         This function is called whether or not there have been changes made to meld points or to bidder information
         It simply saves the "edited" values to the realm database replacing the prior values. Since the "edited" values were initially set to the realm values,
         if a value is not changed in the edit, then the original value is just saved again
         1. Subtract meld previously added to score, if any. Do this even if meld was not saved before and the only changes are to Bidder information since empty meld text will be trated as 0 so this won't change the score incorrectly.
         2. NO THIS IS NOT NEEDED - Set all player's meld text in realm back to "" since the new edited values will be used to update meld values in realm upon save
         3. Set the realm meld values to the edited values. The edited values start with the values from the Hand Play view so whether or not they are changed use the "edited" values
         4. Call the SaveMeld() function (the same one used on the Hand Play view to save the meld which is actually updating the score and not really saving the meld except for the teram meld.
         */
        print("team1Score at start of adjustScoreForEditedMeld: \(match.games[match.currentGameArrayIndex].team1Score)")
        print("team2Score at start of adjustScoreForEditedMeld: \(match.games[match.currentGameArrayIndex].team2Score)")
        if let realm = realm {
            do {
                try realm.write {
                    // Subtract the meld points already added to score
                    if match.selectedNumberOfPlayers == 3 {
                        
                        // Subtract the meld already saved, if any
                        match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                        match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                        match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                        
                        // Subtract the trick points already added to the current Game, if any was added
//                        match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)!
//                        match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)!
//                        match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!
                        
                    } else if match.selectedNumberOfPlayers == 4 {
                        
                        // Subtract the meld points already saved from score, if any
                        // These are going to be replaced by the "edited" values (which if not changed during editing will be the same as the original values becuase set in onApprear of EditHandPlay)
                        match.games[match.currentGameArrayIndex].team1Score -= (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!)
                        match.games[match.currentGameArrayIndex].team2Score -= (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!)
                        
                        print("Team 1 score after subtract meld in adjustScoreForEditedMeld case 4 begin before subtraction: \(match.games[match.currentGameArrayIndex].team1Score)")
                        print("Team 2 score after subtract meld in adjustScoreForEditedMeld case 4 begin before subtraction: \(match.games[match.currentGameArrayIndex].team2Score)")
                        
                        // Subtract the trick points added to score, if any - if the bidWinnerTeamTrickPointsText and otherTeamTrickPointsText are not empty then
                        // trick points were already saved once before and need to be subtracted. I fthey are empty then only meld was saved so skip this
                        // Will add correct values when save tricks elsewhere
//                        switch match.selectedHandBidWinnerName {
//                        case match.player1Name :
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
//                            }
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
//                            }
//                        case match.player2Name :
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
//                            }
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
//                            }
//                        case match.player3Name :
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
//                            }
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
//                            }
//                        case match.player4Name :
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
//                            }
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
//                            }
//                        default:
//                            print("ERROR in default of switch statement in saveEditedMeld")
//                        }
                        
                        //                        print("Team 1 score after subtract tricks in saveEditedMeld case 4 end after subtraction: \(match.games[match.currentGameArrayIndex].team1Score)")
                        //                        print("Team 2 score after subtract tricks in saveEditedMeld case 4 end after subtraction: \(match.games[match.currentGameArrayIndex].team2Score)")
                    } else if match.selectedNumberOfPlayers == 5 {
//                        print("\n     Starting saveEditedMeld 5 players")
//                        // Subtract the meld points add to score, if any
//                        print("player1Score before subtract meld in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].player1Score)")
//                        print("player1MeldText before subtract meld in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)")
                        
                        match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)!
                        match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)!
                        match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!
                        match.games[match.currentGameArrayIndex].player4Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)!
                        match.games[match.currentGameArrayIndex].player5Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!
                        
//                        print("player1Score after subtract meld in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].player1Score)")
//                        print("player2Score after subtract meld in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].player2Score)")
//                        print("player3Score after subtract meld in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].player3Score)")
//                        print("player4Score after subtract meld in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].player4Score)")
//                        print("player5Score after subtract meld in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].player5Score)")
                        
                        // Subtract the trick points added to score, if any - if the bidWinnerTeamTrickPointsText and otherTeamTrickPointsText are not empty then
                        // trick points were already saved once before and need to be subtracted. If they are empty then only meld was saved so skip this
                        // Will add correct values when save tricks elsewhere
                        var losingPlayersNumbersArray = [1, 2, 3, 4, 5]
                        //switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
                        switch handPlayBidWinnerPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            //print("player1Score as bid winner after subtract in case 1: \(match.games[match.currentGameArrayIndex].player1Score)")
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 1 }
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 2 }
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            //print("player3Score as bid winner after subtract in case 3: \(match.games[match.currentGameArrayIndex].player3Score)")
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 3 }
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            //print("player1Score as bid winner after subtract in case 4: \(match.games[match.currentGameArrayIndex].player4Score)")
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 4 }
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 5 }
                        default:
                            print("ERROR subtracting meld in adjustScoreForEditedMeld in PinochleManager")
                        }
                        //switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber {
                    switch handPlayPartnerPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 1 }
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 2 }
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 3 }
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            //print("player4Score as partner after subtract in case 4: \(match.games[match.currentGameArrayIndex].player4Score)")
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 4 }
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 5 }
                        default:
                            print("ERROR subtracting meld in adjustScoreForEditedMeld in PinochleManager")
                        }
                        // Subtract trick points to the losers scores (The other 3 players who are not the Bid Winner or the Partner)
                        // The losingPlayersNumbers array should now only contain the other 3 players
                        let firstBidLoserPlayerNumber = losingPlayersNumbersArray[0]
                        //print("losingPlayersNumbersArray: \(losingPlayersNumbersArray)")
                        //print("firstBidLoserPlayerNumber: \(firstBidLoserPlayerNumber)")
                        switch firstBidLoserPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                            //print("player1Score as first loser after subtract in case 1: \(match.games[match.currentGameArrayIndex].player1Score)")
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        default:
                            print("ERROR assigning trick points in adjustScoreForEditedMeld() of PinochleManager")
                        }
                        let secondBidLoserPlayerNumber = losingPlayersNumbersArray[1]
                        //print("secondBidLoserPlayerNumber: \(secondBidLoserPlayerNumber)")
                        switch secondBidLoserPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                            //print("player2Score as second loser after subtract in case 2: \(match.games[match.currentGameArrayIndex].player2Score)")
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        default:
                            print("ERROR assigning trick points in adjustScoreForEditedMeld() of PinochleManager")
                        }
                        let thirdBidLoserPlayerNumber = losingPlayersNumbersArray[2]
                        //print("thirdBidLoserPlayerNumber: \(thirdBidLoserPlayerNumber)")
                        switch thirdBidLoserPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                            //print("player5Score as third loser after subtract in case 5: \(match.games[match.currentGameArrayIndex].player5Score)")
                        default:
                            print("ERROR assigning trick points in updateScoreWithTrickPoints() of PinochleManager")
                        }
                        
//                        print("player1Score after subtract trick points in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].player1Score)")
//                        print("player2Score after subtract trick points in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].player2Score)")
//                        print("player3Score after subtract trick points in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].player3Score)")
//                        print("player4Score after subtract trick points in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].player4Score)")
//                        print("player5Score after subtract trick points in saveEditedMeld for 5 players: \(match.games[match.currentGameArrayIndex].player5Score)")
                    } else if match.selectedNumberOfPlayers == 6 {
                        match.games[match.currentGameArrayIndex].team1Score -= (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)!)
                        match.games[match.currentGameArrayIndex].team2Score -= (Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)!)
                        
                        // Subtract the trick points added to score, if any - if the bidWinnerTeamTrickPointsText and otherTeamTrickPointsText are not empty then
                        // trick points were already saved once before and need to be subtracted. I fthey are empty then only meld was saved so skip this
                        // Will add correct values when save tricks elsewhere
//                        switch match.selectedHandBidWinnerName {
//                        case match.player1Name :
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
//                            }
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
//                            }
//                        case match.player2Name :
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
//                            }
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
//                            }
//                        case match.player3Name :
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
//                            }
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
//                            }
//                        case match.player4Name :
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
//                            }
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
//                            }
//                        case match.player5Name :
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
//                            }
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
//                            }
//                        case match.player6Name :
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
//                            }
//                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
//                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
//                            }
//                        default:
//                            print("ERROR in default of switch statement in saveEditedMeld")
//                        }
                    }
                    
                    // Update realm values so the new values can be saved
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText = player1MeldEditHandText
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText = player2MeldEditHandText
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText = player3MeldEditHandText
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText = player4MeldEditHandText
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText = player5MeldEditHandText
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText = player6MeldEditHandText
                    match.selectedHandBidWinnerName = selectedEditHandBidWinnerName
                    match.selectedPartnerName = selectedEditHandPartnerName
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].selectedTrump = selectedEditHandTrump
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText = winningBidEditHandText
                }
            } catch {
                print("ERROR adjusting score for meld in Pinochle Manager")
            }
        }
        setBidWinnerPlayerNumber()
        // Save the new meld values in the same way they are saved from the Hand Play view
        //        print("team1Score at end of saveEditedMeld: \(match.games[match.currentGameArrayIndex].team1Score)")
        //        print("team2Score at end of saveEditedMeld: \(match.games[match.currentGameArrayIndex].team2Score)")
        updateScoreWithMeld()
    }
    
    func saveEditedTrickPoints() {
        print("Starting saveEditedTrickPoints")
        /*
         This function is only called if the trick points have been saved previously on the Hand Play view - uses 'isChangedTrickPoints' flag
         1. Trick points previously added to score were already subtracted in saveEditedMeld function
         2. Set the realm trick points values to the edited values. The edited values start with the values from the Hand Play view so whether or not they are changed use the "edited" values
         4. Call the SaveTrickPoints() function (the same one used on the Hand Play view to save the trick points
         */
        
        if let realm = realm {
            do {
                try realm.write {
                    // Subtract trick points already added to score and set the realm values for the hand back to "" since they will be updated to the edited values
                    if match.selectedNumberOfPlayers == 3 {
//                        print("")
//                        print("player1TrickPointsText in saveEditedTrickPoints() of PinochleManager: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)")
//                        print("player1TrickPointsEditHandText in saveEditedTrickPoints() of PinochleManager: \(player1TrickPointsEditHandText)")
//                        print("player2TrickPointsText in saveEditedTrickPoints() of PinochleManager: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)")
//                        print("player2TrickPointsEditHandText in saveEditedTrickPoints() of PinochleManager: \(player2TrickPointsEditHandText)")
//                        print("player3TrickPointsText in saveEditedTrickPoints() of PinochleManager: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)")
//                        print("player3TrickPointsEditHandText in saveEditedTrickPoints() of PinochleManager: \(player3TrickPointsEditHandText)")
//                        print("")
                        
                        // Subtract the trick points already added to the current Game, if any was added
                        match.games[match.currentGameArrayIndex].player1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)!
                        match.games[match.currentGameArrayIndex].player2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)!
                        match.games[match.currentGameArrayIndex].player3Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!
                        
                        var player1Value = 0
                        var player2Value = 0
                        var player3Value = 0
                        if !player1TrickPointsEditHandText.isEmpty {
                            player1Value = Int(player1TrickPointsEditHandText)!
                        } else {
                            //player1TrickPointsText is empty so calculate its value and save it
                            player1Value = (Int(settings.pointsPerHand3Players)! - Int(player2TrickPointsEditHandText)! - Int(player3TrickPointsEditHandText)!)
                        }
                        if !player2TrickPointsEditHandText.isEmpty {
                            player2Value = Int(player2TrickPointsEditHandText)!
                        } else {
                            //player2TrickPoitsText is empty so calculate its value and save it
                            player2Value = (Int(settings.pointsPerHand3Players)! - Int(player1TrickPointsEditHandText)! - Int(player3TrickPointsEditHandText)!)
                        }
                        if !player3TrickPointsEditHandText.isEmpty {
                            player3Value = Int(player3TrickPointsEditHandText)!
                        } else {
                            player3Value = (Int(settings.pointsPerHand3Players)! - Int(player1TrickPointsEditHandText)! - Int(player2TrickPointsEditHandText)!)
                        }
                        // Update the realm vales for trick points with the validated edited values
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText = String(player1Value)
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText = String(player2Value)
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText = String(player3Value)
                        
                        // These will update display values on EditHandPlayText view
                        player1TrickPointsEditHandText = String(player1Value)
                        player2TrickPointsEditHandText = String(player2Value)
                        player3TrickPointsEditHandText = String(player3Value)
                        
                    } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
                        
                        // Subtract the trick points added to score, if any - if the bidWinnerTeamTrickPointsText and otherTeamTrickPointsText are not empty then
                        // trick points were already saved once before and need to be subtracted. I fthey are empty then only meld was saved so skip this
                        // Will add correct values when save tricks elsewhere
                        switch match.selectedHandBidWinnerName {
                        case match.player1Name :
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            }
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                            }
                        case match.player2Name :
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            }
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                            }
                        case match.player3Name :
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            }
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                            }
                        case match.player4Name :
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            }
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                            }
                        case match.player5Name :
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            }
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                            }
                        case match.player6Name :
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
                            }
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
                            }
                        default:
                            print("ERROR in default of switch statement in saveEditedMeld")
                        }
                        
                        // Update realm values for 4 & 6 players games trick points values to the "edited" values so the new trick points values can be saved.
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText = bidWinnerTeamTrickPointsEditHandText
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText = otherTeamTrickPointsEditHandText
                    } else if match.selectedNumberOfPlayers == 5 {
                        
                    }
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
        }
        // Save the new trick points values in the same way they are saved from the Hand Play view
        updateScoreWithTrickPoints()
    }
    
    
    func adjustScoreForEditedTrickPoints() {
        print("Starting adjustScoreForEditedTrickPoints()")
        /*
         This function is only called if the trick points have been saved previously on the Hand Play view - uses 'isChangedTrickPoints' flag
         1. Trick points previously added to score were already subtracted in saveEditedMeld function
         2. Set the realm trick points values to the edited values. The edited values start with the values from the Hand Play view so whether or not they are changed use the "edited" values
         4. Call the SaveTrickPoints() function (the same one used on the Hand Play view to save the trick points
         */
        
        if let realm = realm {
            do {
                try realm.write {
                    // Subtract trick points already added to score and set the realm values for the hand back to "" since they will be updated to the edited values
                    if match.selectedNumberOfPlayers == 3 {
//                        print("")
                        print("player1TrickPointsText at start of adjustScoreForEditedTrickPoints() of PinochleManager: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)")
//                        print("player1TrickPointsEditHandText in saveEditedTrickPoints() of PinochleManager: \(player1TrickPointsEditHandText)")
//                        print("player2TrickPointsText in saveEditedTrickPoints() of PinochleManager: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)")
//                        print("player2TrickPointsEditHandText in saveEditedTrickPoints() of PinochleManager: \(player2TrickPointsEditHandText)")
//                        print("player3TrickPointsText in saveEditedTrickPoints() of PinochleManager: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)")
//                        print("player3TrickPointsEditHandText in saveEditedTrickPoints() of PinochleManager: \(player3TrickPointsEditHandText)")
//                        print("")
                        print("player1Score before subtract adjustScoreForEditedTrickPoints in saveHandViewEditedTrickPoints() of PinochleManager: \(match.games[match.currentGameArrayIndex].player1Score)")
                        // Subtract the trick points already added to the current Game
                        match.games[match.currentGameArrayIndex].player1Score -= Int(match.savedPlayer1TrickPointsText)!
                        match.games[match.currentGameArrayIndex].player2Score -= Int(match.savedPlayer2TrickPointsText)!
                        match.games[match.currentGameArrayIndex].player3Score -= Int(match.savedPlayer3TrickPointsText)!
                        print("player1Score after subtract savedPlayer1TrickPointsText in adjustScoreForEditedTrickPoints() of PinochleManager: \(match.games[match.currentGameArrayIndex].player1Score)")
                        print("player1TrickPointsText after subtract in adjustScoreForEditedTrickPoints() of PinochleManager: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)")
                        var player1Value = 0
                        var player2Value = 0
                        var player3Value = 0
                        if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText.isEmpty {
                            player1Value = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)!
                        } else {
                            //player1TrickPointsText is empty so calculate its value and save it
                            player1Value = (Int(settings.pointsPerHand3Players)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!)
                        }
                        if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText.isEmpty {
                            player2Value = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)!
                        } else {
                            //player2TrickPoitsText is empty so calculate its value and save it
                            player2Value = (Int(settings.pointsPerHand3Players)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!)
                        }
                        if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText.isEmpty {
                            player3Value = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!
                        } else {
                            player3Value = (Int(settings.pointsPerHand3Players)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)!)
                        }
                        // Update the realm vales for trick points with the validated edited values
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText = String(player1Value)
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText = String(player2Value)
                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText = String(player3Value)

//                        // These will update display values on EditHandPlayText view
//                        player1TrickPointsEditHandText = String(player1Value)
//                        player2TrickPointsEditHandText = String(player2Value)
//                        player3TrickPointsEditHandText = String(player3Value)
                        
                    } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
                        
                        // Subtract the trick points added to score, if any - if the bidWinnerTeamTrickPointsText and otherTeamTrickPointsText are not empty then
                        // trick points were already saved once before and need to be subtracted. I fthey are empty then only meld was saved so skip this
                        // Will add correct values when save tricks elsewhere
                        print("savedBidWinnerTeamTrickPointsText at start of adjustScoreForEditedTrickPoints for 4 & 6 players: \(match.savedBidWinnerTeamTrickPointsText)")
                        print("savedOtherTeamTrickPointsText at start of adjustScoreForEditedTrickPoints for 4 & 6 players: \(match.savedOtherTeamTrickPointsText)")
                        switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
                        case 1 :
                            if !match.savedBidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            }
                            if !match.savedOtherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.savedOtherTeamTrickPointsText)!
                            }
                        case 2 :
                            if !match.savedBidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            }
                            if !match.savedOtherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.savedOtherTeamTrickPointsText)!
                            }
                        case 3 :
                            if !match.savedBidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            }
                            if !match.savedOtherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.savedOtherTeamTrickPointsText)!
                            }
                        case 4 :
                            if !match.savedBidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            }
                            if !match.savedOtherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.savedOtherTeamTrickPointsText)!
                            }
                        case 5 :
                            if !match.savedBidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            }
                            if !match.savedOtherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.savedOtherTeamTrickPointsText)!
                            }
                        case 6 :
                            if !match.savedBidWinnerTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            }
                            if !match.savedOtherTeamTrickPointsText.isEmpty {
                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.savedOtherTeamTrickPointsText)!
                            }
                        default:
                            print("ERROR in default of switch statement in adjustScoreForEditedTrickPoints")
                        }
                        
                        print("Team 1 score at end of adjustScoreForEditedTrickPoints: \(match.games[match.currentGameArrayIndex].team1Score)")
                        print("Team 2 score at end of adjustScoreForEditedTrickPoints: \(match.games[match.currentGameArrayIndex].team2Score)")

                    } else if match.selectedNumberOfPlayers == 5 {
                        print("savedBidWinnerTeamTrickPointsText at start of adjustScoreForEditedTrickPoints for 5 players: \(match.savedBidWinnerTeamTrickPointsText)")
                        print("savedOtherTeamTrickPointsText at start of adjustScoreForEditedTrickPoints for 5 players: \(match.savedOtherTeamTrickPointsText)")
                        var losingPlayersNumbersArray = [1, 2, 3, 4, 5]
                        // Subtract trick points to the Bid Winner's score
                        switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 1 }
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 2 }
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 3 }
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 4 }
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 5 }
                        default:
                            print("ERROR assigning trick points in adjustScoreForEditedTrickPoints() of PinochleManager")
                        }
                        // Subtract trick points to the Bid Winner's Partner's score
                        //print("partnerPlayerNumber: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber)")
                        switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 1 }
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 2 }
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 3 }
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 4 }
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.savedBidWinnerTeamTrickPointsText)!
                            losingPlayersNumbersArray = losingPlayersNumbersArray.filter { $0 != 5 }
                        default:
                            print("ERROR assigning trick points in adjustScoreForEditedTrickPoints() of PinochleManager")
                        }
                        // Subtract trick points to the losers scores (The other 3 players who are not the Bid Winner or the Partner)
                        // The losingPlayersNumbers array should now only contain the other 3 players
                        let firstBidLoserPlayerNumber = losingPlayersNumbersArray[0]
                        switch firstBidLoserPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.savedOtherTeamTrickPointsText)!
                        default:
                            print("ERROR assigning trick points in adjustScoreForEditedTrickPoints() of PinochleManager")
                        }
                        
                        let secondBidLoserPlayerNumber = losingPlayersNumbersArray[1]
                        switch secondBidLoserPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.savedOtherTeamTrickPointsText)!
                        default:
                            print("ERROR assigning trick points in adjustScoreForEditedTrickPoints() of PinochleManager")
                        }
                        
                        let thirdBidLoserPlayerNumber = losingPlayersNumbersArray[2]
                        switch thirdBidLoserPlayerNumber {
                        case 1:
                            match.games[match.currentGameArrayIndex].player1Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 2:
                            match.games[match.currentGameArrayIndex].player2Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 3:
                            match.games[match.currentGameArrayIndex].player3Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 4:
                            match.games[match.currentGameArrayIndex].player4Score -= Int(match.savedOtherTeamTrickPointsText)!
                        case 5:
                            match.games[match.currentGameArrayIndex].player5Score -= Int(match.savedOtherTeamTrickPointsText)!
                        default:
                            print("ERROR assigning trick points in adjustScoreForEditedTrickPoints() of PinochleManager")
                        }
                        
                        print("player1Score at end of 5 players in adustScoreForEditedTrickPoints: \(match.games[match.currentGameArrayIndex].player1Score)")
                        print("player2Score at end of 5 players in adustScoreForEditedTrickPoints: \(match.games[match.currentGameArrayIndex].player2Score)")
                        print("player3Score at end of 5 players in adustScoreForEditedTrickPoints: \(match.games[match.currentGameArrayIndex].player3Score)")
                        print("player4Score at end of 5 players in adustScoreForEditedTrickPoints: \(match.games[match.currentGameArrayIndex].player4Score)")
                        print("player5Score at end of 5 players in adustScoreForEditedTrickPoints: \(match.games[match.currentGameArrayIndex].player5Score)")
                    }
                }
            } catch {
                print("ERROR adjusting scores in adjustScoreForEditedTrickPoints of PinochleManager")
            }
        }
        
        // Save the new trick points values in the same way they are saved from the Hand Play view
        print("bidderWasSet at end of adjustScoreForEditedTrickPoints of PinochleManager: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet)")
        updateScoreWithTrickPoints()
    }
    
    func saveMeldValues() {
        if let realm = realm {
            do {
                try realm.write {
                    match.savedPlayer1MeldText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText
                    match.savedPlayer2MeldText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText
                    match.savedPlayer3MeldText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText
                    match.savedPlayer4MeldText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText
                    match.savedPlayer5MeldText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText
                    match.savedPlayer6MeldText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText
                }
            } catch {
                print("ERROR in saveMeldValues() in PinochleManager")
            }
        }
    }
    
    func saveTrickPointsValues() {
        if let realm = realm {
            do {
                try realm.write {
                    match.savedBidWinnerTeamTrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText
                    match.savedOtherTeamTrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText
                    match.savedPlayer1TrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText
                    match.savedPlayer2TrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText
                    match.savedPlayer3TrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText
                    match.savedBidderWasSet = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet
                }
            } catch {
                print("ERROR in saveTrickPointsValues() in PinochleManager")
            }
        }
    }
    
    func setHandPlayNewHandStatus() {
        
        if let realm = realm {
            do {
                try realm.write {
                    match.selectedHandBidWinnerName = "Select"
                    match.selectedPartnerName = "Select"
                    match.isDisabledEditMeldBtn = true
                    match.isDisabledEditTrickPointsBtn = true
                    match.isDisabledBidWinnerPicker = false
                    match.isDisabledPartnerPicker = false
                    match.isDisabledBidWinnerTrickPointsTextField = true
                    match.isDisabledMisDealBtn = true
                    match.isDisabledNextHandBtn = true
                    match.isDisabledOtherTeamTrickPointsTextField = true
                    match.isDisabledPlayer1MeldTextField = false
                    match.isDisabledPlayer2MeldTextField = false
                    match.isDisabledPlayer3MeldTextField = false
                    match.isDisabledPlayer4MeldTextField = false
                    match.isDisabledPlayer5MeldTextField = false
                    match.isDisabledPlayer6MeldTextField = false
                    match.isDisabledPlayer1TrickPointsTextField = true
                    match.isDisabledPlayer2TrickPointsTextField = true
                    match.isDisabledPlayer3TrickPointsTextField = true
                    match.isDisabledRenegeBtn = true
                    match.isDisabledSaveMeldBtn = false
                    match.isDisabledSaveTricksBtn = true
                    match.isDisabledWinningBidTextField = false
                    match.isDisabledTrumpPicker = false
                    match.showingPointsNeededToMakeBid = false
                    isMeldSaved = false
                    isTrickPointsSaved = false
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
        }
    }
    
    func setHandPlayNewMatchStatus() {
        
        if let realm = realm {
            do {
                try realm.write {
                    match.isDisabledEditMeldBtn = true
                    match.isDisabledEditTrickPointsBtn = true
                    match.isDisabledBidWinnerPicker = true
                    match.isDisabledBidWinnerTrickPointsTextField = true
                    match.isDisabledConcedeBtn = true
                    match.isDisabledMisDealBtn = true
                    match.isDisabledNextHandBtn = true
                    match.isDisabledOtherTeamTrickPointsTextField = true
                    match.isDisabledPartnerPicker = true
                    match.isDisabledPlayer1MeldTextField = true
                    match.isDisabledPlayer2MeldTextField = true
                    match.isDisabledPlayer3MeldTextField = true
                    match.isDisabledPlayer4MeldTextField = true
                    match.isDisabledPlayer5MeldTextField = true
                    match.isDisabledPlayer6MeldTextField = true
                    match.isDisabledPlayer1TrickPointsTextField = true
                    match.isDisabledPlayer2TrickPointsTextField = true
                    match.isDisabledPlayer3TrickPointsTextField = true
                    match.isDisabledRenegeBtn = true
                    match.isDisabledSaveTricksBtn = true
                    match.isDisabledWinningBidTextField = true
                    match.isDisabledTrumpPicker = true
                    match.showingPointsNeededToMakeBid = false
                    isMeldSaved = false
                    isTrickPointsSaved = false
                    
                    // Set all player meld and trick points to ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText = ""
                    // Set score values to 0
                    match.games[match.currentGameArrayIndex].player1Score = 0
                    match.games[match.currentGameArrayIndex].player2Score = 0
                    match.games[match.currentGameArrayIndex].player3Score = 0
                    match.games[match.currentGameArrayIndex].player4Score = 0
                    match.games[match.currentGameArrayIndex].player5Score = 0
                    match.games[match.currentGameArrayIndex].team1Score = 0
                    match.games[match.currentGameArrayIndex].team2Score = 0
                    // Set other Hand Play view values to default or other appropriate values
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].isMeldSaved = false
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText = ""
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].dealerName = "N/A"
                    match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].handNumber = 0
                    match.currentGameNumber = 0
                }
            } catch {
                print("ERROR adding new player in Pinochle Manager")
            }
        }
    }
    
    func shouldConcedeGame() -> Bool {
        /*
         1. Any tied scores
         2. Any score within scoreDifferential
         3. Set messages
         4. Show proper alert
         */
        
        var shouldConcede = true
        if match.selectedNumberOfPlayers == 3 || match.selectedNumberOfPlayers == 5 {
            var playerCount = 5
            if match.selectedNumberOfPlayers == 3 {
                playerCount = 3
            }
            // The playersWithScoreArray can contain duplicates, but only the first value will be reported a maxValue.
            // So, while the playersWithScoreArray will provide the maxValue, it does not address duplicates.
            let playersWithScoreArray = [
                PlayerWithScore(playerName: match.player1Name, playerScore: match.games[match.currentGameArrayIndex].player1Score),
                PlayerWithScore(playerName: match.player2Name, playerScore: match.games[match.currentGameArrayIndex].player2Score),
                PlayerWithScore(playerName: match.player3Name, playerScore: match.games[match.currentGameArrayIndex].player3Score),
                PlayerWithScore(playerName: match.player4Name, playerScore: match.games[match.currentGameArrayIndex].player4Score),
                PlayerWithScore(playerName: match.player5Name, playerScore: match.games[match.currentGameArrayIndex].player5Score),
                
            ]
            let maxValue = playersWithScoreArray.max(by: { (firstPlayer, secondPlayer) -> Bool in
                return firstPlayer.playerScore < secondPlayer.playerScore
            })
            let scoresSet: Set = [match.games[match.currentGameArrayIndex].player1Score, match.games[match.currentGameArrayIndex].player2Score, match.games[match.currentGameArrayIndex].player3Score, match.games[match.currentGameArrayIndex].player4Score, match.games[match.currentGameArrayIndex].player5Score]
            
            // Check if tied score
            if scoresSet.count < playerCount {
                // There is a duplicate. Set only holds unique values, so if there are 5 values in the Set there can be no duplicate.
                // But if the Set count is less than 5, there is at least 1 duplicate.
                for score in scoresSet {
                    if score == maxValue!.playerScore {
                        // Equals max value. At least 2 scores are tied so shouldn't concede
                        shouldConcede = false
                    }
                }
            }
            
            // Check if score too close to concede - the score difference is less than the score differenrtial in settings
            for player in playersWithScoreArray {
                if ((maxValue!.playerScore - player.playerScore) < Int(settings.scoreDifferentialMinimum)!) && (maxValue!.playerScore != player.playerScore) {
                    shouldConcede = false
                }
            }
        } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 6 {
            let team1ScoreAmount = match.games[match.currentGameArrayIndex].team1Score
            let team2ScoreAmount = match.games[match.currentGameArrayIndex].team2Score
            
            // Check if score is tied
            if team1ScoreAmount == team2ScoreAmount {
                // Score is tied so shouldn't concede
                shouldConcede = false
                //concedeMessageText = "The score is tied. Should not concede."
            }
            // Check if score too close to concede - the score difference is less than the score differenrtial in settings
            if abs(team1ScoreAmount - team2ScoreAmount) < Int(settings.scoreDifferentialMinimum)! {
                // Scores too close
                //  Warning for below code:  Modifying state during view update, this will cause undefined behavior.
                //concedeMessageText = "The score is close. Should not concede."
                shouldConcede = false
            }
        }
        return shouldConcede
    }
    
    func validateEditedMeldPointEntries() -> Bool {
        var isValid = false
        var meldPointsArray = [String]()
        // Convert winning bid to an array to use in validator
        if match.selectedNumberOfPlayers == 3 {
            meldPointsArray = [player1MeldEditHandText, player2MeldEditHandText, player3MeldEditHandText]
        } else if match.selectedNumberOfPlayers == 4 {
            meldPointsArray = [player1MeldEditHandText, player2MeldEditHandText, player3MeldEditHandText, player4MeldEditHandText]
        } else if match.selectedNumberOfPlayers == 5 {
            meldPointsArray = [player1MeldEditHandText, player2MeldEditHandText, player3MeldEditHandText, player4MeldEditHandText, player5MeldEditHandText]
        } else if match.selectedNumberOfPlayers == 6 {
            meldPointsArray = [player1MeldEditHandText, player2MeldEditHandText, player3MeldEditHandText, player4MeldEditHandText, player5MeldEditHandText, player6MeldEditHandText]
        }
        isValid = validateNumberTextFieldValues(numbersArrayParam: meldPointsArray)
        return isValid
    }
    
    //    func validateEditedTrickPointsValues() -> Bool {
    //        var isValid = true
    //        // Validate the trick points text entry values
    //        if match.selectedNumberOfPlayers == 3 {
    //            if !validateIndividualTricksTextFieldValue(textValueToValidate: player1TrickPointsEditHandText) || !validateIndividualTricksTextFieldValue(textValueToValidate: player2TrickPointsEditHandText) || !validateIndividualTricksTextFieldValue(textValueToValidate: player3TrickPointsEditHandText) {
    //                isValid = false
    //            }
    //            if  (Int(settings.pointsPerHand3Players)! != (Int(player1TrickPointsEditHandText)! + Int(player2TrickPointsEditHandText)! + Int(player3TrickPointsEditHandText)!)) {
    //                isValid = false
    //            }
    //
    //        } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 5  || match.selectedNumberOfPlayers == 6 {
    //            if !validateIndividualTricksTextFieldValue(textValueToValidate: bidWinnerTeamTrickPointsEditHandText) {
    //                isValid = false
    //                if validateIndividualTricksTextFieldValue(textValueToValidate: otherTeamTrickPointsEditHandText) {
    //                    isValid = true
    //                }
    //            }
    //        }
    //        if !validateEditedTrickValues() {
    //            isValid = false
    //        }
    //        return isValid
    //    }
    
    func validateEditedTrickPointsValues() -> Bool {
        //print("Starting validateTrickPointsValues()")
        
        /*
         First Check. Check if the bid winner trick points text field has a value. If so, validate it and if valid return true.
         Second Check. If bid winner field was empty, check if other team text field has a value. If so, validate it and if valid return true.
         Third Check. If bid winner field had value but was invalid, check if other team text field has a value. If so, validate it and if valid return true.
         Valid Number Check. Make sure is a number value and is between 0-999.
         Total Check. Make sure the total of both trick points text fields is valid if used entered values in both fields.
         
         User can leave either Bid Winner Team Trick Points field empty or Other Team Trick Points field empty and other value will be calculated;
         but one of the fields must have a value. If user enters values for both fields then just use the bid winner value.
         */
        
        print("Hand - bidWinnerTeamTrickPointsText at start of validateEditedTrickPointsValues: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)")
        print("Hand - otherTeamTrickPointsText at start of validateEditedTrickPointsValues: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)")
        
        var isValid = true
        if let realm = realm {
            do {
                try realm.write {
                    let bidWinnerTeamTrickPointsAsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText
                    let otherTeamTrickPointsAsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText
                    var emptyTrickPointsValuesCount = 0
                    
                    if match.selectedNumberOfPlayers == 3 {
                        if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText.isEmpty {
                            if !validateIndividualTricksTextFieldValue(textValueToValidate: match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText) {
                                isValid = false
                            }
                        } else {
                            emptyTrickPointsValuesCount += 1
                        }
                        if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText.isEmpty {
                            if !validateIndividualTricksTextFieldValue(textValueToValidate: match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText) {
                                isValid = false
                            }
                        } else {
                            emptyTrickPointsValuesCount += 1
                        }
                        if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText.isEmpty {
                            if !validateIndividualTricksTextFieldValue(textValueToValidate: match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText) {
                                isValid = false
                            }
                        } else {
                            emptyTrickPointsValuesCount += 1
                        }
                        // Only one player may have empty string value
                        if !(emptyTrickPointsValuesCount < 2) {
                            // At least 2 of the 3 players trick points values are empty so it is invalid
                            isValid = false
                        }
                        
                        if isValid {
                            // Passed validation so far so proceed to validate that total trick points entered do not exceed maximum
                            var player1Value = 0
                            var player2Value = 0
                            var player3Value = 0
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText.isEmpty {
                                player1Value = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)!
                            } else {
                                //player1TrickPointsText is empty so calculate its value and save it
                                player1Value = (Int(settings.pointsPerHand3Players)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!)
                            }
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText.isEmpty {
                                player2Value = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)!
                            } else {
                                //player2TrickPoitsText is empty so calculate its value and save it
                                player2Value = (Int(settings.pointsPerHand3Players)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!)
                            }
                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText.isEmpty {
                                player3Value = Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)!
                            } else {
                                player3Value = (Int(settings.pointsPerHand3Players)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)! - Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)!)
                            }
                            if  (Int(settings.pointsPerHand3Players)! != (player1Value + player2Value + player3Value)) {
                                isValid = false
                            }
                            //                            if isValid {
                            //                                // Update the realm vales for trick points with the validated edited values
                            //                                print("player1Value in validateEditedTrickPointsValues() of PinochleManager \(player1Value)")
                            //                                print("player2Value in validateEditedTrickPointsValues() of PinochleManager \(player2Value)")
                            //                                print("player3Value in validateEditedTrickPointsValues() of PinochleManager \(player3Value)")
                            //                                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText = String(player1Value)
                            //                                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText = String(player2Value)
                            //                                match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText = String(player3Value)
                            //                                player1TrickPointsEditHandText = String(player1Value)
                            //                                player2TrickPointsEditHandText = String(player2Value)
                            //                                player3TrickPointsEditHandText = String(player3Value)
                            //                            }
                        }
                        
                    } else if match.selectedNumberOfPlayers == 4 || match.selectedNumberOfPlayers == 5 || match.selectedNumberOfPlayers == 6 {
                        print("in validateTrickPointsValues for 4, 5 or 6 players")
                        // Start by arbitrarily checking if the bid winner trick points text field is empty. If not, then validate it. If it passes validation then done with checking and return true
                        if !bidWinnerTeamTrickPointsAsText.isEmpty {
                            print("bidWinnerTeamTrickPointsAsText in validateEditedTrickPoinsValues: \(bidWinnerTeamTrickPointsAsText)")
                            // Bid winner text field has a value so validate it
                            //print("bidWinnerTeamTrickPointsAsText is not empty in validateTrickPointsValues()")
                            if !validateTeamTricksTextFieldValues(valueToValidate: bidWinnerTeamTrickPointsAsText) {
                                isValid = false
                                print("isValid in bidWinerTEamTrickPointsAsText after validate after set to false: \(isValid)")
                            }
                            // Bid winner text field is empty so check the Other Team text field
                        }   // else
                        if !otherTeamTrickPointsAsText.isEmpty {
                            print("otherTeamTrickPointsAsText in validateEditedTrickPoinsValues: \(otherTeamTrickPointsAsText)")
                            //print("in else if in validateTrickPointsValues for 4, 5 or 6 players")
                            // Other team text field has a value so validate it
                            if !validateTeamTricksTextFieldValues(valueToValidate: otherTeamTrickPointsAsText) {
                                isValid = false
                            }
                            // Confirm both trick points text fields are empty and set validation to false
                        }   //  else
                        if bidWinnerTeamTrickPointsAsText.isEmpty && otherTeamTrickPointsAsText.isEmpty {
                            //print("in final else in validateTrickPointsValues for 4, 5 or 6 players")
                            print("Both values are empty so isValid will be set to false - before set: \(isValid)")
                            isValid = false
                        }
                    }
                }
            } catch {
                print("ERROR validateEditedTrickValues() in Pinochle Manager")
            }
        }
        return isValid
    }
    
}
