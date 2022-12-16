//
//  MisdealPopover.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/12/22.
//

import SwiftUI

struct MisdealPopover: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: PinochleManager
    
    var body: some View {
        
        VStack (spacing: 10) {
            Text("Mis-Deal")
                .font(.title)
            Text("Stop this hand and start a new hand?")
            HStack (spacing: 30) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(SmallButtonStyle())
                Button {
                    print("Misdeal button tapped")
                    manager.applyMisdeal()
                    dismiss()
                } label: {
                    Text("Confirm")
                }
                .buttonStyle(PhoneButtonStyle())
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


//struct MisdealPopover_Previews: PreviewProvider {
//    static var previews: some View {
//        MisdealPopover()
//    }
//}
