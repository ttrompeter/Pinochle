//
//  GameOverPopover.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/5/22.
//

import SwiftUI

struct GameOverPopover: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: PinochleManager
    
    var body: some View {
        VStack (spacing: 10) {
            Text("Game \(manager.match.games[manager.match.currentGameArrayIndex].gameNumber) is Over")
                .font(.title)
            Image(systemName: "checkmark")
                .foregroundColor(Color(.racinggreen))
            Text("Winner: \(manager.match.games[manager.match.currentGameArrayIndex].gameWinnerText)")
            if manager.match.selectedNumberOfPlayers == 3 {
                Divider()
                    .padding(.vertical, 10)
                    .frame(width: 100)
                HStack {
                    VStack (alignment: .leading) {
                        Text("\(manager.match.player1Name):")
                        Text("\(manager.match.player2Name):")
                        Text("\(manager.match.player3Name):")
                    }
                    Text("     ")  // Spacing view
                    VStack (alignment: .trailing) {
                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player1Score)")
                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player2Score)")
                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player3Score)")
                    }
                }
            } else if manager.match.selectedNumberOfPlayers == 4 {
                if manager.match.games[manager.match.currentGameArrayIndex].gameWinnerText == Constants.TEAM_1 {
                    Text("\(manager.match.player1Name)  |  \(manager.match.player3Name)")
                } else {
                    Text("\(manager.match.player2Name)  |  \(manager.match.player4Name)")
                }
            } else if manager.match.selectedNumberOfPlayers == 5 {
                Divider()
                    .padding(.vertical, 10)
                    .frame(width: 100)
                HStack {
                    VStack (alignment: .leading) {
                        Text("\(manager.match.player1Name):")
                        Text("\(manager.match.player2Name):")
                        Text("\(manager.match.player3Name):")
                        Text("\(manager.match.player4Name):")
                        Text("\(manager.match.player5Name):")
                    }
                    Text("     ")  // Spacing view
                    VStack (alignment: .trailing) {
                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player1Score)")
                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player2Score)")
                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player3Score)")
                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player4Score)")
                        Text("\(manager.match.games[manager.match.currentGameArrayIndex].player5Score)")
                    }
                }
            } else if manager.match.selectedNumberOfPlayers == 6 {
                if manager.match.games[manager.match.currentGameArrayIndex].gameWinnerText == Constants.TEAM_1 {
                    Text("\(manager.match.player1Name)  |  \(manager.match.player3Name)  |  \(manager.match.player5Name)")
                } else {
                    Text("\(manager.match.player2Name)  |  \(manager.match.player4Name)  |  \(manager.match.player6Name)")
                }
            }
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


//struct GameOverPopover_Previews: PreviewProvider {
//    static var previews: some View {
//        GameOverPopover()
//    }
//}
