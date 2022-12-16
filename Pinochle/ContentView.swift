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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Gaday, Pinochlers")
            
            Button("Show Model") {
                isPresented = true
            }
            .sheet(isPresented: $isPresented) {
                Text("Model Screen")
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
