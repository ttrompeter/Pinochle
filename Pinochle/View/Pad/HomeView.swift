//
//  HomeView.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import RealmSwift
import SwiftUI

struct HomeView: View {

    @Environment(\.realm) var realm : Realm
    @EnvironmentObject var manager: PinochleManager
    //@State private var goToMainTabView = false
    @State private var isDisabledStartPlayingBtn = false
    @State private var path = NavigationPath()
    @State private var presentExistingMatchAlert = false
    
    
    var body: some View {
        
        NavigationStack (path: $path) {
            VStack {
                Text("Pinochle Scorer")
                    .padding(60)
                    .font(.custom("Marker Felt", fixedSize: 90))
                
                Image("qjgradient")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.racinggreen), lineWidth: 6))
                
                if manager.match.isUnfinishedMatch {
                    Text("There is an unfinished match")
                        .padding(.top, 30)
                        .font(.title)
                    HStack {
                        Button("New Match") {
                            $manager.match.isCompleted.wrappedValue = true
                            manager.createNewMatch()
                            $manager.match.showingMatchSetupSheet.wrappedValue = true
                            $manager.match.showingNewMatchButton.wrappedValue = false
                            path.append(true)
                        }
                        .buttonStyle(LargeButtonStyle())
                        
                        Button("Resume Match") {
                            print("Tapped Resume Match button")
                            path.append(true)
                        }
                        .buttonStyle(LargeButtonStyle())
                    }
                    .padding(40)
                } else {
                    NavigationLink("Start Playing", value: false)
                        .buttonStyle(LargeButtonStyle())
                        .padding(40)
                }
                
                VStack (spacing: 0) {
                    Text("The easiest way to be a score keeper for pinochle games. Flexible for 3 to 6 players. It does the math for you.")
                        .font(.title)
                        .frame(width: 450)
                        //.padding(.horizontal, 160)
                    Text("Enjoy!")
                        .font(.title)
                }
                
                Spacer()
            }
            .navigationDestination(for: Bool.self) { isOngoingMatchValue in
                if isOngoingMatchValue == true {
                    MainTabView()
                } else if isOngoingMatchValue == false {
                    MainTabView()
                    //MatchSetupSheet(match: manager.match, settings: manager.settings)
                }
            }
        }
        .foregroundColor(Color(.racinggreen))
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
