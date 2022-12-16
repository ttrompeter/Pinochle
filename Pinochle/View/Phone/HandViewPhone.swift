//
//  HandViewPhone.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/29/22.
//

import RealmSwift
import SwiftUI

struct HandViewPhone: View {
    
    @EnvironmentObject var manager: PinochleManager
    @ObservedRealmObject var match: Match
    
    @State var concedeGameWinnerText = "Unknown"
    @State var showingEditHandPlay = false
    @State var viewRefresher = false
    
    // Popovers
    @State var showingBidderWasSetPopover = false
    @State var showingConcedeGamePopover = false
    @State var showingEndMatchPopover = false
    @State var showingGameOverPopover = false
    @State var showingInvalidMeldPopover = false
    @State var showingInvalidTrickPointsPopover = false
    @State var showingInvalidWinningBidPopover = false
    @State var showingLockedButton = false
    @State var showingMatchOverPopover = false
    @State var showingMisdealPopover = false
    @State var showingRenegePopover = false
    @State var showingUnlockedButton = false
    
    // Action Sheets
    @State var showingScratchPadSheet = false
    @State var showingMatchSetupSheetLocal = false
    
    var body: some View {
        
        VStack {
            HStack (alignment: .top) {
                Image("oceanapinochle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.racinggreen), lineWidth: 2))
                Spacer()
                VStack {
                    Text("Match Score: ")
                    if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 6 {
                        HStack (spacing: 10) {
                            Text("Team 1: \(manager.match.team1GamesWon)")
                            Text(" | ")
                            Text("Team 2: \(manager.match.team2GamesWon)")
                        }
                    }
                    if manager.match.selectedNumberOfPlayers == 3 || manager.match.selectedNumberOfPlayers == 5 {
                        HStack (spacing: 10) {
                            Text("\(manager.match.player1Name): \(manager.match.player1GamesWon)")
                            Text("\(manager.match.player2Name): \(manager.match.player2GamesWon)")
                            Text("\(manager.match.player3Name): \(manager.match.player3GamesWon)")
                        }
                    }
                    if manager.match.selectedNumberOfPlayers == 5 {
                        HStack (spacing: 10) {
                            Text("\(manager.match.player4Name): \(manager.match.player4GamesWon)")
                            Text("\(manager.match.player5Name): \(manager.match.player5GamesWon)")
                        }
                    }
                }
                .padding(5)
                .font(.caption2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.racinggreen), lineWidth:0.5)
                )
                
                
                Spacer()
                Image("pinochle72")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.racinggreen), lineWidth: 2))
            }
            //.padding(.bottom, 5)
            .padding(.horizontal, 5)
            
            VStack  {
                Text("Current Game Score")
                    .foregroundColor(Color(.brown))
                if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 6 {
                    HStack (spacing: 10) {
                        HStack {
                            Text("Team 1: ")
                                .foregroundColor(Color(.brown))
                            Text("\(manager.match.games[manager.match.currentGameArrayIndex].team1Score)")
                        }
                        Text(" | ")
                        HStack {
                            Text("Team 2: ")
                                .foregroundColor(Color(.brown))
                            Text("\(manager.match.games[manager.match.currentGameArrayIndex].team2Score)")
                        }
                    }
                }
                if manager.match.selectedNumberOfPlayers == 3 {
                    HStack (spacing: 10) {
                        HStack {
                            Text("\(manager.match.player1Name): ")
                                .foregroundColor(Color(.brown))
                            Text("\(manager.match.games[manager.match.currentGameArrayIndex].player1Score)")
                        }
                        HStack {
                            Text("\(manager.match.player2Name): ")
                                .foregroundColor(Color(.brown))
                            Text("\(manager.match.games[manager.match.currentGameArrayIndex].player2Score)")
                        }
                    }
                    HStack (spacing: 10) {
                        Text("\(manager.match.player3Name): ")
                            .foregroundColor(Color(.brown))
                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player3Score)")
                    }
                }
                if manager.match.selectedNumberOfPlayers == 5 {
                    HStack (spacing: 10) {
                        HStack {
                            Text("\(manager.match.player1Name): ")
                                .foregroundColor(Color(.brown))
                            Text("\(manager.match.games[manager.match.currentGameArrayIndex].player1Score)")
                        }
                        HStack {
                            Text("\(manager.match.player2Name): ")
                                .foregroundColor(Color(.brown))
                            Text("\(manager.match.games[manager.match.currentGameArrayIndex].player2Score)")
                        }
                        HStack {
                            Text("\(manager.match.player3Name): ")
                                .foregroundColor(Color(.brown))
                            Text("\(manager.match.games[manager.match.currentGameArrayIndex].player3Score)")
                        }
                    }
                    
                    HStack (spacing: 10) {
                        HStack (spacing: 10) {
                            Text("\(manager.match.player4Name): ")
                                .foregroundColor(Color(.brown))
                            Text("\(manager.match.games[manager.match.currentGameArrayIndex].player4Score)")
                        }
                        HStack {
                            Text("\(manager.match.player5Name): ")
                                .foregroundColor(Color(.brown))
                            Text("\(manager.match.games[manager.match.currentGameArrayIndex].player5Score)")
                        }
                    }
                }
            }
            .padding(5)
            .font(.body)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.brown), lineWidth: 1)
            )
            .padding(5)
            
            if manager.match.showingPointsNeededToMakeBid {
                HStack {
                    Text("Points Needed To Make Bid: ")
                        .italic()
                    Text("\(manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].pointsNeededToMakeBid)")
                        .italic()
                }
                .font(.footnote)
                .foregroundColor(Color(.racinggreen))
            } else {
                // Placeholder to maintain layout when points needed to win is not shown
                Text("  ")
                    .font(.footnote)
            }
            
            ZStack {
                VStack {
                    // Bidding Section
                    HStack (alignment: .top, spacing: 0) {
                        VStack (alignment: .leading, spacing: 0) {
                            HStack {
                                HStack {
                                    Text("Dealer: ")
                                    Text("\(manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerName)")
                                }
                                Spacer()
                                Text("Game \(manager.match.currentGameNumber)")
                                Text("Hand \(manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].handNumber)")
                            }
                            HStack (alignment: .center) {
                                Text("Bid Winner: ")
                                // TODO: - selected bid winner should be in Hand and not in Match
                                // $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].selectedBidWinnerName
                                Picker(selection: $manager.match.selectedHandBidWinnerName,
                                       label: Text("Bid Winner"),
                                       content:  {
                                    Text("Select").tag("Select")
                                    ForEach(manager.match.matchPlayerNames, id: \.self) { name in
                                        Text(name).tag(name)
                                    }
                                })
                                .pickerStyle(MenuPickerStyle())
                                .fixedSize()
                                .onChange(of: manager.match.selectedHandBidWinnerName) { tag in
                                    manager.setBidWinnerPlayerNumber()
                                    print("Bid Winner Player Number in Picker after onChange: \(manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerPlayerNumber)")
                                }
                                .disabled(manager.match.isDisabledBidWinnerPicker || !manager.match.isMatchSetupCompleted)
                                
                                Spacer()
                            }
                            HStack {
                                if manager.match.selectedNumberOfPlayers == 5 {
                                    HStack {
                                        Text("Partner:       ")
                                        // TODO: - selected partner should be in Hand and not in Match
                                        // $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].selectedPartnerName
                                        Picker(selection: $manager.match.selectedPartnerName,
                                               label: Text("Partner"),
                                               content:  {
                                            Text("Select").tag("Select")
                                            ForEach(manager.match.matchPlayerNames, id: \.self) { name in
                                                Text(name).tag(name)
                                            }
                                        })
                                        .pickerStyle(MenuPickerStyle())
                                        .fixedSize()
                                        .onChange(of: manager.match.selectedPartnerName) { tag in
                                            manager.setPartnerPlayerNumber()
                                            print("Partner Player Number in Picker after onChange: \(manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].partnerPlayerNumber)")
                                        }
                                        .disabled(manager.match.isDisabledPartnerPicker  || !manager.match.isMatchSetupCompleted)

                                        Spacer()
                                    }
                                }
                            }
                            HStack {
                                HStack {
                                    Text("Winning Bid: ")
                                    TextEntryFieldPhone(placeholder: "Bid", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)
                                        .disabled(manager.match.isDisabledWinningBidTextField)
                                }
                                Spacer()
                                HStack {
                                    Text("Trump ")
                                    Picker(selection: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].selectedTrump,
                                           label: Text("Trump"),
                                           content:  {
                                        Image(systemName: "suit.spade").tag(1)
                                        Image(systemName: "suit.heart").tag(2)
                                        Image(systemName: "suit.diamond").tag(3)
                                        Image(systemName: "suit.club").tag(4)
                                    })
                                    .pickerStyle(SegmentedPickerStyle())
                                    //.fixedSize()
                                    .disabled(manager.match.isDisabledTrumpPicker  || !manager.match.isMatchSetupCompleted)
                                    .onAppear {
                                        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(.tan))
                                        UISegmentedControl.appearance().backgroundColor = UIColor(Color(.winter))
                                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(.racinggreen))], for: .selected)
                                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(.racinggreen))], for: .normal)
                                    }
                                }
                                .frame(width:180, height: 25)
                            }
                            .popover(isPresented: $showingInvalidWinningBidPopover) {
                                InvalidWinningBidPopover()
                                    .presentationDetents([.fraction(0.40)])
                            }
                        }
                        
                    }  // End Bidding Section HStack
                    .padding(10)
                    .font(.callout)
                    .foregroundColor(Color(.racinggreen))
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    .padding(.horizontal, 10)
                    
                    
                    // Meld Points
                    VStack (spacing: 0) {
                        
                        HStack {
                            Text("Meld Points")
                                .font(.title2)
                                .padding(.bottom, 10)
                            if showingLockedButton {
                                Button {
                                    showingLockedButton = false
                                    showingUnlockedButton = true
                                    manager.unlockMeld()
                                    manager.forceViewUpdate = Int.random(in: 222..<88888)
                                } label: {
                                    Image(systemName: "lock")
                                        .resizable()
                                        .frame(width: 15, height: 20)
                                        .foregroundColor(Color(.tan))
                                }
                            } else if showingUnlockedButton {
                                Button {
                                    manager.unlockMeld()
                                    showingUnlockedButton = false
                                    showingLockedButton = true
                                    manager.lockMeld()
                                    manager.forceViewUpdate = Int.random(in: 333..<77777)
                                } label: {
                                    Image(systemName: "lock.open")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color(.tan))
                                }
                            }
                        }
                        
                        // Meld Points HStack
                        HStack {
                            Spacer()
                            // Start of 3 Players Meld Section
                            if manager.match.selectedNumberOfPlayers == 3 {
                                VStack (spacing: 10) {
                                        HStack {
                                            Spacer()
                                            HStack {
                                                Text("\(manager.match.player1Name):")
                                                    .frame(width:90, height: 20)
                                                    .lineLimit(1)
                                                TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)
                                                    .disabled(manager.match.isDisabledPlayer1MeldTextField)
                                            }
                                            Spacer()
                                            HStack {
                                                Text("\(manager.match.player2Name):")
                                                    .frame(width:90, height: 20)
                                                    .lineLimit(1)
                                                TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)
                                                    .disabled(manager.match.isDisabledPlayer2MeldTextField)
                                            }
                                            Spacer()
                                        }
                                        HStack {
                                            Text("\(manager.match.player3Name):")
                                                .frame(width:90, height: 20)
                                                .lineLimit(1)
                                            TextEntryFieldPhone(placeholder: "- -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)
                                                .disabled(manager.match.isDisabledPlayer3MeldTextField)
                                        }
                                    }
                            }  // End of if 3 Players Meld Section
                            
                            // Start of 4 & 6 Player Meld Section
                            if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 6 {
                                //Spacer()
                                    VStack {
                                        Text(Constants.TEAM_1)
                                            .font(.callout)
                                        HStack (alignment: .top, spacing: 0) {
                                            VStack (alignment: .leading) {
                                                Text("\(manager.match.player1Name)")
                                                    .frame(width:90, height: 20)
                                                    .lineLimit(1)
                                                Text("\(manager.match.player3Name)")
                                                    .frame(width:90, height: 20)
                                                    .lineLimit(1)
                                                if manager.match.selectedNumberOfPlayers == 6 {
                                                    Text("\(manager.match.player5Name)")
                                                        .frame(width:90, height: 20)
                                                        .lineLimit(1)
                                                }
                                            }
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 1)
//                                                    .stroke(Color(.orange), lineWidth: 1)
//                                            )
                                            Text("   ")
                                            VStack {
                                                TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)
                                                    .disabled(manager.match.isDisabledPlayer1MeldTextField)
                                                
                                                TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)
                                                    .disabled(manager.match.isDisabledPlayer3MeldTextField)
                                                if manager.match.selectedNumberOfPlayers == 6 {
                                                    TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)
                                                        .disabled(manager.match.isDisabledPlayer5MeldTextField)
                                                }
                                            }
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 1)
//                                                    .stroke(Color(.blue), lineWidth: 1)
//                                            )
                                        }
                                        .padding(.horizontal, 6)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 16)
