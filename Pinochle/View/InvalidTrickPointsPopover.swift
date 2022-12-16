//
//  InvalidTrickPointsPopover.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/6/22.
//

import SwiftUI

struct InvalidTrickPointsPopover: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: PinochleManager
    
    var body: some View {
        
        VStack (spacing: 10) {
            Image(systemName: "xmark")
                .foregroundColor(Color(.pomegranate))
            Text("Invalid Trick Points Entry")
                .font(.title)
            Text("Must be a positive number")
            Text("No letters or other characters allowed")
            if manager.match.selectedNumberOfPlayers == 3 {
                Text("Must total \(manager.settings.pointsPerHand3Players)")
            } else if manager.match.selectedNumberOfPlayers == 4 {
                Text("Must total \(manager.settings.pointsPerHand4Players)")
            } else if manager.match.selectedNumberOfPlayers == 5 {
                Text("Must total \(manager.settings.pointsPerHand5Players)")
            } else if manager.match.selectedNumberOfPlayers == 6 {
                Text("Must total \(manager.settings.pointsPerHand6Players)")
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

struct InvalidTrickPointsPopover_Previews: PreviewProvider {
    static var previews: some View {
        InvalidTrickPointsPopover()
    }
}
