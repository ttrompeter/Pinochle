//
//  SettingsPlayersView.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/11/22.
//

import RealmSwift
import SwiftUI

    struct SettingsPlayersView: View {
        
        @EnvironmentObject var manager: PinochleManager
        @Environment(\.realm) var realm: Realm
        @ObservedResults(Player.self, sortDescriptor: .init(keyPath: \Player.name)) var players
        @State private var newPlayerName = ""
        
        var playerNames =  [String]()
        
        var body: some View {
            
            if ScorerSingleton.shared.isIPhone == true {
                VStack (spacing: 20) {
                    HStack {
                        Image("oceanapinochle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.racinggreen), lineWidth: 2))
                        Spacer()
                        VStack {
                            Text("Player Settings")
                                .padding(.top, 5)
                                .font(.title2)
                        }
                        Spacer()
                        Image("pinochle72")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.racinggreen), lineWidth: 2))
                    }
                    .padding(.bottom, 5)
                    .padding(.horizontal, 10)
                    
                    VStack {
                        Text("Add A New Player")
                            .font(.headline)
                        Divider()
                            .frame(width: 250)
                        HStack {
                            Spacer()
                            Text("New Player Name: ")
                            TextField("Name", text:$newPlayerName)
                                .frame(width:100, height: 40)
                            Spacer()
                        }
                        Text("Enter name to enable the 'Add Player' button")
                            .font(.caption2)
                            .italic()
                        Button("Add Player") {
                            if !newPlayerName.isEmpty {
                                manager.addPlayer(playerName: newPlayerName)
                                newPlayerName = ""
                            }
                        }
                        .padding(.top, 5)
                        .buttonStyle(FunctionsButtonStyle())
                        .disabled(newPlayerName.isEmpty)
                    }
                    .padding(10)
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    
                    VStack {
                        Text("Delete A Player")
                            .font(.headline)
                        Divider()
                            .frame(width: 200)
                        Text("Swipe Name to Delete")
                            .font(.caption2).italic()
                        HStack {
                            Spacer()
                            List {
                                ForEach(players) { aPlayer in
                                    Text(aPlayer.name)
                                        .foregroundColor(Color(.brown))
                                }
                                .onDelete(perform: removeRows)
                                .listRowBackground(Color(.clouds))
                                
                            }
                            Spacer()
                        }
                        .frame(width: 250)
                    }
                    .padding(10)
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    
                    
                    
                    
                    Spacer()
                }  // End Top VStack
                .padding(20)
                .foregroundColor(Color(.racinggreen))
            } else {
                VStack (spacing: 30) {
                    
                    HStack {
                        Image("oceanapinochle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.racinggreen), lineWidth: 2))
                        Spacer()
                        Text("Player Settings")
                            .padding(5)
                            .font(.largeTitle)
                        Spacer()
                        Image("pinochle72")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.racinggreen), lineWidth: 2))
                    }
                    .padding(.horizontal, 20)
                        
                    VStack {
                        Text("Add A New Player")
                            .font(.title2)
                        Divider()
                            .frame(width: 300)
                        HStack {
                            Spacer()
                            Text("New Player Name: ")
                            TextField("Name", text:$newPlayerName)
                                .frame(width:120, height: 40)
                            Spacer()
                        }
                        Text("Enter name to enable the 'Add Player' button")
                            .font(.caption)
                            .italic()
                        Button("Add Player") {
                            if !newPlayerName.isEmpty {
                                manager.addPlayer(playerName: newPlayerName)
                                newPlayerName = ""
                            }
                        }
                        .padding(.top, 20)
                        .buttonStyle(FunctionsButtonStyle())
                        .disabled(newPlayerName.isEmpty)
                    }
                    .padding(30)
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    
                    VStack {
                        Text("Delete A Player")
                            .font(.title2)
                        Divider()
                            .frame(width: 200)
                        Text("Swipe Name to Delete")
                            .font(.callout).italic()
                        HStack {
                            Spacer()
                            List {
                                ForEach(players) { aPlayer in
                                    Text(aPlayer.name)
                                        .foregroundColor(Color(.brown))
                                }
                                .onDelete(perform: removeRows)
                                .listRowBackground(Color(.clouds))
                                
                            }
                            Spacer()
                        }
                        .frame(width: 250)
                    }
                    .padding(30)
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    
                    Spacer()
                }
                .padding(30)
                .foregroundColor(Color(.racinggreen))
            }
        }
        func removeRows(at offsets: IndexSet) {
            $players.remove(atOffsets: offsets)
        }
    }




//    struct SettingsPlayersView_Previews: PreviewProvider {
//        static var previews: some View {
//            SettingsPlayersView()
//        }
//    }