//                                                .stroke(Color(.red), lineWidth: 1)
//                                        )
                                    }
                                    .padding(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(.racinggreen), lineWidth: 1)
                                    )
                                    //Spacer()
                                    VStack {
                                        Text(Constants.TEAM_2)
                                            .font(.callout)
                                        VStack (alignment: .leading, spacing: 2) {
                                            HStack (alignment: .top, spacing: 0) {
                                                VStack (alignment: .leading) {
                                                    Text("\(manager.match.player2Name)")
                                                        .frame(width:90, height: 20)
                                                        .lineLimit(1)
                                                    Text("\(manager.match.player4Name)")
                                                        .frame(width:90, height: 20)
                                                        .lineLimit(1)
                                                    if manager.match.selectedNumberOfPlayers == 6 {
                                                        Text("\(manager.match.player6Name)")
                                                            .frame(width:90, height: 20)
                                                            .lineLimit(1)
                                                    }
                                                }
                                                Text("   ")
                                                VStack (alignment: .trailing) {
                                                    TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)
                                                        .disabled(manager.match.isDisabledPlayer1MeldTextField)
                                                    
                                                    TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)
                                                        .disabled(manager.match.isDisabledPlayer4MeldTextField)
                                                    if manager.match.selectedNumberOfPlayers == 6 {
                                                        TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)
                                                            .disabled(manager.match.isDisabledPlayer6MeldTextField)
                                                    }
                                                }
                                            }
                                            //.padding(.horizontal, 10)
                                        }
                                    }
                                    .padding(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(.racinggreen), lineWidth: 1)
                                    )
                                //Spacer()
                            }  // End of if 4 & 6 Player Meld Section
                            
                            // Start of 5 Players Meld Section
                            if manager.match.selectedNumberOfPlayers == 5 {
                                VStack (spacing: 0) {
                                    HStack {
                                        //Spacer()
                                        VStack (alignment: .leading) {
                                            HStack (alignment: .top) {
                                                VStack (alignment: .leading) {
                                                    Text("\(manager.match.player1Name):")
                                                        .frame(width:90, height: 20)
                                                        .lineLimit(1)
                                                    Text("\(manager.match.player3Name):")
                                                        .frame(width:90, height: 20)
                                                        .lineLimit(1)
                                                }
                                                Text("   ")
                                                VStack (alignment: .trailing) {
                                                    TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)
                                                        .disabled(manager.match.isDisabledPlayer1MeldTextField)
                                                    
                                                    TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)
                                                        .disabled(manager.match.isDisabledPlayer3MeldTextField)
                                                }
                                            }
                                            .padding(.horizontal, 6)
                                        }
                                        VStack (alignment: .leading) {
                                            HStack (alignment: .top) {
                                                VStack (alignment: .leading) {
                                                    Text("\(manager.match.player2Name):")
                                                        .frame(width:90, height: 20)
                                                        .lineLimit(1)
                                                    Text("\(manager.match.player4Name):")
                                                        .frame(width:90, height: 20)
                                                        .lineLimit(1)
                                                }
                                                Text("   ")
                                                VStack (alignment: .trailing) {
                                                    TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)
                                                        .disabled(manager.match.isDisabledPlayer2MeldTextField)
                                                    
                                                    TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)
                                                        .disabled(manager.match.isDisabledPlayer4MeldTextField)
                                                }
                                            }
                                            .padding(.horizontal, 6)
                                        }
                                        //Spacer()
                                    }
                                    HStack (alignment: .top) {
                                        Text("\(manager.match.player5Name):")
                                            .frame(width:90, height: 20)
                                            .lineLimit(1)
                                        TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)
                                            .disabled(manager.match.isDisabledPlayer5MeldTextField)
                                    }
                                    .padding(.top, 8)
                                }
                                .font(.callout)
                                }  // End of if 5 Players Meld Section
                            Spacer()
                        } // End Meld Points HStack
                        
                        HStack (alignment: .center) {
                            Button("Edit") {
                                manager.unlockMeld()
                                $manager.match.isDisabledEditMeldBtn.wrappedValue = true
                            }
                            .buttonStyle(PhoneButtonStyle())
                            .disabled(manager.match.isDisabledEditMeldBtn || !manager.match.isMatchSetupCompleted)
                            
                            Button("Save Meld") {
                                if manager.validateWinningBidEntry(winningBidEntry: manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].winningBidText) {
                                    
                                    manager.setBidWinnerPlayerNumber()
                                    if manager.isMeldSaved {
                                        print("Starting Save Meld edited values in Save Meld button of HandView")
                                        // Save edited meld values
                                        if  manager.validateMeldPointEntries() {
                                            manager.saveHandViewEditedMeld()
                                            manager.saveMeldValues()
                                            manager.lockMeld()
                                            $manager.match.isDisabledEditMeldBtn.wrappedValue = true
                                            $manager.match.isDisabledEditTrickPointsBtn.wrappedValue = false
                                            $manager.match.showingPointsNeededToMakeBid.wrappedValue = true
                                            $manager.isMeldSaved.wrappedValue = true
                                            $manager.match.isDisabledMisDealBtn.wrappedValue = true
                                            $manager.match.isDisabledRenegeBtn.wrappedValue = true
                                            $manager.match.isDisabledSaveTricksBtn.wrappedValue = false
                                            $manager.match.showingNewGameButton.wrappedValue = false
                                            $manager.match.showingNewMatchButton.wrappedValue = false
                                            showingLockedButton = false
                                            showingUnlockedButton = false
                                        } else {
                                            print("Meld not validated validateEditedMeldPointEntries in Save Meld button of HandView: \(manager.validateEditedMeldPointEntries())")
                                        }
                                    } else {
                                        // First time meld is saved
                                        if  manager.validateMeldPointEntries() {
                                            manager.saveMeldValues()
                                            manager.updateScoreWithMeld()
                                            manager.lockMeld()
                                            manager.unlockTrickPoints()
                                            $manager.match.isDisabledEditMeldBtn.wrappedValue = false
                                            $manager.match.showingPointsNeededToMakeBid.wrappedValue = true
                                            $manager.isMeldSaved.wrappedValue = true
                                            $manager.match.isDisabledMisDealBtn.wrappedValue = false
                                            $manager.match.isDisabledRenegeBtn.wrappedValue = false
                                            $manager.match.isDisabledSaveTricksBtn.wrappedValue = false
                                            $manager.match.showingNewGameButton.wrappedValue = false
                                            $manager.match.showingNewMatchButton.wrappedValue = false
                                        } else {
                                            showingInvalidMeldPopover = true
                                        }
                                    }
                                } else {
                                    showingInvalidWinningBidPopover = true
                                }
                            }
                            .buttonStyle(SmallButtonStyle())
                            .disabled(manager.match.isDisabledSaveMeldBtn || !manager.match.isMatchSetupCompleted)
                            .popover(isPresented: $showingInvalidMeldPopover) {
                                InvalidMeldPopover()
                            }
                            
                            Button("Scratch") {
                                showingScratchPadSheet.toggle()
                            }
                            .buttonStyle(PhoneButtonStyle())
                            .disabled(manager.match.isDisabledScratchPadBtn)
                            .sheet(isPresented: $showingScratchPadSheet) {
                                ScratchPadSheetPhone()
                                    .withDismissButton()
                            }
                            
