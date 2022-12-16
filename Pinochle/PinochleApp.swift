//
//  PinochleApp.swift
//  Pinochle
//
//  Created by Tom Trompeter on 12/16/22.
//

import SwiftUI

@main
struct PinochleApp: App {
    
    @StateObject var manager = PinochleManager()
    
    var body: some Scene {
        WindowGroup {
            if ScorerSingleton.shared.isIPhone == true {
                HomeViewPhone()
                    .environmentObject(manager)
                    .onAppear{
                        // Stop layout conflict messages
                        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    }
            } else {
                HomeView()
                    .environmentObject(manager)
                    .onAppear{
                        // Stop layout conflict messages
                        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    }
            }
        }
    }
}
