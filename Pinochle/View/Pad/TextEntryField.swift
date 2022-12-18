//
//  MeldEntryField.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 11/7/22.
//

import SwiftUI

struct TextEntryField: View {

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
                    .frame(width:60, height: 30)
                    .keyboardType(.numberPad)
                    .numbersOnly($field)
            }
            .padding(1)
            .background(Color(.clouds))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.tan), lineWidth: 0.5))
            
        }
    }
}

//struct MeldEntryField_Previews: PreviewProvider {
//    static var previews: some View {
//        MeldEntryField()
//    }
//}
