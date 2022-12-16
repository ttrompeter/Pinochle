//
//  MainTabView.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import RealmSwift
import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var manager: PinochleManager
    
    var body: some View {
        
        VStack (spacing: 30) {
            TabView {
                HandView(match: manager.match)
                    .tabItem {
                        Label("Hand", systemImage: "suit.spade")
                    }
                MeldCardView()
                    .tabItem {
                        Label("Meld Card", systemImage: "doc.plaintext")
                    }
                UserManualView()
                    .tabItem {
                        Label("Manual", systemImage: "character.book.closed")
                    }
                AdminTabView()
                    .tabItem {
                        Label("Admin", systemImage: "pencil.and.outline")
                    }
            }
        }  // End Top VStack
    }
}

//struct HomeTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeTabView()
//    }
//}
