//
//  ConcedeGamePopover.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/13/22.
//

import SwiftUI

struct ConcedeGamePopover: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: PinochleManager
    
    var body: some View {
        
        VStack (spacing: 10) {
            Text("Concede This Game")
                .font(.title)
            Text("Game Winner will be: \(manager.getConcedeGameWinnerText())")
            if !manager.shouldConcedeGame() {
                Text("The scores appear too close to concede the game")
                    .font(.caption)
                    .foregroundColor(Color(.pomegranate))
                Text("Concede Anyway?")
            }
            HStack (spacing: 30) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .padding(.vertical, 20)
                .buttonStyle(SmallButtonStyle())
                Button {
                    print("Concede button tapped")
                    manager.concedeGame()
                    $manager.match.isDisabledConcedeBtn.wrappedValue = true
                    dismiss()
                } label: {
                    Text("Concede")
                }
                .padding(.vertical, 10)
                .buttonStyle(SmallButtonStyle())
            }
        }
        .padding(30)
        .presentationDetents([.fraction(0.40)])
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.brown), lineWidth: 1)
        )
        .padding(20)
    }
}

struct ConcedeGamePopover_Previews: PreviewProvider {
    static var previews: some View {
        ConcedeGamePopover()
    }
}
