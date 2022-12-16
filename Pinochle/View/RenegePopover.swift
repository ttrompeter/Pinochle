//
//  RenegePopover.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/13/22.
//

import SwiftUI

struct RenegePopover: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: PinochleManager
    
    var body: some View {
        
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
                    dismiss()
                } label: {
                    Text("\(manager.match.player1Name)")
                }
                .buttonStyle(SmallButtonStyle())
                Button {
                    print("Renege button tapped player 2")
                    manager.applyRenege(playerName: manager.match.player2Name)
                    dismiss()
                } label: {
                    Text("\(manager.match.player2Name)")
                }
                .buttonStyle(SmallButtonStyle())
                Button {
                    print("Renege button tapped player 3")
                    manager.applyRenege(playerName: manager.match.player3Name)
                    dismiss()
                } label: {
                    Text("\(manager.match.player3Name)")
                }
                .buttonStyle(SmallButtonStyle())
                if manager.match.selectedNumberOfPlayers == 4 || manager.match.selectedNumberOfPlayers == 5 || manager.match.selectedNumberOfPlayers == 6 {
                    Button {
                        print("Renege button tapped player 4")
                        manager.applyRenege(playerName: manager.match.player4Name)
                        dismiss()
                    } label: {
                        Text("\(manager.match.player4Name)")
                    }
                    .buttonStyle(SmallButtonStyle())
                }
                if manager.match.selectedNumberOfPlayers == 5 || manager.match.selectedNumberOfPlayers == 6 {
                    Button {
                        print("Renege button tapped player 5")
                        manager.applyRenege(playerName: manager.match.player5Name)
                        dismiss()
                    } label: {
                        Text("\(manager.match.player5Name)")
                    }
                    .buttonStyle(SmallButtonStyle())
                }
                if manager.match.selectedNumberOfPlayers == 6 {
                    Button {
                        print("Renege button tapped player 6")
                        manager.applyRenege(playerName: manager.match.player6Name)
                        dismiss()
                    } label: {
                        Text("\(manager.match.player6Name)")
                    }
                    .buttonStyle(SmallButtonStyle())
                }
            }
            Button {
                dismiss()
            } label: {
                Text("Cancel")
            }
            .padding(.top, 20)
            .buttonStyle(SmallButtonStyle())
        }
        .padding(40)
        .presentationDetents([.fraction(0.70)])
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.brown), lineWidth: 1)
        )
        .padding(20)
    }
}



//struct RenegePopover_Previews: PreviewProvider {
//    static var previews: some View {
//        RenegePopover()
//    }
//}
