//
//  MeldCardView.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import SwiftUI

struct MeldCardView: View {
    var body: some View {
        
        if ScorerSingleton.shared.isIPhone == true {
            VStack {
                HStack {
                    Image("oceanapinochle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.racinggreen), lineWidth: 2))
                    Spacer()
                    VStack {
                        Text("The 'Cheat' Sheet")
                            .padding(.top, 5)
                            .font(.title2)
                    }
                    Spacer()
                    Image("pinochle72")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.racinggreen), lineWidth: 2))
                }
                .padding(.bottom, 5)
                .padding(.horizontal, 10)
                
                ScrollView {
                    Image("meld_card")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 350, height: 640)
                
                Spacer()
            }  // End Top VStack
            .padding(10)
            .foregroundColor(Color(.racinggreen))
        } else {
            VStack {
                HStack {
                    Image("oceanapinochle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.racinggreen), lineWidth: 2))
                    Spacer()
                    VStack {
                        Text("The 'Cheat' Sheet")
                            .padding(.top, 5)
                            .font(.largeTitle)
                    }
                    Spacer()
                    Image("pinochle72")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.racinggreen), lineWidth: 2))
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    Image("meld_card")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 400, height: 940)
                
                Spacer()
            }  // End Top VStack
            .padding(30)
            .foregroundColor(Color(.racinggreen))
        }
        
    }
}


//struct MeldCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeldCardView()
//    }
//}
