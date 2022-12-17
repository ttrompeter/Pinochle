//
//  HandView.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import RealmSwift
import SwiftUI

struct HandView: View {
    
    @EnvironmentObject var manager: PinochleManager
    @ObservedRealmObject var match: Match
    
    @State var concedeGameWinnerText = "Unknown"
    @State private var isDisabledMeldEdit = false
    @State var showingBidderWasSetPopover = false
    @State var showingConcedeGamePopover = false
    @State var showingEndMatchPopover = false
    @State var showingGameOverPopover = false
    @State var showingEditHandPlay = false
    @State var showingInvalidMeldPopover = false
    @State var showingInvalidTrickPointsPopover = false
    @State var showingInvalidWinningBidPopover = false
    @State var showingLockedButton = false
    @State var showingMatchOverPopover = false
    @State var showingMisdealPopover = false
    @State var showingRenegePopover = false
    @State var showingScratchPadSheet = false
    @State var showingUnlockedButton = false
    
    // Testing Custom KeyPad
    @State var winningBidAmountText: String = " "
    @State var isKeyPadVisibleWinningBid: Bool = false
    @State var isKeyPadVisiblePlayer1Meld: Bool = false
  
    var body: some View {
        
        VStack {
            // This is just to force view udate
            if manager.match.selectedNumberOfPlayers == 66 {
                Text("\(manager.forceViewUpdate)")
            }
            
            HStack {
                Image("oceanapinochle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.racinggreen), lineWidth: 2))
                Spacer()
                VStack {
                    
                    VStack {
                        Text("Hand Play")
                            .padding(.top, 10)
                            .font(.largeTitle)
                        VStack  {
                            Text("Current Game Score")
                                .foregroundColor(Color(.brown))
                            if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 6 {
                                HStack (spacing: 30) {
                                    HStack {
                                        Text("Team 1:    ")
                                            .foregroundColor(Color(.brown))
                                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].team1Score)")
                                    }
                                    Text(" | ")
                                    HStack {
                                        Text("Team 2:    ")
                                            .foregroundColor(Color(.brown))
                                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].team2Score)")
                                    }
                                }
                            }
                            if manager.match.selectedNumberOfPlayers == 3 || manager.match.selectedNumberOfPlayers == 5 {
                                HStack (spacing: 30) {
                                    HStack {
                                        Text("\(manager.match.player1Name):    ")
                                            .foregroundColor(Color(.brown))
                                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player1Score)")
                                    }
                                    HStack {
                                        Text("\(manager.match.player2Name):    ")
                                            .foregroundColor(Color(.brown))
                                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player2Score)")
                                    }
                                    HStack {
                                        Text("\(manager.match.player3Name):    ")
                                            .foregroundColor(Color(.brown))
                                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player3Score)")
                                    }
                                }
                            }
                            if manager.match.selectedNumberOfPlayers == 5 {
                                HStack (spacing: 30) {
                                    HStack {
                                        Text("\(manager.match.player4Name):    ")
                                            .foregroundColor(Color(.brown))
                                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player4Score)")
                                    }
                                    HStack {
                                        Text("\(manager.match.player5Name):    ")
                                            .foregroundColor(Color(.brown))
                                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player5Score)")
                                    }
                                }
                            }
                        }
                        .padding(10)
                        .font(.title3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.brown), lineWidth: 1)
                        )
                        .padding(10)
                        
                        VStack {
                            Text("Match Score: ")
                            if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 6 {
                                HStack (spacing: 30) {
                                    Text("Team 1:    \(manager.match.team1GamesWon)")
                                    Text(" | ")
                                    Text("Team 2:    \(manager.match.team2GamesWon)")
                                }
                            }
                            if manager.match.selectedNumberOfPlayers == 3 || manager.match.selectedNumberOfPlayers == 5 {
                                HStack (spacing: 30) {
                                    Text("\(manager.match.player1Name): \(manager.match.player1GamesWon)")
                                    Text("\(manager.match.player2Name): \(manager.match.player2GamesWon)")
                                    Text("\(manager.match.player3Name): \(manager.match.player3GamesWon)")
                                }
                            }
                            if manager.match.selectedNumberOfPlayers == 5 {
                                HStack (spacing: 30) {
                                    Text("\(manager.match.player4Name): \(manager.match.player4GamesWon)")
                                    Text("\(manager.match.player5Name): \(manager.match.player5GamesWon)")
                                }
                            }
                        }
                        .padding(10)
                        .font(.footnote)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.racinggreen), lineWidth:0.5)
                        )
                    }
                }
                Spacer()
                Image("pinochle72")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.racinggreen), lineWidth: 2))
            }
            .padding(.bottom, 5)
            .padding(.horizontal, 20)
            
            
            if manager.match.showingPointsNeededToMakeBid {
                HStack {
                    Text("Points Needed To Make Bid: ")
                        .italic()
                    Text("\(manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].pointsNeededToMakeBid)")
                        .italic()
                }
                .font(.body)
                .foregroundColor(Color(.racinggreen))
            } else {
                // Placeholder to maintain layout when points needed to win is not shown
                Text("  ")
                    .font(.body)
            }
            
            ZStack {
                VStack {
                    // MARK: - Start of Bidding Section
                    // Bidding Section
                    HStack (alignment: .top, spacing: 20) {
                        VStack (alignment: .leading) {
                            HStack {
                                HStack {
                                    Text("Dealer: ")
                                    Text("\(manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerName)")
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
                                    .fixedSize()
                                    .disabled(manager.match.isDisabledTrumpPicker  || !manager.match.isMatchSetupCompleted)
                                    .onAppear {
                                        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(.tan))
                                        UISegmentedControl.appearance().backgroundColor = UIColor(Color(.winter))
                                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(.racinggreen))], for: .selected)
                                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(.racinggreen))], for: .normal)
                                    }
                                }
                                .frame(width:260)
                                
                                Text("Game \(manager.match.currentGameNumber)")
                                Text("Hand \(manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].handNumber)")
                            }
                            HStack {
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

                                HStack {
                                    Text("Winning Bid: ")
                                    
                                    Text(manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)
                                        .frame(width:60, height: 30)
                                        .foregroundColor(Color(.racinggreen))
                                        .font(.system(size: 24))
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.tan), lineWidth: 0.5))
                                        .popover(isPresented: $isKeyPadVisibleWinningBid, attachmentAnchor: .point(.trailing), arrowEdge: .leading) {
                                            ZStack {
                                                Color.gray.scaleEffect(1.5).opacity(0.2)
                                                CustomKeyPad(string: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].winningBidText, show: $isKeyPadVisibleWinningBid, updateCallback: { isKeyPadVisibleWinningBid = false }, updateMessage: { print("\(winningBidAmountText)")}
                                                )
                                                .frame(width: 361.0, height: 332.0)
                                                .interactiveDismissDisabled(true)
                                            }
                                        }
                                        .onTapGesture {
                                            isKeyPadVisibleWinningBid.toggle()
                                        }
                                    
                                    
                                    
                                    
