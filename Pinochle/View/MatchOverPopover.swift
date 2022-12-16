//
//  MatchOverPopover.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/6/22.
//

import SwiftUI

struct MatchOverPopover: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: PinochleManager
    
    var body: some View {
        VStack (spacing: 10) {
            Text("Match \(manager.match.matchNumber) is Over")
                .font(.title)
            Image(systemName: "checkmark")
                .foregroundColor(Color(.racinggreen))
            Text("Winner: \(manager.match.matchWinnerText)")
            if manager.match.selectedNumberOfPlayers == 4 {
                if manager.match.games[manager.match.currentGameArrayIndex].gameWinnerText == Constants.TEAM_1 {
                    Text("\(manager.match.player1Name)  |  \(manager.match.player3Name)")
                } else if manager.match.games[manager.match.currentGameArrayIndex].gameWinnerText == Constants.TEAM_2 {
                    Text("\(manager.match.player2Name)  |  \(manager.match.player4Name)")
                }
            }
            VStack {
                Text("Result by Game")
                    .padding(.horizontal, 40)
                    .foregroundColor(Color(.brown))
                VStack (alignment: .leading) {
                    ScrollView {
                        ForEach (manager.match.games) { game in
                            Text("Game \(game.gameNumber) Winner:     \(game.gameWinnerText)")
                        }
                    }
                    .frame(height: 100)
                }
            }
            .padding(20)
            .font(.title3)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.brown), lineWidth: 1)
            )
            Button {
                dismiss()
            } label: {
                Text("Close")
            }
            .padding(.vertical, 20)
            .buttonStyle(SmallButtonStyle())
        }
        .padding(40)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.brown), lineWidth: 1)
        )
        .padding(20)
    }
}


//struct MatchOverPopover_Previews: PreviewProvider {
//    static var previews: some View {
//        MatchOverPopover()
//    }
//}