//                            Button("Edit") {
//                                showingEditHandPlay.toggle()
//                            }
//                            .buttonStyle(PhoneButtonStyle())
//                            .disabled(manager.match.isDisabledSaveTricksBtn || !manager.match.isMatchSetupCompleted)
//                            .sheet(isPresented: $showingEditHandPlay) {
//                                EditHandPlaySheetPhone()
//                                    .withDismissButton()
//                                    .presentationDetents([.large])
//                                    //.presentationDetents([.fraction(0.8), .height(200)])
//                            }
//                            Button("Save Meld") {
//                                //print("winningBidText at start of Save Meld button: \(manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)")
//                                if manager.validateWinningBidEntry(winningBidEntry: manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].winningBidText) {
//                                    manager.setBidWinnerPlayerNumber()
//                                    if  manager.validateMeldPointEntries() {
//                                        manager.updateScoreWithMeld()
//                                        $manager.match.isDisabledBidWinnerPicker.wrappedValue = true
//                                        $manager.match.isDisabledBidWinnerTrickPointsTextField.wrappedValue = false
//                                        $manager.match.isDisabledMisDealBtn.wrappedValue = false
//                                        $manager.match.isDisabledOtherTeamTrickPointsTextField.wrappedValue = false
//                                        $manager.match.isDisabledPartnerPicker.wrappedValue = true
//                                        $manager.match.isDisabledPlayer1MeldTextField.wrappedValue = true
//                                        $manager.match.isDisabledPlayer2MeldTextField.wrappedValue = true
//                                        $manager.match.isDisabledPlayer3MeldTextField.wrappedValue = true
//                                        $manager.match.isDisabledPlayer4MeldTextField.wrappedValue = true
//                                        $manager.match.isDisabledPlayer5MeldTextField.wrappedValue = true
//                                        $manager.match.isDisabledPlayer6MeldTextField.wrappedValue = true
//                                        $manager.match.isDisabledPlayer1TrickPointsTextField.wrappedValue = false
//                                        $manager.match.isDisabledPlayer2TrickPointsTextField.wrappedValue = false
//                                        $manager.match.isDisabledPlayer3TrickPointsTextField.wrappedValue = false
//                                        $manager.match.isDisabledRenegeBtn.wrappedValue = false
//                                        $manager.match.isDisabledSaveMeldBtn.wrappedValue = true
//                                        $manager.match.isDisabledSaveTricksBtn.wrappedValue = false
//                                        $manager.match.isDisabledTrumpPicker.wrappedValue = true
//                                        $manager.match.isDisabledWinningBidTextField.wrappedValue = true
//                                        $manager.match.showingPointsNeededToMakeBid.wrappedValue = true
//                                        $manager.match.showingNewGameButton.wrappedValue = false
//                                        $manager.match.showingNewMatchButton.wrappedValue = false
//                                    } else {
//                                        showingInvalidMeldPopover = true
//                                    }
//                                } else {
//                                    showingInvalidWinningBidPopover = true
//                                }
//                            }
//                            .buttonStyle(SmallButtonStyle())
//                            .disabled(manager.match.isDisabledSaveMeldBtn || !manager.match.isMatchSetupCompleted)
//                            .popover(isPresented: $showingInvalidMeldPopover) {
//                                InvalidMeldPopover()
//                            }
//
//                            Button("Scratch") {
//                                showingScratchPadSheet.toggle()
//                            }
//                            .buttonStyle(PhoneButtonStyle())
//                            .disabled(manager.match.isDisabledScratchPadBtn)
//                            .sheet(isPresented: $showingScratchPadSheet) {
//                                ScratchPadSheetPhone()
//                                    .withDismissButton()
//                            }
                        }
                        .padding(.top, 10)
                    }  // End Meld Points VStack
                    .padding(10)
                    .font(.callout)
                    .foregroundColor(Color(.racinggreen))
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    .padding(.horizontal, 10)
                    
                    // Trick Points Section
                    VStack (spacing: 0) {
                        Text("Trick Points")
                            .font(.title2)
                            .padding(.bottom, 10)
                        // Start of 3 Players Trick Points Section
                        if manager.match.selectedNumberOfPlayers == 3 {
                            VStack (spacing: 10) {
                                    HStack {
                                        Spacer()
                                        HStack {
                                            Text("\(manager.match.player1Name):")
                                                .frame(width:90, height: 15)
                                                .lineLimit(1)
                                            TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)
                                                .disabled(manager.match.isDisabledPlayer1TrickPointsTextField)
                                        }
                                        Spacer()
                                        HStack {
                                            Text("\(manager.match.player2Name):")
                                                .frame(width:90, height: 15)
                                                .lineLimit(1)
                                            TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)
                                                .disabled(manager.match.isDisabledPlayer1TrickPointsTextField)
                                        }
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(manager.match.player3Name):")
                                            .frame(width:90, height: 15)
                                            .lineLimit(1)
                                        TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)
                                            .disabled(manager.match.isDisabledPlayer1TrickPointsTextField)
                                    }
                                }
                        }  // End of 3 Players Trick Points Section
                        
                
                        // Start of 4, 5 & 6 Player Trick Points
                        if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 5 || manager.match.selectedNumberOfPlayers == 6 {
                            HStack (alignment: .top) {
                                Spacer()
                                VStack (alignment: .leading) {
                                    Text("Bid Winner Team Trick Points:")
                                        .frame(height: 15)
                                    Text("Other Team Trick Points:")
                                        .frame(height: 15)
                                }
                                Text("   ")
                                VStack (alignment: .trailing) {
                                    TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)
                                        .disabled(manager.match.isDisabledBidWinnerTrickPointsTextField)
                                    
                                    TextEntryFieldPhone(placeholder: " -", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)
                                        .disabled(manager.match.isDisabledOtherTeamTrickPointsTextField)
                                }
                                Spacer()
                            }
                        }
                        // End of 2 & 4 Player Trick Points

                        HStack (alignment: .center) {
                            Button("Edit") {
                                $manager.isEditTrickPointsButtonTapped.wrappedValue = true
                                manager.unlockTrickPoints()
                                showingLockedButton = true
                                $manager.match.isDisabledEditTrickPointsBtn.wrappedValue = true
                                //showingEditHandPlay.toggle()
                            }
                            .buttonStyle(PhoneButtonStyle())
                            .disabled(manager.match.isDisabledEditTrickPointsBtn || !manager.match.isMatchSetupCompleted)
                            
                            Button("Save Tricks") {
                                if manager.isTrickPointsSaved {
                                   // Edited trick points being saved
                                    if manager.isEditTrickPointsButtonTapped {
                                        print("\n     > > >     isEditTrickPointsButtonTapped")
                                        if manager.validateEditedTrickPointsValues() {
                                            manager.adjustScoreForEditedTrickPoints()
                                            manager.saveTrickPointsValues()
                                            manager.lockTrickPoints()
                                            showingLockedButton = false
                                            $manager.match.isDisabledEditMeldBtn.wrappedValue = true
                                            if manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                                showingBidderWasSetPopover = true
                                                //$manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet.wrappedValue = false
                                            }
                                            if manager.checkIfGameWinner() {
                                                // There is a game winner
                                                // Check if there is also a match winner
                                                if manager.checkIfMatchCompleted() {
                                                    showingMatchOverPopover = true
                                                } else {
                                                    // Game is over but match is not over
                                                    showingGameOverPopover = true
                                                }
                                            } else {
                                                // There is no game winner so play next hand
                                                $manager.match.isDisabledEditTrickPointsBtn.wrappedValue = false
                                                $manager.match.isDisabledNextHandBtn.wrappedValue = false
                                                $manager.match.showingNextHandArrow.wrappedValue = true
                                                $manager.match.showingNewGameButton.wrappedValue = false
                                                $manager.match.showingNewGameArrow.wrappedValue = false
                                                $manager.match.isDisabledRenegeBtn.wrappedValue = true
                                            }
                                            
                                        } else {
                                            showingInvalidTrickPointsPopover = true
                                        }
                                    }
                                } else {
                                    // First time trick points for the hand are being saved
                                    if manager.validateTrickPointsValues() {
                                        manager.updateScoreWithTrickPoints()
                                        manager.saveTrickPointsValues()
                                        if manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].bidderWasSet {
                                            showingBidderWasSetPopover = true
                                        }
                                        if manager.checkIfGameWinner() {
                                            // There is a game winner
                                            // Check if there is also a match winner
                                            if manager.checkIfMatchCompleted() {
                                                showingMatchOverPopover = true
                                            } else {
                                                // Game is over but match is not over
                                                showingGameOverPopover = true
                                            }
                                        } else {
                                            // There is no game winner so play next hand
                                            $manager.match.isDisabledEditTrickPointsBtn.wrappedValue = false
                                            $manager.match.isDisabledNextHandBtn.wrappedValue = false
                                            $manager.match.showingNextHandArrow.wrappedValue = true
                                            $manager.match.showingNewGameButton.wrappedValue = false
                                            $manager.match.showingNewGameArrow.wrappedValue = false
                                            $manager.match.isDisabledRenegeBtn.wrappedValue = true
                                        }
                                        manager.lockTrickPoints()
                                        $manager.match.isDisabledEditMeldBtn.wrappedValue = true
                                        manager.isTrickPointsSaved = true
                                        $manager.match.isDisabledMisDealBtn.wrappedValue = true
                                        $manager.match.isDisabledConcedeBtn.wrappedValue = false
                                        $manager.match.isDisabledRenegeBtn.wrappedValue = true
                                        
                                        
                                    } else {
                                        showingInvalidTrickPointsPopover = true
                                    }
                                }
                            }
                            .buttonStyle(SmallButtonStyle())
                            .disabled(manager.match.isDisabledSaveTricksBtn || !manager.match.isMatchSetupCompleted)
                            .popover(isPresented: $showingInvalidTrickPointsPopover) {
                                InvalidTrickPointsPopover()
                                    .withDismissButton()
                                    .presentationDetents([.fraction(0.40)])
                            }
                            .popover(isPresented: $showingBidderWasSetPopover) {
                                BidderWasSetPopover()
                                    .withDismissButton()
                                    .presentationDetents([.fraction(0.40)])
                            }
                            .popover(isPresented: $showingGameOverPopover) {
                                GameOverPopover()
                                    .presentationDetents([.fraction(0.60)])
                            }
                            .popover(isPresented: $showingMatchOverPopover) {
                                MatchOverPopover()
                                    .presentationDetents([.fraction(0.60)])
                            }
                            
                            Button("Mis-Deal") {
                                showingMisdealPopover = true
                            }
                            .buttonStyle(SmallButtonStyle())
                            .disabled(manager.match.isDisabledMisDealBtn || !manager.match.isMatchSetupCompleted)
                            .popover(isPresented: $showingMisdealPopover) {
                                MisdealPopover()
                                    .presentationDetents([.fraction(0.40)])
                            }
                        }
                        .padding(.top, 10)
                        
                    }  // End Trick Points VStack
                    .padding(8)
                    .font(.callout)
                    .foregroundColor(Color(.racinggreen))
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    .padding(.horizontal, 10)
                    
                
                } // End of VStack Top of ZStack
                
                // A Warning to complete match setup before user can continue
                if !manager.match.isMatchSetupCompleted {
                    VStack {
                        VStack {
                            Text("Match Setup")
                            Text("Must Be Completed")
                            Text("Before Proceeding")
                        }
                        .font(.title)
                        .foregroundColor(Color(.pomegranate))
                        VStack {
                            Text("Tap 'Setup Match' Button")
                            Text("To Proceed")
                        }
                        .padding(20)
                        .font(.headline)
                        Button("Setup Match") {
                            //showingMatchSetupSheetLocal.toggle()
                            manager.setHandPlayNewHandStatus()
                            print("Before setting showingMatchSetupSheet in warning text of HandView - value: \(manager.match.showingMatchSetupSheet)")
                            $manager.match.showingMatchSetupSheet.wrappedValue = true
                            print("After setting showingMatchSetupSheet in warning text of HandView - value: \(manager.match.showingMatchSetupSheet)")
                            manager.forceViewUpdate = 42
                        }
                        .buttonStyle(FunctionsButtonStyle())
                        .disabled(manager.match.isDisabledEditSetupBtn)
                    }
                    .padding(30)
                    .background(Color(.winter))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.pomegranate), lineWidth: 3)
                    )
                    .padding(20)
                }
            }  // End ZStack
            
            
            Spacer()
            
            if !manager.match.isDisabledNextHandBtn {
                VStack (alignment: .trailing) {
                    HStack {
                        Spacer()
                        HStack (alignment: .top) {
                            if manager.match.showingNewGameArrow {
                                Text("Start New Game")
                                Image(systemName: "arrow.down")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            } else if manager.match.showingNextHandArrow {
                                Text("Start Next Hand")
                                Image(systemName: "arrow.down")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }
                        }
                        Text(" ")
                            .frame(width: 40)
                    }
                    .font(.caption)
                    .foregroundColor(Color(.racinggreen))
                }
            }
            
            if manager.match.showingNewMatchButton {
                VStack (alignment: .leading) {
                    HStack {
                        Text(" ")
                            .frame(width: 40)
                        HStack (alignment: .top) {
                            Image(systemName: "arrow.down")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text("Start New Match")
                        }
                        Spacer()
                    }
                }
                .font(.caption)
                .foregroundColor(Color(.racinggreen))
            }
            
            // Buttons Sections
            HStack (spacing: 2) {
                Button {
                    if manager.match.showingNewMatchButton {
                        print("current match is over so start a new match in HandView End Match / New Match Button")
                        manager.createNewMatch()
                        $manager.match.showingMatchSetupSheet.wrappedValue = true
                        manager.setHandPlayNewHandStatus()
                        $manager.match.showingNewMatchButton.wrappedValue = false
                    } else {
                        showingEndMatchPopover = true
                    }
                } label: {
                    if manager.match.showingNewMatchButton {
                        Text("New Match")
                    } else {
                        Text("End Match")
                    }
                }
                .buttonStyle(PhoneButtonStyle())
                .disabled(manager.match.isDisabledEndMatchBtn)
                
                .popover(isPresented: $showingEndMatchPopover) {
                    EndMatchPopover()
                        .presentationDetents([.fraction(0.40)])
                }
                
                Button("Concede") {
                    showingConcedeGamePopover = true
                }
                .buttonStyle(PhoneButtonStyle())
                .disabled(manager.match.isDisabledConcedeBtn || !manager.match.isMatchSetupCompleted)
                .popover(isPresented: $showingConcedeGamePopover) {
                    ConcedeGamePopover()
                        .presentationDetents([.fraction(0.40)])
                }
                
                Button("Renege") {
                    showingRenegePopover = true
                }
                .buttonStyle(PhoneButtonStyle())
                .disabled(manager.match.isDisabledRenegeBtn || !manager.match.isMatchSetupCompleted)
                .popover(isPresented: $showingRenegePopover) {
                    RenegePopover()
                        .presentationDetents([.fraction(0.70)])
                }
                
                Button {
                    if manager.match.showingNewGameButton {
                        print("current game is over so started a new game in HandView Next Hand / New Game")
                        manager.createNewGame()
                        $manager.match.showingNewGameButton.wrappedValue = false
                        $manager.match.showingNewGameArrow.wrappedValue = false
                    } else {
                        print("current hand is over so started a new hand in HandView Next Hand / New Game Button")
                        manager.createNewHand()
                        $manager.match.showingNextHandArrow.wrappedValue = false
                    }
                    manager.setHandPlayNewHandStatus()
                } label: {
                    if manager.match.showingNewGameButton {
                        Text("New Game")
                    } else {
                        Text("Next Hand")
                    }
                }
                .buttonStyle(PhoneButtonStyle())
                .disabled(manager.match.isDisabledNextHandBtn || !manager.match.isMatchSetupCompleted)
                
            }  // End buttons Section HStack
            .padding(5)
            
            Spacer()
        } // End Top VStack
        .foregroundColor(Color(.racinggreen))
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $manager.match.showingMatchSetupSheet) {
            MatchSetupSheetPhone(match: manager.match, settings: manager.settings)
                .withDismissButton()
        }
        .onAppear{
            if !manager.match.isMatchSetupCompleted {
                //showingMatchSetupSheetLocal.toggle()
                manager.setHandPlayNewHandStatus()
                $manager.match.showingMatchSetupSheet.wrappedValue = true
                manager.forceViewUpdate = 63
            }
        }
    }
}



//struct HandViewPhone_Previews: PreviewProvider {
//    static var previews: some View {
//        HandViewPhone()
//    }
//}
