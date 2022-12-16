//
//  SettingsTabView.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import SwiftUI

struct SettingsTabView: View {
    var body: some View {
        VStack (spacing: 30) {
            TabView {
                SettingsPlayersView()
                    .tabItem {
                        Label("Players", systemImage: "doc.plaintext")
                    }
                SettingsScoringView()
                    .tabItem {
                        Label("Scoring", systemImage: "character.book.closed")
                    }
            }
        }  // End Top VStack
    }
}

//struct SettingsTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsTabView()
//    }
//}
