//
//  TextEntryFieldPhone.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/13/22.
//

import SwiftUI

struct TextEntryFieldPhone: View {
    
    @Environment(\.isEnabled) private var isEnabled
    @EnvironmentObject var manager: PinochleManager
    var placeholder: String
    var prompt: String
    @Binding var field: String
    var body: some View {
        
        VStack (alignment: .leading) {
            HStack {
                TextField(placeholder, text: $field)
                    .foregroundColor(isEnabled ? Color(.racinggreen) : Color(.slate))
                    .opacity(isEnabled ? 1.0 : 0.6)
                    .frame(width:40, height: 20)
                    .keyboardType(.numberPad)
            }
            .padding(1)
            .background(Color(.clouds))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.tan), lineWidth: 0.5))
        }
    }
}


//struct TextEntryFieldPhone_Previews: PreviewProvider {
//    static var previews: some View {
//        TextEntryFieldPhone()
//    }
//}
