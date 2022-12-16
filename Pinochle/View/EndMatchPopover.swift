//
//  EndMatchPopover.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/13/22.
//

import SwiftUI

struct EndMatchPopover: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: PinochleManager
    
    var body: some View {
        
        VStack (spacing: 10) {
            Text("End Match")
                .font(.title)
            Text("Match Will Be Closed")
            Text("THIS CANNOT BE UNDONE")
                .padding(.vertical, 10)
                .font(.headline)
                .foregroundColor(Color(.pomegranate))
            HStack (spacing: 30) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(SmallButtonStyle())
                Button {
                    manager.endMatch()
                    dismiss()
                } label: {
                    Text("End Match")
                }
                .buttonStyle(SmallButtonStyle())
            }
            .padding(.vertical, 15)
        }
        .padding(40)
        .presentationDetents([.fraction(0.40)])
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.brown), lineWidth: 1)
        )
        .padding(20)
    }
}


//struct EndMatchPopover_Previews: PreviewProvider {
//    static var previews: some View {
//        EndMatchPopover()
//    }
//}
