//
// Created for NumberKeyBoardentry
// by Stewart Lynch on 2022-12-16
// Using Swift 5.0
//

import Combine
import SwiftUI

/*
 This viewModifer will only allow numeric entry only so you can add this modifier to any
 textField and pass in the bound string so when on an iPad if you type anything
 but a number it will just be ignored.
 */

struct NumberOnlyViewModifier: ViewModifier {

    @Binding var text: String

    public init(text: Binding<String>) {
        self._text = text
    }

    public func body(content: Content) -> some View {
        content
            .keyboardType(.numberPad)
            .onReceive(Just(text)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    self.text = filtered
                }
            }
    }
}

extension View {
    func numbersOnly(_ text: Binding<String>) -> some View {
        print("text passed in  to numbersOnly: \(text)")
        return self.modifier(NumberOnlyViewModifier(text: text))
    }
}
