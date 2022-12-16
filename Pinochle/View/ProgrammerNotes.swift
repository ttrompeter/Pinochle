//
//  ProgrammerNotes.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/13/22.
//

import Foundation


// Programmer Notes For PinochleScorerUI App

// Fix Wheel Picker style overlap. add .compositingGRoup view modifier to HStack that contains view
//  .compositingGroup()


// The following are code snippets and functions from other areas of the App that are not bieng used
// They are kept for reference and possible future use
// ***************************************************************************************************
//

/*
 onChage for Picker:
 
 Picker(selection: $manager.selectedEditHandBidWinnerName,
        label: Text("Bid Winner"),
        content:  {
     Text("Select").tag("Select")
     ForEach(manager.match.matchPlayerNames, id: \.self) { name in
         Text(name).tag(name)
     }
 })
 .pickerStyle(MenuPickerStyle())
 .fixedSize()
 .onChange(of: manager.selectedEditHandBidWinnerName) { tag in
     print("Bid Winner name in onChange of Bid Winner picker: \(tag)")
 }
 .disabled(isDisabledBidWinnerPicker)

 
 */

//
// ***************************************************************************************************
//

/*
 
 From adjustScoreForEditedTrickPoints()
 
 //                        switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
 //                        case 1 :
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
 //                            }
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
 //                            }
 //                        case 2 :
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
 //                            }
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
 //                            }
 //                        case 3 :
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
 //                            }
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
 //                            }
 //                        case 4 :
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
 //                            }
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
 //                            }
 //                        case 5 :
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
 //                            }
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
 //                            }
 //                        case 6 :
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team2Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)!
 //                            }
 //                            if !match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText.isEmpty {
 //                                match.games[match.currentGameArrayIndex].team1Score -= Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)!
 //                            }
 //                        default:
 //                            print("ERROR in default of switch statement in saveEditedMeld")
 //                        }
                         
                         // Update realm values for 4 & 6 players games trick points values to the "edited" values so the new trick points values can be saved.
 //                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText = bidWinnerTeamTrickPointsEditHandText
 //                        match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText = otherTeamTrickPointsEditHandText

 
 */

//
// ***************************************************************************************************
//

/*
  From updateScoreForTrickPoints for 4 & 6 players
 
 //                        if match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
 //                            switch match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber {
 //                            case 1:
 //                                print("Team 1 score case 1 after being set at start:    \(match.games[match.currentGameArrayIndex].team1Score)")
 //                                print("winningBidText case 1:  \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)")
 //                                print("Team 1 meld case 1: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)")
 //                                print("bidWinnerTeamTrickPoints case 1: \(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)")
 //                                // Add back bid amount that was subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
 //                                // Add back the meld points that were subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team1Score += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!)
 //                                // Add back the original saved trick points that were subtracted during bid set - not the new trick points
 //                                match.games[match.currentGameArrayIndex].team1Score += Int(match.savedBidWinnerTeamTrickPointsText)!
 //                                print("savedBidWinnerTeamTrickPointsText: \(match.savedBidWinnerTeamTrickPointsText)")
 //                                print("Team 1 score after adjustment for being set: \(match.games[match.currentGameArrayIndex].team1Score)")
 //                            case 2:
 //                                // Add back bid amount that was subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
 //                                // Add back the meld points that were subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team2Score += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!)
 //                                // Add back the original saved trick points that were subtracted during bid set - not the new trick points
 //                                match.games[match.currentGameArrayIndex].team2Score += Int(match.savedBidWinnerTeamTrickPointsText)!
 //                            case 3:
 //                                // Add back bid amount that was subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
 //                                // Add back the meld points that were subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team1Score += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!)
 //                                // Add back the original saved trick points that were subtracted during bid set - not the new trick points
 //                                match.games[match.currentGameArrayIndex].team1Score += Int(match.savedBidWinnerTeamTrickPointsText)!
 //                            case 4:
 //                                // Add back bid amount that was subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
 //                                // Add back the meld points that were subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team2Score += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!)
 //                                // Add back the original saved trick points that were subtracted during bid set - not the new trick points
 //                                match.games[match.currentGameArrayIndex].team2Score += Int(match.savedBidWinnerTeamTrickPointsText)!
 //                            case 5:
 //                                // Add back bid amount that was subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team1Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
 //                                // Add back the meld points that were subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team1Score += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!)
 //                                // Add back the original saved trick points that were subtracted during bid set - not the new trick points
 //                                match.games[match.currentGameArrayIndex].team1Score += Int(match.savedBidWinnerTeamTrickPointsText)!
 //                            case 6:
 //                                // Add back bid amount that was subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team2Score += Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)!
 //                                // Add back the meld points that were subtracted during bid set process
 //                                match.games[match.currentGameArrayIndex].team2Score += ( Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)! + Int(match.games[match.currentGameArrayIndex].hands[match.games[match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)!)
 //                                // Add back the original saved trick points that were subtracted during bid set - not the new trick points
 //                                match.games[match.currentGameArrayIndex].team2Score += Int(match.savedBidWinnerTeamTrickPointsText)!
 //                            default:
 //                                print("ERROR in switch statement of 3 players game in updateScoreWithTrickPoints of PinochleManager")
 //                            }
 //                        }
 
 */

//
// ***************************************************************************************************
//

/*
 

 
 */

//
// ***************************************************************************************************
//
//

/*
 

 
 */

//
// ***************************************************************************************************
//

/*
 

 
 */

//

// ***************************************************************************************************
//

/*
 

 
 */

//
// ***************************************************************************************************
//

/*
 

 
 */

//

// ***************************************************************************************************
//

/*
 
 
 
 */

//
// ***************************************************************************************************
