//
//  InvalidMeldPopover.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/6/22.
//

import SwiftUI

struct InvalidMeldPopover: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack (spacing: 10) {
            Image(systemName: "xmark")
                .foregroundColor(Color(.pomegranate))
            Text("Invalid Meld Entry")
                .font(.title)
            Text("Must be a positive number")
            Text("No letters or other characters allowed")
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


//struct InvalidMeldPopover_Previews: PreviewProvider {
//    static var previews: some View {
//        InvalidMeldPopover()
//    }
//}
