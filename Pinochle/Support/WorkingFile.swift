//
//  WordingFile.swift
//  Pinochle
//
//  Created by Tom Trompeter on 12/21/22.
//

import SwiftUI

//Button("Save Tricks") {
//
//    @EnvironmentObject var manager: PinochleManager
//
//    if manager.isTrickPointsSaved {
//       // Edited trick points being saved
//        if manager.isEditTrickPointsButtonTapped {
//            print("\n     > > >     isEditTrickPointsButtonTapped")
//            if manager.validateEditedTrickPointsValues() {
//                manager.adjustScoreForEditedTrickPoints()
//                manager.saveTrickPointsValues()
//            } else {
//                //showingInvalidTrickPointsPopover = true
//            }
//        }
//    } else {
//        // First time trick points for the hand are being saved
//        if manager.validateTrickPointsValues() {
//            manager.updateScoreWithTrickPoints()
//            manager.saveTrickPointsValues()
//
//        } else {
//            //showingInvalidTrickPointsPopover = true
//        }
//    }
//}



//func saveTrickPointsValues() {
//    if let realm = realm {
//        do {
//            try realm.write {
//                match.savedBidWinnerTeamTrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText
//                match.savedOtherTeamTrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText
//                match.savedPlayer1TrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText
//                match.savedPlayer2TrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText
//                match.savedPlayer3TrickPointsText = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText
//                match.savedBidderWasSet = match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet
//            }
//        } catch {
//            print("ERROR in saveTrickPointsValues() in PinochleManager")
//        }
//    }
//}
