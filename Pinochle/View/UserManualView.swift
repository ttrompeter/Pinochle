//
//  UserManualView.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import PDFKit
import SwiftUI

struct UserManualView: View {
    
    let pdfDoc: PDFDocument
    
    init() {
        pdfDoc = PDFDocument(url: Bundle.main.url(forResource: "pinochleUserManual", withExtension: "pdf")!)!
    }
    
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
                        Text("Pinochle Scorer User Manual")
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
                
                VStack {
                    PDFKitView(showing: pdfDoc)
                }
                
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
                        Text("Pinochle Scorer User Manual")
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
                
                VStack {
                    PDFKitView(showing: pdfDoc)
                }
                
                //Spacer()
            }  // End Top VStack
            .padding(30)
            .foregroundColor(Color(.racinggreen))
        }
    }
}