//                                    TextEntryField(placeholder: "Bid", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].winningBidText)
//                                        .disabled(manager.match.isDisabledWinningBidTextField)
                                    
                                }
                                .popover(isPresented: $showingInvalidWinningBidPopover) {
                                    VStack (spacing: 10) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(Color(.pomegranate))
                                        Text("Invalid Winning Bid")
                                            .font(.title)
                                        if manager.match.selectedNumberOfPlayers == 3 {
                                            Text("Must be at least \(manager.settings.minimumOpeningBid3Players)")
                                        } else if manager.match.selectedNumberOfPlayers == 4 {
                                            Text("Must be at least \(manager.settings.minimumOpeningBid4Players)")
                                        } else if manager.match.selectedNumberOfPlayers == 5 {
                                            Text("Must be at least \(manager.settings.minimumOpeningBid5Players)")
                                        } else if manager.match.selectedNumberOfPlayers == 6 {
                                            Text("Must be at least \(manager.settings.minimumOpeningBid6Players)")
                                        }
                                        Button {
                                            showingInvalidWinningBidPopover = false
                                        } label: {
                                            Text("Close")
                                        }
                                        .padding(.vertical, 20)
                                        .buttonStyle(SmallButtonStyle())
                                    }
                                    .padding(40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(.brown), lineWidth: 1)
                                    )
                                    .padding(20)
                                }
                                HStack {
                                    if manager.match.selectedNumberOfPlayers == 5 {
                                        HStack {
                                            Text("Partner: ")
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
                                            Text(" ")
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                        
                    }  // End Bidding Section HStack
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .font(.title2)
                    .foregroundColor(Color(.racinggreen))
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    .padding(10)
                    
                    // Meld Points
                    VStack {
                        HStack {
                            Text("Meld Points")
                                .font(.title)
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
                        
                        // Start of 3 Players Meld Section
                        if manager.match.selectedNumberOfPlayers == 3 {
                            VStack (spacing: 0) {
                                    HStack {
                                        Spacer()
                                        HStack {
                                            Text("\(manager.match.player1Name):")
                                                .frame(height: 25)
                                                .lineLimit(1)

                                            TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)
                                                .disabled(manager.match.isDisabledPlayer1MeldTextField)
                                        }
                                        Spacer()
                                        HStack {
                                            Text("\(manager.match.player2Name):")
                                                .frame(height: 25)
                                                .lineLimit(1)
                                            TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)
                                                .disabled(manager.match.isDisabledPlayer2MeldTextField)
                                        }
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(manager.match.player3Name):")
                                            .frame(height: 25)
                                            .lineLimit(1)
                                        
                                        TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)
                                            .disabled(manager.match.isDisabledPlayer3MeldTextField)
                                    }
                                    .padding(.top, 10)
                                }
                        }  // End of 3 Players Meld Section
                        
                        HStack {
                            Spacer()
                            
                            // MARK: - Start of 4 & 6 Players Meld Section
                            // Start of 4 & 6 Player Meld Section
                            if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 6 {
                                
                                VStack {
                                    Text(Constants.TEAM_1)
                                    VStack {
                                        HStack (alignment: .top) {
                                            VStack (alignment: .leading) {
                                                Text("\(manager.match.player1Name)")    // manager.match.player1Name
                                                    .frame(height: 30)
                                                    .lineLimit(1)
                                                Text("\(manager.match.player3Name)")
                                                    .frame(height: 30)
                                                    .lineLimit(1)
                                                if manager.match.selectedNumberOfPlayers == 6 {
                                                    Text("\(manager.match.player5Name)")
                                                        .frame(height: 30)
                                                        .lineLimit(1)
                                                }
                                            }
                                            Text("     ")
                                            VStack (alignment: .trailing) {
        // manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].winningBidText
        // manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText
                                                
                                                Text(winningBidAmountText)
                                                    .frame(width:60, height: 30)
                                                    .foregroundColor(Color(.racinggreen))
                                                    .font(.system(size: 24))
                                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.tan), lineWidth: 0.5))
                                                    .popover(isPresented: $isKeyPadVisiblePlayer1Meld, attachmentAnchor: .point(.trailing), arrowEdge: .leading) {
                                                        ZStack {
                                                            Color.gray.scaleEffect(1.5).opacity(0.2)
                                                            CustomKeyPad(string: $winningBidAmountText, show: $isKeyPadVisiblePlayer1Meld, updateCallback: { isKeyPadVisiblePlayer1Meld = false }, updateMessage: { print("updateMessage: \(winningBidAmountText)")}
                                                            )
                                                            .frame(width: 361.0, height: 332.0)
                                                            .interactiveDismissDisabled(true)
                                                        }
                                                    }
                                                    .onTapGesture {
                                                        isKeyPadVisiblePlayer1Meld.toggle()
                                                    }
                                                
                                                
                                                
                                                
                                                
//                                                Text(manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)
//                                                    .frame(width:60, height: 30)
//                                                    .foregroundColor(Color(.racinggreen))
//                                                    .font(.system(size: 24))
//                                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.tan), lineWidth: 0.5))
//                                                    .popover(isPresented: $isKeyPadVisiblePlayer1Meld, attachmentAnchor: .point(.trailing), arrowEdge: .leading) {
//                                                        ZStack {
//                                                            Color.gray.scaleEffect(1.5).opacity(0.2)
//                                                            CustomKeyPad(string: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText, show: $isKeyPadVisiblePlayer1Meld, updateCallback: { isKeyPadVisiblePlayer1Meld = false }, updateMessage: { print("\(winningBidAmountText)")}
//                                                            )
//                                                            .frame(width: KeyPadConstants.KEYPAD_WIDTH, height: KeyPadConstants.KEYPAD_HEIGHT_WITH_DONE_BUTTON)
//                                                            .interactiveDismissDisabled(true)
//                                                        }
//                                                    }
//                                                    .onTapGesture {
//                                                        isKeyPadVisiblePlayer1Meld.toggle()
//                                                    }
                                                
//                                                TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)
//                                                    .disabled(manager.match.isDisabledPlayer1MeldTextField)
                                                
                                                TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)
                                                    .disabled(manager.match.isDisabledPlayer3MeldTextField)
                                                
                                                if manager.match.selectedNumberOfPlayers == 6 {
                                                    
                                                    TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)
                                                        .disabled(manager.match.isDisabledPlayer5MeldTextField)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 10)
                                    }
                                }
                                .padding(10)
                                .frame(width:350)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(.racinggreen), lineWidth: 1)
                                )
                                
                                Text("     ")
                                Spacer()
                                Text("     ")
                                VStack {
                                    Text(Constants.TEAM_2)
                                    VStack {
                                        HStack (alignment: .top) {
                                            VStack (alignment: .leading) {
                                                Text("\(manager.match.player2Name)")
                                                    .frame(height: 30)
                                                    .lineLimit(1)
                                                Text("\(manager.match.player4Name)")
                                                    .frame(height: 30)
                                                    .lineLimit(1)
                                                if manager.match.selectedNumberOfPlayers == 6 {
                                                    Text("\(manager.match.player6Name)")
                                                        .frame(height: 30)
                                                        .lineLimit(1)
                                                }
                                            }
                                            Text("     ")
                                            VStack (alignment: .trailing) {
                                                
                                                TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)
                                                    .disabled(manager.match.isDisabledPlayer1MeldTextField)
                                                
                                                TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)
                                                    .disabled(manager.match.isDisabledPlayer4MeldTextField)
                                                
                                                if manager.match.selectedNumberOfPlayers == 6 {
                                                    
                                                    TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player6MeldText)
                                                        .disabled(manager.match.isDisabledPlayer6MeldTextField)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 10)
                                    }
                                }
                                .padding(10)
                                .frame(width:350)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(.racinggreen), lineWidth: 1)
                                )
                            }
                            
                            
                            // MARK: - Start of 5 Players Meld Section
                            // Start of 5 Player Meld Section
                            if manager.match.selectedNumberOfPlayers == 5 {
                                VStack {
                                    HStack (alignment: .top) {
                                        VStack (alignment: .leading) {
                                            Text("\(manager.match.player1Name)")
                                                .frame(height: 30)
                                                .lineLimit(1)
                                            Text("\(manager.match.player3Name)")
                                                .frame(height: 30)
                                                .lineLimit(1)
                                            Text("\(manager.match.player5Name)")
                                                .frame(height: 30)
                                                .lineLimit(1)
                                        }
                                        Text("     ")
                                        VStack (alignment: .trailing) {
                                            
                                            TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player1MeldText)
                                                .disabled(manager.match.isDisabledPlayer1MeldTextField)
                                            
                                            TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player3MeldText)
                                                .disabled(manager.match.isDisabledPlayer3MeldTextField)
                                            
                                            TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player5MeldText)
                                                .disabled(manager.match.isDisabledPlayer5MeldTextField)
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                }
                                Spacer()
                                VStack {
                                    HStack (alignment: .top) {
                                        VStack (alignment: .leading) {
                                            Text("\(manager.match.player2Name)")
                                                .frame(height: 30)
                                                .lineLimit(1)
                                            Text("\(manager.match.player4Name)")
                                                .frame(height: 30)
                                                .lineLimit(1)
                                            Text("")
                                                .frame(height: 30)
                                                .lineLimit(1)
                                        }
                                        Text("     ")
                                        VStack (alignment: .trailing) {
                                            
                                            TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player2MeldText)
                                                .disabled(manager.match.isDisabledPlayer2MeldTextField)
                                            
                                            TextEntryField(placeholder: "Meld", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player4MeldText)
                                                .disabled(manager.match.isDisabledPlayer4MeldTextField)
                                            // TODO: - Should be empty spacer to balance layout
                                            Text("")
                                                .frame(width:50, height: 30)
                                                .lineLimit(1)
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                }
                            }
                            // End of 5 Player Meld Section
                            
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        
                        HStack (alignment: .center, spacing: 40) {
                            Button("Edit") {
                                manager.unlockMeld()
                                $manager.match.isDisabledEditMeldBtn.wrappedValue = true
                            }
                            .buttonStyle(SmallButtonStyle())
                            .disabled(manager.match.isDisabledEditMeldBtn || !manager.match.isMatchSetupCompleted)

                            // MARK: - Save Meld Button
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
                                            //unlockTrickPoints()
                                            
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
                            .buttonStyle(FunctionsButtonStyle())
                            .disabled(manager.match.isDisabledSaveMeldBtn || !manager.match.isMatchSetupCompleted)
                            .popover(isPresented: $showingInvalidMeldPopover) {
                                InvalidMeldPopover()
                            }
                            
                            Button("Scratch Pad") {
                                showingScratchPadSheet.toggle()
                            }
                            .buttonStyle(SmallButtonStyle())
                            .disabled(manager.match.isDisabledScratchPadBtn)
                            .sheet(isPresented: $showingScratchPadSheet) {
                                ScratchPadSheet()
                                    .withDismissButton()
                            }
                        }
                        .padding(.top, 10)
                    }  // End of Meld Section VStack
                    .padding(15)
                    .font(.title2)
                    .foregroundColor(Color(.racinggreen))
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    .padding(10)
                    
                    
                    // MARK: - Start Trick Points Section
                    // Trick Points Section
                    VStack {
                        Text("Trick Points")
                            .font(.title)
                        
                        // Start of 3 Players Trick Points Section
                        if manager.match.selectedNumberOfPlayers == 3 {
                            VStack (spacing: 0) {
                                    HStack {
                                        Spacer()
                                        HStack {
                                            Text("\(manager.match.player1Name):")
                                                .frame(width:140, height: 30)
                                                .lineLimit(1)
                                            
                                            TextEntryField(placeholder: "Tricks", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player1TrickPointsText)
                                                .disabled(manager.match.isDisabledPlayer1TrickPointsTextField)
                                        }
                                        Spacer()
                                        HStack {
                                            Text("\(manager.match.player2Name):")
                                                .frame(width:140, height: 30)
                                                .lineLimit(1)
                                            TextEntryField(placeholder: "Tricks", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player2TrickPointsText)
                                                .disabled(manager.match.isDisabledPlayer2TrickPointsTextField)
                                        }
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(manager.match.player3Name):")
                                            .frame(width:140, height: 30)
                                            .lineLimit(1)
                                        
                                        TextEntryField(placeholder: "Tricks", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].player3TrickPointsText)
                                            .disabled(manager.match.isDisabledPlayer3TrickPointsTextField)
                                    }
                                    .padding(.top, 10)
                                }
                        }  // End of 3 Players Trick Points Section
                        
                        // Start of 4, 5 & 6 Player Trick Points
                        //VStack {
                        if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 5 || manager.match.selectedNumberOfPlayers == 6 {
                            HStack (alignment: .top) {
                                Spacer()
                                VStack (alignment: .leading) {
                                    Text("Bid Winner Team Trick Points")
                                        .frame(height: 30)
                                    Text("Other Team Trick Points")
                                        .frame(height: 30)
                                }
                                Text("     ")
                                VStack (alignment: .trailing) {
                                    
                                    TextEntryField(placeholder: "Tricks", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].bidWinnerTeamTrickPointsText)
                                        .disabled(manager.match.isDisabledBidWinnerTrickPointsTextField)
                                    
                                    TextEntryField(placeholder: "Tricks", prompt: "Number", field: $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].otherTeamTrickPointsText)
                                        .disabled(manager.match.isDisabledOtherTeamTrickPointsTextField)
                                }
                                Spacer()
                            }
                        }
                        // End of 3 & 4 Player Trick Points

                        
                        HStack (alignment: .center, spacing: 40) {
                            Button("Edit") {
                                $manager.isEditTrickPointsButtonTapped.wrappedValue = true
                                manager.unlockTrickPoints()
                                showingLockedButton = true
                                $manager.match.isDisabledEditTrickPointsBtn.wrappedValue = true
                                //showingEditHandPlay.toggle()
                            }
                            .buttonStyle(SmallButtonStyle())
                            .disabled(manager.match.isDisabledEditTrickPointsBtn || !manager.match.isMatchSetupCompleted)

                            // MARK: - Save Tricks Button
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
                            .buttonStyle(FunctionsButtonStyle())
                            .disabled(manager.match.isDisabledSaveTricksBtn || !manager.match.isMatchSetupCompleted)
                            .popover(isPresented: $showingInvalidTrickPointsPopover) {
                                InvalidTrickPointsPopover()
                            }
                            .popover(isPresented: $showingBidderWasSetPopover) {
                                BidderWasSetPopover()
                            }
                            
                            // MARK: - Game Over Popover
                            .popover(isPresented: $showingGameOverPopover) {
                                GameOverPopover()
                            }
                            
                            // MARK: - Match Over Popover
                            .popover(isPresented: $showingMatchOverPopover) {
                                MatchOverPopover()
                            }
                            
                            Button("Mis-Deal") {
                                showingMisdealPopover = true
                            }
                            .buttonStyle(SmallButtonStyle())
                            .disabled(manager.match.isDisabledMisDealBtn || !manager.match.isMatchSetupCompleted)
                            
                            // MARK: - Mid-Deal Popover
                            .popover(isPresented: $showingMisdealPopover) {
                                MisdealPopover()
                            }
                        }
                        .padding(.top, 10)
                        
                    }     // End Trick Points Section VStack
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                    .font(.title2)
                    .foregroundColor(Color(.racinggreen))
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    .padding(10)
                }
                
                // A Warning to complete match setup before user can continue
                if !manager.match.isMatchSetupCompleted {
                    VStack {
                        VStack (spacing: 10) {
                            Text("Match Setup")
                            Text("Must Be Completed Before Proceeding")
                        }
                        .padding(15)
                        .font(.title)
                        .foregroundColor(Color(.pomegranate))
                        Text("Tap 'Setup Match' Button To Proceed")
                            .padding(30)
                            .font(.title3)
                        Button("Setup Match") {
                            manager.setHandPlayNewHandStatus()
                            print("Before setting showingMatchSetupSheet in warning text of HandView - value: \(manager.match.showingMatchSetupSheet)")
                            $manager.match.showingMatchSetupSheet.wrappedValue = true
                            print("After setting showingMatchSetupSheet in warning text of HandView - value: \(manager.match.showingMatchSetupSheet)")
                            manager.forceViewUpdate = 42
                        }
                        .buttonStyle(FunctionsButtonStyle())
                        .disabled(manager.match.isDisabledEditSetupBtn)
                    }
                    .padding(40)
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
                                    .frame(width: 25, height: 25)
                            } else if manager.match.showingNextHandArrow {
                                Text("Start Next Hand")
                                Image(systemName: "arrow.down")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                        Text(" ")
                            .frame(width: 140)
                    }
                    .font(.callout)
                    .foregroundColor(Color(.racinggreen))
                }
            }
            
            if manager.match.showingNewMatchButton {
                VStack (alignment: .leading) {
                    HStack {
                        Text(" ")
                            .frame(width: 140)
                        HStack (alignment: .top) {
                            Image(systemName: "arrow.down")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Start New Match")
                        }
                        Spacer()
                    }
                }
                .font(.callout)
                .foregroundColor(Color(.racinggreen))
            }
            
            // MARK: - Start Bottom Buttons Section
            // Buttons Sections
            HStack (spacing: 15) {
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
                .buttonStyle(FunctionsButtonStyle())
                .disabled(manager.match.isDisabledEndMatchBtn)
                .popover(isPresented: $showingEndMatchPopover) {
                    VStack (spacing: 10) {
                        Text("End Match")
                            .font(.title)
                        Text("Match Will Be Closed")
                        Text("THIS CANNOT BE UNDONE")
                            .padding(.vertical, 10)
                            .font(.headline)
                            .foregroundColor(Color(.pomegranate))
                        HStack (spacing: 30) {
                            Button {
                                showingEndMatchPopover = false
                            } label: {
                                Text("Cancel")
                            }
                            .buttonStyle(SmallButtonStyle())
                            Button {
                                manager.endMatch()
                                showingEndMatchPopover = false
                            } label: {
                                Text("End Match")
                            }
                            .buttonStyle(SmallButtonStyle())
                        }
                        .padding(.vertical, 15)
                    }
                    .padding(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.brown), lineWidth: 1)
                    )
                    .padding(20)
                }
                
                // MARK: - Concede Button
                Button("Concede") {
                    showingConcedeGamePopover = true
                }
                .buttonStyle(FunctionsButtonStyle())
                .disabled(manager.match.isDisabledConcedeBtn || !manager.match.isMatchSetupCompleted)
                .popover(isPresented: $showingConcedeGamePopover) {
                    VStack (spacing: 10) {
                        Text("Concede This Game")
                            .font(.title)
                        Text("Game Winner will be: \(manager.getConcedeGameWinnerText())")
                        if !manager.shouldConcedeGame() {
                            Text("The scores appear too close to concede the game")
                                .foregroundColor(Color(.pomegranate))
                            Text("Concede Anyway?")
                        }
                        HStack (spacing: 30) {
                            Button {
                                showingConcedeGamePopover = false
                            } label: {
                                Text("Cancel")
                            }
                            .padding(.vertical, 20)
                            .buttonStyle(SmallButtonStyle())
                            Button {
                                print("Concede button tapped")
                                manager.concedeGame()
                                $manager.match.isDisabledConcedeBtn.wrappedValue = true
                                showingConcedeGamePopover = false
                            } label: {
                                Text("Concede")
                            }
                            .padding(.vertical, 15)
                            .buttonStyle(SmallButtonStyle())
                        }
                    }
                    .padding(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.brown), lineWidth: 1)
                    )
                    .padding(20)
                }
                
                Button("Renege") {
                    showingRenegePopover = true
                }
                .buttonStyle(FunctionsButtonStyle())
                .disabled(manager.match.isDisabledRenegeBtn || !manager.match.isMatchSetupCompleted)
                .popover(isPresented: $showingRenegePopover) {
                    VStack (spacing: 10) {
                        Text("Player Reneged")
                            .font(.title)
                        Text("In the event a player reneges, the hand will end. No players will get any trick points. All players, except the reneging player, will keep their meld points. If the bid winner, the reneging player will have the bid deducted from the appropriate score.")
                            .font(.callout)
                            .frame(width: 300)
                        VStack {
                            Button {
                                print("Renege button tapped player 1")
                                manager.applyRenege(playerName: manager.match.player1Name)
                                showingRenegePopover = false
                            } label: {
                                Text("\(manager.match.player1Name)")
                            }
                            .buttonStyle(SmallButtonStyle())
                            Button {
                                print("Renege button tapped player 2")
                                manager.applyRenege(playerName: manager.match.player2Name)
                                showingRenegePopover = false
                            } label: {
                                Text("\(manager.match.player2Name)")
                            }
                            .buttonStyle(SmallButtonStyle())
                            Button {
                                print("Renege button tapped player 3")
                                manager.applyRenege(playerName: manager.match.player3Name)
                                showingRenegePopover = false
                            } label: {
                                Text("\(manager.match.player3Name)")
                            }
                            .buttonStyle(SmallButtonStyle())
                            if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 5 || manager.match.selectedNumberOfPlayers == 6 {
                                Button {
                                    print("Renege button tapped player 4")
                                    manager.applyRenege(playerName: manager.match.player4Name)
                                    showingRenegePopover = false
                                } label: {
                                    Text("\(manager.match.player4Name)")
                                }
                                .buttonStyle(SmallButtonStyle())
                            }
                            if manager.match.selectedNumberOfPlayers == 5 || manager.match.selectedNumberOfPlayers == 6 {
                                Button {
                                    print("Renege button tapped player 5")
                                    manager.applyRenege(playerName: manager.match.player5Name)
                                    showingRenegePopover = false
                                } label: {
                                    Text("\(manager.match.player5Name)")
                                }
                                .buttonStyle(SmallButtonStyle())
                            }
                            if manager.match.selectedNumberOfPlayers == 6 {
                                Button {
                                    print("Renege button tapped player 6")
                                    manager.applyRenege(playerName: manager.match.player6Name)
                                    showingRenegePopover = false
                                } label: {
                                    Text("\(manager.match.player6Name)")
                                }
                                .buttonStyle(SmallButtonStyle())
                            }
                        }
                        Divider()
                            .frame(width: 100)
                        Button {
                            showingRenegePopover = false
                        } label: {
                            Text("Cancel")
                        }
                        .padding(.vertical, 30)
                        .buttonStyle(SmallButtonStyle())
                    }
                    .padding(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.brown), lineWidth: 1)
                    )
                    .padding(20)
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
                .buttonStyle(FunctionsButtonStyle())
                .disabled(manager.match.isDisabledNextHandBtn || !manager.match.isMatchSetupCompleted)
                
            }  // End buttons Section HStack
            .padding(.bottom, 20)
            
        }  // End top VStack
        .padding(.horizontal, 20)
        .foregroundColor(Color(.racinggreen))
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $manager.match.showingMatchSetupSheet, content: {
            MatchSetupSheet(match: manager.match, settings: manager.settings)
                .withDismissButton()
                
        })
        .onAppear {
            print("\n   > > > > Starting onAppear in HandView")
            if !manager.match.isMatchSetupCompleted {
                manager.setHandPlayNewHandStatus()
                $manager.match.showingMatchSetupSheet.wrappedValue = true
                manager.forceViewUpdate = 63
            }
        }
    }
    
}

//struct HandView_Previews: PreviewProvider {
//    static var previews: some View {
//        HandView()
//    }
//}
