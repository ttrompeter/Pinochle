//
//  ContentView.swift
//  Pinochle
//
//  Created by Tom Trompeter on 12/16/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresented = false
    
    var body: some View {
        VStack (spacing: 30) {
            Text("Learning Git")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
