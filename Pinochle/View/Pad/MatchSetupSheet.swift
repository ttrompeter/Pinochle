//
//  MatchSetupSheet.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import RealmSwift
import SwiftUI

struct MatchSetupSheet: View {
        
        @Environment(\.dismiss) var dismiss
        @EnvironmentObject var manager: PinochleManager
        @ObservedRealmObject var match: Match
        @ObservedRealmObject var settings: Settings
        
        @State private var presentInvalidMatchSetupAlert = false
        @State private var isDisabledClearNamesBtn = false
        @State private var isDisabledSaveBtn = false
      
        
    var body: some View {
        
        VStack (spacing: 20) {
            HStack {
                Image("oceanapinochle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.racinggreen), lineWidth: 2))
                Spacer()
                VStack {
                    Text("Match Setup")
                        .font(.largeTitle)
                }
                .padding(30)
                Spacer()
                Image("pinochle72")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.racinggreen), lineWidth: 2))
            }
            .padding(20)
            
            HStack {
                Text("Number of Players")
                    .font(.title3)
                Picker(selection: $manager.match.selectedNumberOfPlayers,
                       label: Text("Number of Players"),
                       content:  {
                    Text("3").tag(3)
                    Text("4").tag(4)
                    Text("5").tag(5)
                    Text("6").tag(6)
                })
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 300)
                .onAppear {
                    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(.tan))
                    UISegmentedControl.appearance().backgroundColor = UIColor(Color(.winter))
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(.racinggreen))], for: .selected)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color(.racinggreen))], for: .normal)
                }
            }
            .padding(.vertical, 10)
            
            // MARK: - Start of 4 & 6 Players Section
            if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 6 {
                VStack {
                    Text(Constants.TEAM_1)
                        .padding(.bottom, 5)
                        .font(.title)
                        .foregroundColor(Color(.racinggreen))
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Player 1")
                                .font(.title3)
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
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Player 3")
                                .font(.title3)
                            Picker(selection: $manager.match.player3Name,
                                   label: Text("Player3"),
                                   content:  {
                                //Text("Select").tag("Player 3")
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                        }
                        
                        if manager.match.selectedNumberOfPlayers == 6 {
                            Spacer()
                            VStack {
                                Text("Player 5")
                                    .font(.title3)
                                Picker(selection: $manager.match.player5Name,
                                       label: Text("Player5"),
                                       content:  {
                                    //Text("Select").tag("Player 5")
                                    ForEach(manager.players) { player in
                                        Text(player.name).tag(player.name)
                                    }
                                })
                                .pickerStyle(MenuPickerStyle())
                                .fixedSize()
                            }
                        }
                        Spacer()
                    }
                }
                .padding(20)
                .background(Color(.clouds))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.racinggreen), lineWidth: 1)
                )
                
                VStack {
                    Text(Constants.TEAM_2)
                        .padding(.bottom, 5)
                        .font(.title)
                        .foregroundColor(Color(.racinggreen))
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Player 2")
                                .font(.title3)
                            Picker(selection: $manager.match.player2Name,
                                   label: Text("Player 2"),
                                   content:  {
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Player 4")
                                .font(.title3)
                            Picker(selection: $manager.match.player4Name,
                                   label: Text("Player 4"),
                                   content:  {
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                        }
                        
                        if manager.match.selectedNumberOfPlayers == 6 {
                            Spacer()
                            VStack {
                                Text("Player 6")
                                    .font(.title3)
                                Picker(selection: $manager.match.player6Name,
                                       label: Text("Player 6"),
                                       content:  {
                                    ForEach(manager.players) { player in
                                        Text(player.name).tag(player.name)
                                    }
                                })
                                .pickerStyle(MenuPickerStyle())
                                .fixedSize()
                            }
                        }
                        
                        Spacer()
                    }
                    
                }
                .padding(20)
                .background(Color(.clouds))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.racinggreen), lineWidth: 1)
                )
                
            }
            // End of 4 & 6 Players Section
            
            
            // MARK: - Start of 5 Players Section
            if manager.match.selectedNumberOfPlayers == 5 {
                VStack {
                    Text("Five Players Match")
                        .padding(.bottom, 10)
                        .font(.title)
                        .foregroundColor(Color(.racinggreen))
                    HStack {
                        Spacer()
                        VStack {
                            Text("Player 1: ")
                                .font(.title3)
                            // $manager.match.player1Name
                            Picker(selection: $manager.match.player1Name,
                                   label: Text("Player1-5"),
                                   content:  {
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Player 2: ")
                                .font(.title3)
                            Picker(selection: $manager.match.player2Name,
                                   label: Text("Player 2-5"),
                                   content:  {
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                        }
                        
                        Spacer()
                        VStack {
                            Text("Player 3: ")
                                .font(.title3)
                            Picker(selection: $manager.match.player3Name,
                                   label: Text("Player 3-5"),
                                   content:  {
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Player 4: ")
                                .font(.title3)
                            Picker(selection: $manager.match.player4Name,
                                   label: Text("Player 4-5"),
                                   content:  {
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Player 5: ")
                                .font(.title3)
                            Picker(selection: $manager.match.player5Name,
                                   label: Text("Player 5-5"),
                                   content:  {
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                        }
                        
                        Spacer()
                    }
                }
                .padding(20)
                .background(Color(.clouds))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.racinggreen), lineWidth: 1)
                )
            }
            // End of 5 Players Section
            
            
            // MARK: - Start of 3 Players Section
            
            if manager.match.selectedNumberOfPlayers == 3 {
                VStack {
                    Text("Three Players Match")
                        .padding(.bottom, 10)
                        .font(.title)
                        .foregroundColor(Color(.racinggreen))
                    HStack {
                        Spacer()
                        VStack {
                            Text("Player 1: ")
                                .font(.title3)
                            // $manager.match.player1Name
                            Picker(selection: $manager.match.player1Name,
                                   label: Text("Player 1-3"),
                                   content:  {
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Player 2: ")
                                .font(.title3)
                            Picker(selection: $manager.match.player2Name,
                                   label: Text("Player 2-3"),
                                   content:  {
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                        }
                        
                        Spacer()
                        VStack {
                            Text("Player 3: ")
                                .font(.title3)
                            Picker(selection: $manager.match.player3Name,
                                   label: Text("Player 3-3"),
                                   content:  {
                                ForEach(manager.players) { player in
                                    Text(player.name).tag(player.name)
                                }
                            })
                            .pickerStyle(MenuPickerStyle())
                            .fixedSize()
                        }
                        
                        Spacer()
                    }
                }
                .padding(20)
                .background(Color(.clouds))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.racinggreen), lineWidth: 1)
                )
            }
            // End of 3 Players Section
            
            VStack {
                Text("First Dealer")
                    .font(.title)
                    .foregroundColor(Color(.racinggreen))
                Text("First dealer must be one of the players already selected for the match")
                    .padding(.bottom, 5)
                    .font(.footnote)
                    .foregroundColor(Color(.racinggreen))
                HStack {
                    Spacer()
                    Text("First Dealer: ")
                        .font(.title3)
                    Picker(selection: $manager.match.firstDealerName,
                           label: Text("First Dealer"),
                           content:  {
                        ForEach(manager.players) { player in
                            Text(player.name).tag(player.name)
                        }
                    })
                    .pickerStyle(MenuPickerStyle())
                    .fixedSize()
                    

                    Spacer()
                }
                
            }
            .padding(20)
            .background(Color(.clouds))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.racinggreen), lineWidth: 1)
            )
            
            VStack (spacing: 25) {
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
            .padding(20)
            .font(.callout)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.racinggreen), lineWidth: 1)
            )
            .padding(.top, 30)
            
            Spacer()
            
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
                .buttonStyle(FunctionsButtonStyle())
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
                .buttonStyle(FunctionsButtonStyle())
                .disabled(isDisabledSaveBtn)
                .alert("Invalid Match Setup", isPresented: $presentInvalidMatchSetupAlert) {
                    Button("OK", role: .cancel) { }
                } message: { Text("Please correct setup selections to proceed") }
                
            }
            .padding(.bottom, 20)
        }  // End top VStack
        .padding(30)
        .foregroundColor(Color(.racinggreen))
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
            
        }   // End body
        
    }


