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
            Rectangle()                .foregroundColor(Color(.clouds))
                .frame(width: 270.0, height: 250.0)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            VStack {
                VStack (spacing: 5) {
                    HStack {
                        KeyPadButton(key: "1")
                        KeyPadButton(key: "2")
                        KeyPadButton(key: "3")
                    }
                    HStack {
                        KeyPadButton(key: "4")
                        KeyPadButton(key: "5")
                        KeyPadButton(key: "6")
                    }
                    HStack {
                        KeyPadButton(key: "7")
                        KeyPadButton(key: "8")
                        KeyPadButton(key: "9")
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
                        manager.forceViewUpdate = Int.random(in: 70001...77777777)
                    } label: {
                        Text("Close")
                            .font(.system(size: 25))
                            .foregroundColor(.primary)
                    }
                    .frame(width: 120, height: 36)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .fill(Color("softwhite"))
                        .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 0, y: 0)
                        .mask(Rectangle().padding(.bottom, -1))
                    )
                }
                .padding(.top, 15)
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
                    string = ""
                } else {
                    string.removeLast()
                }
            //case _ where string == "0": string = key
            default:
                string += key
        }
        show = true
        manager.forceViewUpdate = Int.random(in: 8001...888888)
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
                    .foregroundColor(.primary)
            }
            .frame(width: 72, height: 36)
            .background(RoundedRectangle(cornerRadius: 5)
                .fill(Color("softwhite"))
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

