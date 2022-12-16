//
//  MatchSetupSheetPhone.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/29/22.
//

import RealmSwift
import SwiftUI

struct MatchSetupSheetPhone: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: PinochleManager
    @ObservedRealmObject var match: Match
    @ObservedRealmObject var settings: Settings
    
    @State private var presentInvalidMatchSetupAlert = false
    @State private var isDisabledClearNamesBtn = false
    @State private var isDisabledSaveBtn = false
    
    var body: some View {
        
        VStack (spacing: 15) {
            HStack (alignment: .top) {
                Image("oceanapinochle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.racinggreen), lineWidth: 2))
                Spacer()
                Text("Match Setup")
                    .font(.title)
                Spacer()
                Image("pinochle72")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.racinggreen), lineWidth: 2))
            }
            .padding(.horizontal, 5)
            .padding(.top, 40)
            HStack {
                Text("Number of Players")
                    .font(.body)
                Picker(selection: $manager.match.selectedNumberOfPlayers,
                       label: Text("Number of Players"),
                       content:  {
                    Text("3").tag(3)
                    Text("4").tag(4)
                    Text("5").tag(5)
                    Text("6").tag(6)
                })
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 150)
                .onAppear {
                    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(.tan))
                    UISegmentedControl.appearance().backgroundColor = UIColor(Color(.winter))
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(.racinggreen))], for: .selected)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(.racinggreen))], for: .normal)
                }
            }
            .padding(.vertical, 10)
            
            if manager.match.selectedNumberOfPlayers == 3 || manager.match.selectedNumberOfPlayers == 5 {
                VStack (spacing: 0) {
                    Text("Match - \(manager.match.selectedNumberOfPlayers) Players")
                        .padding(.bottom, 5)
                        .font(.headline)
                HStack (alignment: .top) {
                    Spacer()
                    VStack (alignment: .leading) {
                        Text("Player 1: ")
                            .frame(height: 35)
                        Text("Player 2: ")
                            .frame(height: 35)
                        Text("Player 3: ")
                            .frame(height: 35)
                        if manager.match.selectedNumberOfPlayers == 5 {
                            Text("Player 4: ")
                                .frame(height: 35)
                            Text("Player 5: ")
                                .frame(height: 35)
                        }
                    }
                    VStack (alignment: .leading) {
                        Picker(selection: $manager.match.player1Name,
                               label: Text("Player1"),
                               content:  {
                            //Text("Select").tag("Player 1")
                            ForEach(manager.players) { player in
                                Text(player.name).tag(player.name)
                            }
                        })
                        .pickerStyle(MenuPickerStyle())
                        .fixedSize()
                        Picker(selection: $manager.match.player2Name,
                               label: Text("Player2"),
                               content:  {
                            //Text("Select").tag("Player 2")
                            ForEach(manager.players) { player in
                                Text(player.name).tag(player.name)
                            }
                        })
                        .pickerStyle(MenuPickerStyle())
                        Picker(selection: $manager.match.player3Name,
                               label: Text("Player3"),
                               content:  {
                            //Text("Select").tag("Player 3")
                            ForEach(manager.players) { player in
                                Text(player.name).tag(player.name)
                            }
                        })
                        .pickerStyle(MenuPickerStyle())
                        
                        if manager.match.selectedNumberOfPlayers == 5 {
                            Picker(selection: $manager.match.player4Name,
                                   label: Text("Player4"),
                                   content:  {
                                //Text("Select").tag("Player 4")
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                            Picker(selection: $manager.match.player5Name,
                                   label: Text("Player5"),
                                   content:  {
                                //Text("Select").tag("Player 5")
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    Spacer()
                }
            }
                .padding(5)
                .background(Color(.clouds))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.racinggreen), lineWidth: 1)
                )
            }
            
            // Start of 4 & 6 Players Section
            if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 6 {
                VStack (spacing: 0) {
                    Text(Constants.TEAM_1)
                        .padding(.bottom, 5)
                        .font(.headline)
                    HStack (alignment: .top) {
                        Spacer()
                        VStack (alignment: .leading) {
                            Text("Player 1: ")
                                .frame(height: 35)
                            Text("Player 3: ")
                                .frame(height: 35)
                            if manager.match.selectedNumberOfPlayers == 6 {
                                Text("Player 5: ")
                                    .frame(height: 35)
                            }
                        }
                        VStack (alignment: .leading) {
                            Picker(selection: $manager.match.player1Name,
                                   label: Text("Player1"),
                                   content:  {
                                //Text("Select").tag("Player 1")
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                            Picker(selection: $manager.match.player3Name,
                                   label: Text("Player3"),
                                   content:  {
                                //Text("Select").tag("Player 3")
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            if manager.match.selectedNumberOfPlayers == 6 {
                                Picker(selection: $manager.match.player5Name,
                                       label: Text("Player5"),
                                       content:  {
                                    //Text("Select").tag("Player 5")
                                    ForEach(manager.players) { player in
                                        Text(player.name).tag(player.name)
                                    }
                                })
                                //.frame(height: 35)
                                .pickerStyle(MenuPickerStyle())
                            }
                        }
                        Spacer()
                    }
                }
                .padding(5)
                .background(Color(.clouds))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.racinggreen), lineWidth: 1)
                )
                VStack (spacing: 0) {
                    Text(Constants.TEAM_2)
                        .padding(.bottom, 5)
                        .font(.headline)
                    HStack (alignment: .top) {
                        Spacer()
                        VStack (alignment: .leading) {
                            Text("Player 2: ")
                                .frame(height: 35)
                            Text("Player 4: ")
                                .frame(height: 35)
                            if manager.match.selectedNumberOfPlayers == 6 {
                                Text("Player 6: ")
                                    .frame(height: 35)
                            }
                        }
                        VStack (alignment: .leading) {
                            Picker(selection: $manager.match.player2Name,
                                   label: Text("Player2"),
                                   content:  {
                                //Text("Select").tag("Player 1")
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                            Picker(selection: $manager.match.player4Name,
                                   label: Text("Player4"),
                                   content:  {
                                //Text("Select").tag("Player 4")
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            if manager.match.selectedNumberOfPlayers == 6 {
                                Picker(selection: $manager.match.player6Name,
                                       label: Text("Player6"),
                                       content:  {
                                    //Text("Select").tag("Player 6")
                                    ForEach(manager.players) { player in
                                        Text(player.name).tag(player.name)
                                    }
                                })
                                .pickerStyle(MenuPickerStyle())
                            }
                        }
                        Spacer()
                    }
                }
                .padding(5)
                .background(Color(.clouds))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.racinggreen), lineWidth: 1)
                )
            }   // End of 4 & 6 Players Section
            
            // First Dealer Section
            VStack {
                Text("First Dealer")
                    .font(.headline)
                Text("First dealer must be one of the players already selected for the match")
                    .padding(.vertical, 10)
                    .font(.caption2)
                HStack {
                    Spacer()
                    Text("First Dealer: ")
                    Picker(selection: $manager.match.firstDealerName,
                           label: Text("First Dealer"),
                           content:  {
                        //Text("Select").tag("First Dealer")
                        ForEach(manager.players) { player in
                            Text(player.name).tag(player.name)
                        }
                    })
                    .pickerStyle(MenuPickerStyle())
                    .fixedSize()
                    
                    Spacer()
                }
            }
            .padding(5)
            .background(Color(.clouds))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.racinggreen), lineWidth: 1)
            )
            
            VStack (spacing: 10) {
                HStack (spacing: 30) {
                    VStack (alignment: .leading) {
                        Text("Points To Win Game:")
                        Text("Minimum Opening Bid:")
                        Text("Total Points Per Hand:")
                    }
                    VStack (alignment: .trailing) {
                        if manager.match.selectedNumberOfPlayers == 3 {
                            Text(settings.pointsToWinGame3Players)
                        } else if manager.match.selectedNumberOfPlayers == 4 {
                            Text(settings.pointsToWinGame4Players)
                        } else if manager.match.selectedNumberOfPlayers == 5 {
                            Text(settings.pointsToWinGame5Players)
                        } else if manager.match.selectedNumberOfPlayers == 6 {
                            Text(settings.pointsToWinGame6Players)
                        }
                        if manager.match.selectedNumberOfPlayers == 3 {
                            Text(settings.minimumOpeningBid3Players)
                        } else if manager.match.selectedNumberOfPlayers == 4 {
                            Text(settings.minimumOpeningBid4Players)
                        } else if manager.match.selectedNumberOfPlayers == 5 {
                            Text(settings.minimumOpeningBid5Players)
                        } else if manager.match.selectedNumberOfPlayers == 6 {
                            Text(settings.minimumOpeningBid6Players)
                        }
                        if manager.match.selectedNumberOfPlayers == 3 {
                            Text(settings.pointsPerHand3Players)
                        } else if manager.match.selectedNumberOfPlayers == 4 {
                            Text(settings.pointsPerHand4Players)
                        } else if manager.match.selectedNumberOfPlayers == 5 {
                            Text(settings.pointsPerHand5Players)
                        } else if manager.match.selectedNumberOfPlayers == 6 {
                            Text(settings.pointsPerHand6Players)
                        }
                    }
                }
            }
            .padding(10)
            .font(.caption2)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.racinggreen), lineWidth: 1)
            )
            .padding(.top, 5)
            
            // Button Section
            HStack (spacing: 20) {
                Button {
                    $manager.match.player1Name.wrappedValue = "Select"
                    $manager.match.player2Name.wrappedValue = "Select"
                    $manager.match.player3Name.wrappedValue = "Select"
                    $manager.match.player4Name.wrappedValue = "Select"
                    $manager.match.player5Name.wrappedValue = "Select"
                    $manager.match.player6Name.wrappedValue = "Select"
                    $manager.match.firstDealerName.wrappedValue = "Select"
                } label: {
                    Text("Clear Names")
                }
                .buttonStyle(SmallButtonStyle())
                .disabled(isDisabledClearNamesBtn)
                
                Button(action: {
                    manager.createMatchPlayerNames()
                    if manager.validateMatchSetup() {
                        // Set the dealerName to the First Dealer name
                        $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerName.wrappedValue = manager.match.firstDealerName
                        
                        // Set the dealerPlayerNumber based on the dealerName value
                        if match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerName == manager.match.player1Name {
                            $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerPlayerNumber.wrappedValue = 1
                        } else if match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerName == manager.match.player2Name {
                            $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerPlayerNumber.wrappedValue = 2
                        } else if match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerName == manager.match.player3Name {
                            $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerPlayerNumber.wrappedValue = 3
                        } else if match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerName == manager.match.player4Name {
                            $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerPlayerNumber.wrappedValue = 4
                        } else if match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerName == manager.match.player5Name {
                            $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerPlayerNumber.wrappedValue = 5
                        } else if match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerName == manager.match.player6Name {
                            $manager.match.games[manager.match.currentGameArrayIndex].hands[manager.match.games[manager.match.currentGameArrayIndex].currentHandArrayIndex].dealerPlayerNumber.wrappedValue = 6
                        }
                        
                        // Set match setup is completed to true
                        $manager.match.isMatchSetupCompleted.wrappedValue = true
                        manager.forceViewUpdate = 67
                        dismiss()
                    } else {
                        // Undo the createMatchPlayers that was done above
                        manager.deleteMatchPlayers()
                        presentInvalidMatchSetupAlert.toggle()
                    }
                }) {
                    Text("Save & Start")
                }
                .buttonStyle(SmallButtonStyle())
                .disabled(isDisabledSaveBtn)
                .alert("Invalid Match Setup", isPresented: $presentInvalidMatchSetupAlert) {
                    Button("OK", role: .cancel) { }
                } message: { Text("Please correct setup selections to proceed") }
                
            }
            .padding(.vertical, 10)
            
            Spacer()
        } // End Top VStack
        .padding(5)
        .padding(.top, 10)
        .foregroundColor(Color(.racinggreen))
    }
}

//struct MatchSetupSheetPhone_Previews: PreviewProvider {
//    static var previews: some View {
//        MatchSetupSheetPhone()
//    }
//}
