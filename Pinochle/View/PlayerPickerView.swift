//
//  PlayerPickerView.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/7/22.
//

import SwiftUI

struct PlayerPickerView: View {
    
    @EnvironmentObject var manager: PinochleManager
    
    @State private var displayOpacity = 0.0
    var body: some View {
        
        ZStack {
            Color(.clouds).opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack {
                    ScrollView(showsIndicators: false){
                        VStack(spacing: 10) {
                            //ForEach(((currentYear-100)...currentYear).reversed(), id: \.self) { year in
                            ForEach($manager.players) { player in
                                
                                Button(action: {
                                    print("player name: \(player.name)")
                                    //self.birthYear = year   ... something like selected player = player.name
                                    manager.showingPlayerSelector = false
                                }) {
                                    Text("TBD")
                                        .foregroundColor(.primary)
                                }
                                .buttonStyle(PlayerListButtonStyle())
                            }
                        }
                    }
                    
                    .frame(height: 400)
                }.padding()
                    .frame(width: 300)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                //Spacer()
            }.padding(.top)
            //withAnimation(.easeIn(duration: 1.0)) { displayOpacity = 0.5 }
        }
        //.frame(width: 200)
    }
}

