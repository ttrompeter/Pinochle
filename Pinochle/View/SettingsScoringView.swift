//
//  SettingsScoringView.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/11/22.
//

import RealmSwift
import SwiftUI

struct SettingsScoringView: View {
    
    @EnvironmentObject var manager: PinochleManager
    //@ObservedRealmObject var match: Match
    //@ObservedRealmObject var settings: Settings
    
    @State private var pointsToWinGame_3Players = ""
    @State private var pointsToWinGame_4Players = ""
    @State private var pointsToWinGame_5Players = ""
    @State private var pointsToWinGame_6Players = ""
    
    @State private var minimumOpeningBid_3Players = ""
    @State private var minimumOpeningBid_4Players = ""
    @State private var minimumOpeningBid_5Players = ""
    @State private var minimumOpeningBid_6Players = ""
    
    @State private var totalPointsPerHand_3Players = ""
    @State private var totalPointsPerHand_4Players = ""
    @State private var totalPointsPerHand_5Players = ""
    @State private var totalPointsPerHand_6Players = ""
    
    @State private var scoreDifferentialMinimum = ""
    
    
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
                        Text("Scoring Settings")
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
                
                VStack (spacing: 10) {
                    Text("Edit Scoring Values")
                        .padding(.bottom, 5)
                        .font(.headline)
                    
                    VStack (alignment: .leading) {
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Points To Win Game - 3 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.pointsToWinGame3Players)", text: $pointsToWinGame_3Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 500").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Points To Win Game - 4 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.pointsToWinGame4Players)", text: $pointsToWinGame_4Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 500").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Points To Win Game - 5 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.pointsToWinGame5Players)", text: $pointsToWinGame_5Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 800").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Points To Win Game - 6 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.pointsToWinGame6Players)", text: $pointsToWinGame_6Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 500").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        
                    }
                    .padding(8)
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    
                    VStack (alignment: .leading) {
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Minimum Opening Bid - 3 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.minimumOpeningBid3Players)", text: $minimumOpeningBid_3Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 25").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Minimum Opening Bid - 4 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.minimumOpeningBid4Players)", text: $minimumOpeningBid_4Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 25").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Minimum Opening Bid - 5 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.minimumOpeningBid5Players)", text: $minimumOpeningBid_5Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 50").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Minimum Opening Bid - 6 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.minimumOpeningBid6Players)", text: $minimumOpeningBid_6Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 50").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        
                    }
                    .padding(8)
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )

                    VStack (alignment: .leading) {
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Total Points Per Hand - 3 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.pointsPerHand3Players)", text: $totalPointsPerHand_3Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 50").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Total Points Per Hand - 4 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.pointsPerHand4Players)", text: $totalPointsPerHand_4Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 50").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Total Points Per Hand - 5 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.pointsPerHand5Players)", text: $totalPointsPerHand_5Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 75").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Total Points Per Hand - 6 Players: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.pointsPerHand6Players)", text: $totalPointsPerHand_6Players)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 75").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                        
                    }
                    .padding(8)
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    
                    VStack (alignment: .leading) {
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Score Differential Minimum: ")
                                .frame(height: 20)
                            TextField("\(manager.settings.scoreDifferentialMinimum)", text: $scoreDifferentialMinimum)
                                .background(Color(.lighttan))
                                .frame(width:30, height: 20)
                            Text("Default: 71").opacity(0.4)
                                .frame(height: 20)
                            Spacer()
                        }
                    }
                    .padding(8)
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                }
                .font(.footnote)
   
                Spacer()
            }  // End Top VStack
            .padding(20)
            .foregroundColor(Color(.racinggreen))
        } else {
            VStack {
                
                HStack {
                    Image("oceanapinochle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.racinggreen), lineWidth: 2))
                    Spacer()
                    Text("Scoring Settings")
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
                
                VStack (spacing: 20) {
                    Text("Edit Scoring Values")
                        .padding(.bottom, 10)
                        .font(.title2)
                    
                    VStack (alignment: .leading) {
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Points To Win Game - 3 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.pointsToWinGame3Players)", text: $pointsToWinGame_3Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 500").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Points To Win Game - 4 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.pointsToWinGame4Players)", text: $pointsToWinGame_4Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 500").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Points To Win Game - 5 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.pointsToWinGame5Players)", text: $pointsToWinGame_5Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 800").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Points To Win Game - 6 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.pointsToWinGame6Players)", text: $pointsToWinGame_6Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 500").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        
                    }
                    .padding(20)
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    
                    
                    VStack (alignment: .leading) {
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Minimum Opening Bid - 3 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.minimumOpeningBid3Players)", text: $minimumOpeningBid_3Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 25").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Minimum Opening Bid - 4 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.minimumOpeningBid4Players)", text: $minimumOpeningBid_4Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 25").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Minimum Opening Bid - 5 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.minimumOpeningBid5Players)", text: $minimumOpeningBid_5Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 50").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Minimum Opening Bid - 6 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.minimumOpeningBid6Players)", text: $minimumOpeningBid_6Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 50").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        
                    }
                    .padding(20)
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    
                    
                    VStack (alignment: .leading) {
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Total Points Per Hand - 3 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.pointsPerHand3Players)", text: $totalPointsPerHand_3Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 50").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Total Points Per Hand - 4 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.pointsPerHand4Players)", text: $totalPointsPerHand_4Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 50").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Total Points Per Hand - 5 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.pointsPerHand5Players)", text: $totalPointsPerHand_5Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 75").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Total Points Per Hand - 6 Players: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.pointsPerHand6Players)", text: $totalPointsPerHand_6Players)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 75").opacity(0.4)
                                .frame(height: 30)
                            Spacer()
                        }
                        
                    }
                    .padding(20)
                    .background(Color(.clouds))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.racinggreen), lineWidth: 1)
                    )
                    
                    VStack (alignment: .leading) {
                        HStack (alignment: .top) {
                            Spacer()
                            Text("Score Differential Minimum: ")
                                .frame(height: 30)
                            TextField("\(manager.settings.scoreDifferentialMinimum)", text: $scoreDifferentialMinimum)
                                .background(Color(.lighttan))
                                .frame(width:50, height: 30)
                            Text("Default: 71").opacity(0.4)
                                .frame(height: 30)
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
                .padding(.horizontal, 40)
                
                HStack (spacing: 15) {
                    Spacer()
                    Button("Clear") {
                        pointsToWinGame_3Players = ""
                        pointsToWinGame_4Players = ""
                        pointsToWinGame_5Players = ""
                        pointsToWinGame_6Players = ""
                        minimumOpeningBid_3Players = ""
                        minimumOpeningBid_4Players = ""
                        minimumOpeningBid_5Players = ""
                        minimumOpeningBid_6Players = ""
                        totalPointsPerHand_3Players = ""
                        totalPointsPerHand_4Players = ""
                        totalPointsPerHand_5Players = ""
                        totalPointsPerHand_6Players = ""
                        scoreDifferentialMinimum = ""
                    }
                    .buttonStyle(FunctionsButtonStyle())
                    
                    Spacer()
                    Button("Save Changes") {
                        saveChangesToScoring()
                    }
                    .buttonStyle(FunctionsButtonStyle())
                    .padding()
                    
                    Spacer()
                }
                .padding(.top, 30)
                Spacer()
            }  // End Top VStack
            .padding(30)
            .foregroundColor(Color(.racinggreen))
        }
    }
    
    func saveChangesToScoring() {
        if !pointsToWinGame_3Players.isEmpty {
            $manager.settings.pointsToWinGame3Players.wrappedValue = pointsToWinGame_3Players
        }
        if !pointsToWinGame_4Players.isEmpty {
            $manager.settings.pointsToWinGame4Players.wrappedValue = pointsToWinGame_4Players
        }
        if !pointsToWinGame_5Players.isEmpty {
            $manager.settings.pointsToWinGame5Players.wrappedValue = pointsToWinGame_5Players
        }
        if !pointsToWinGame_6Players.isEmpty {
            $manager.settings.pointsToWinGame6Players.wrappedValue = pointsToWinGame_6Players
        }
        
        if !minimumOpeningBid_3Players.isEmpty {
            $manager.settings.minimumOpeningBid3Players.wrappedValue = minimumOpeningBid_3Players
        }
        if !minimumOpeningBid_4Players.isEmpty {
            $manager.settings.minimumOpeningBid4Players.wrappedValue = minimumOpeningBid_4Players
        }
        if !minimumOpeningBid_5Players.isEmpty {
            $manager.settings.minimumOpeningBid5Players.wrappedValue = minimumOpeningBid_5Players
        }
        if !minimumOpeningBid_6Players.isEmpty {
            $manager.settings.minimumOpeningBid6Players.wrappedValue = minimumOpeningBid_6Players
        }
        
        if !totalPointsPerHand_3Players.isEmpty {
            $manager.settings.pointsPerHand3Players.wrappedValue = totalPointsPerHand_3Players
        }
        if !totalPointsPerHand_4Players.isEmpty {
            $manager.settings.pointsPerHand4Players.wrappedValue = totalPointsPerHand_4Players
        }
        if !totalPointsPerHand_5Players.isEmpty {
            $manager.settings.pointsPerHand5Players.wrappedValue = totalPointsPerHand_5Players
        }
        if !totalPointsPerHand_6Players.isEmpty {
            $manager.settings.pointsPerHand6Players.wrappedValue = totalPointsPerHand_6Players
        }
    }
}

//struct SettingsScoringView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsScoringView()
//    }
//}

