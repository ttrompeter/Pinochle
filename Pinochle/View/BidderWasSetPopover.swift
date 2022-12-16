//
//  BidderWasSetPopover.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/6/22.
//

import SwiftUI

struct BidderWasSetPopover: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack (spacing: 10) {
            Image(systemName: "xmark")
                .foregroundColor(Color(.pomegranate))
            Text("Bidder Was Set")
                .font(.title)
            Text("Meld & Trick points do not equal the bid")
            Text("Scores have been adjusted accordingly")
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



//struct BidderWasSetPopover_Previews: PreviewProvider {
//    static var previews: some View {
//        BidderWasSetPopover()
//    }
//}
