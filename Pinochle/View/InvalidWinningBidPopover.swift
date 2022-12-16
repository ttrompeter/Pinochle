//
//  InvalidWinningBidPopover.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/6/22.
//

import SwiftUI

struct InvalidWinningBidPopover: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: PinochleManager
    
    var body: some View {
        
        VStack (spacing: 10) {
            Image(systemName: "xmark")
                .foregroundColor(Color(.pomegranate))
            Text("Invalid Winning Bid")
                .font(.title)
            if manager.match.selectedNumberOfPlayers == 3 {
                Text("Must be at least \(manager.settings.minimumOpeningBid3Players)")
            } else if manager.match.selectedNumberOfPlayers == 4 {
                Text("Must be at least \(manager.settings.minimumOpeningBid4Players)")
            } else if manager.match.selectedNumberOfPlayers == 5 {
                Text("Must be at least \(manager.settings.minimumOpeningBid5Players)")
            } else if manager.match.selectedNumberOfPlayers == 6 {
                Text("Must be at least \(manager.settings.minimumOpeningBid6Players)")
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



//struct InvalidWinningBidPopover_Previews: PreviewProvider {
//    static var previews: some View {
//        InvalidWinningBidPopover()
//    }
//}
