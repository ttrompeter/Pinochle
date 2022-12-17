//
//  CustomKeyPad.swift
//  CustomIntegerPad
//
//  Created by Tom Trompeter on 12/15/22.
//

import SwiftUI

struct CustomKeyPad: View {
    
    @EnvironmentObject var manager: PinochleManager
    @Binding var string: String
    @Binding var show: Bool
    let updateCallback: () -> ()
    let updateMessage: () -> ()
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(Color(.clouds))
                .cornerRadius(10)
                .shadow(radius: 5)
            
            VStack (spacing: 9) {
                VStack (spacing: 7) {
                    HStack (spacing: 5) {
                        KeyPadButton(key: "7")
                        KeyPadButton(key: "8")
                        KeyPadButton(key: "9")
                    }
                    HStack {
                        KeyPadButton(key: "4")
                        KeyPadButton(key: "5")
                        KeyPadButton(key: "6")
                    }
                    HStack {
                        KeyPadButton(key: "1")
                        KeyPadButton(key: "2")
                        KeyPadButton(key: "3")
                    }
                    HStack {
                        KeyPadButton(key: "Clr")
                        KeyPadButton(key: "0")
                        KeyPadButton(key: "⌫")
                    }
                }
                
                HStack {
                    Button {
                        //updateCallback()  TRT Change
                        show = false
                        manager.forceViewUpdate = 1917
                    } label: {
                        Text("Close")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white).cornerRadius(5)
                }
            }
            .environment(\.keyPadButtonAction, self.keyWasPressed(_:))
        }
        
    }
    
    private func keyWasPressed (_ key: String) {
        switch key {
            case "Clr":
                string = ""
            case "⌫":
                if string.isEmpty {
                    string = "0"
                } else {
                    string.removeLast()
                }
            case _ where string == "0": string = key
            default:
                string += key
        }
        show = true
        manager.forceViewUpdate = 1234
        updateMessage()
    }
}


struct KeyPadButton: View {
    let key: String
    
    var body: some View {
        Button {
            self.action(self.key)
        } label: {
            VStack (spacing: 0) {
                Text(key)
                    .font(key == "⌫" ? .system(size: 28): .system(size: 25))
                    .foregroundColor(.black)
            }
            .frame(width: 80.0, height: 38.0)
            .background(RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 0, y: 0)
                .mask(Rectangle().padding(.bottom, -1))
            )
        }
    }
    
    enum ActionKey: EnvironmentKey {
        static var defaultValue: (String) -> Void { { _ in } }
    }
    @Environment(\.keyPadButtonAction) var action: (String) -> Void
}


extension EnvironmentValues {
    var keyPadButtonAction: (String) -> Void {
        get  {
            self[KeyPadButton.ActionKey.self]
        }
        set {
            self[KeyPadButton.ActionKey.self] = newValue
        }
    }
}

//struct KeyPadConstants {
//    static let KEYPAD_WIDTH = 361.0
//    static let KEYPAD_HEIGHT = 274.0
//    static let KEYPAD_DONE_WIDTH = 284.0
//    static let KEYPAD_DONE_HEIGHT = 38.0
//    static let KEYPAD_BUTTON_WIDTH = 80.0
//    static let KEYPAD_BUTTON_HEIGHT = 46.0
//    static let KEYPAD_HEIGHT_WITH_DONE_BUTTON = KEYPAD_HEIGHT + KEYPAD_DONE_HEIGHT + 20.0
//}

