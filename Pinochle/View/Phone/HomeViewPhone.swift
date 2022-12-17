//
//  HomeViewPhone.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/29/22.
//

import RealmSwift
import SwiftUI

struct HomeViewPhone: View {
    
    @Environment(\.realm) var realm : Realm
    @EnvironmentObject var manager: PinochleManager
    @State private var isDisabledStartPlayingBtn = false
    @State private var path = NavigationPath()
    @State private var presentExistingMatchAlert = false
    
    var body: some View {
        
        NavigationStack (path: $path) {
            VStack {
                Text("Pinochle Scorer")
                    .padding(.top, 30)
                    .font(.custom("Marker Felt", fixedSize: 50))
                Image("qjgradient")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.racinggreen), lineWidth: 6))
                    .padding(30)
                
                if manager.match.isUnfinishedMatch {
                    Text("There is an unfinished match")
                        .padding(.top, 30)
                        .font(.title3)
                    HStack {
                        Spacer()
                        Button("New Match") {
                            $manager.match.isCompleted.wrappedValue = true
                            manager.createNewMatch()
                            $manager.match.showingMatchSetupSheet.wrappedValue = true
                            $manager.match.showingNewMatchButton.wrappedValue = false
                            path.append(true)
                        }
                        .buttonStyle(FunctionsButtonStyle())
                        Spacer()
                        Button("Resume Match") {
                            print("Tapped Resume Match button")
                            path.append(true)
                        }
                        .buttonStyle(FunctionsButtonStyle())
                        Spacer()
                    }
                } else {
                    Button("Start Playing") {
                        $manager.match.isCompleted.wrappedValue = true
                        manager.createNewMatch()
                        $manager.match.showingMatchSetupSheet.wrappedValue = true
                        $manager.match.showingNewMatchButton.wrappedValue = false
                        path.append(true)
                    }
                    .buttonStyle(FunctionsButtonStyle())
                }
                
                VStack (spacing: 0) {
                    Text("The easiest way to be a score keeper for pinochle games. Flexible for 3 to 6 players. It does the math for you.")
                        .font(.headline)
                        .frame(width: 250)
                        //.padding(.horizontal, 160)
                    Text("Enjoy!")
                        .font(.headline)
                }
                .padding(.top, 40)
                Spacer()
            }
            .navigationDestination(for: Bool.self) { aValue in
                MainTabView()
                //MainTabViewPhone()
            }
        }
        .foregroundColor(Color(.racinggreen))
    }
}


//struct HomeViewPhone_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeViewPhone()
//    }
//}
