//
//  ScratchPadSheet.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/10/22.
//

import SwiftUI

struct ScratchPadSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var numberText = ""
    @State private var resultsText = "0"
    @State private var tapeText = ""
    @State private var totalNumber = 0
    
    var body: some View {
        
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
                    Text("Scratch Pad")
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
            .padding(.horizontal, 20)
            .padding(.top, 30)
            
            VStack {
                HStack {
                    VStack  {
                        VStack {
                            HStack {
                                Spacer()
                                Text(tapeText)
                                    .font(.system(size: 48))
                                    .lineLimit(2, reservesSpace: true)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(Color(.tan))
                                    .frame(height: 25)
                            }
                            .padding(.vertical, 25)
                        }
                        .padding(.trailing, 100)
                        
                        VStack {
                            HStack {
                                Text("Total: ")
                                    .font(.system(size: 48))
                                    .foregroundColor(Color(.racinggreen))
                                Spacer()
                                Text(resultsText)
                                    .font(.system(size: 60))
                                    .foregroundColor(Color(.racinggreen))
                            }
                            .padding(.horizontal, 20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(.racinggreen), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 75)
                        
                        HStack {
                            
                            VStack (spacing: 20) {
                                
                                HStack (spacing: 20) {
                                    Button {
                                        numberBtnTapped(tag: 7)
                                    } label: {
                                        Image("button7")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        numberBtnTapped(tag: 8)
                                    } label: {
                                        Image("button8")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        numberBtnTapped(tag: 9)
                                    } label: {
                                        Image("button9")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        plusBtnTapped()
                                    } label: {
                                        Image("button+green")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                }
                                HStack (spacing: 20) {
                                    Button {
                                        numberBtnTapped(tag: 4)
                                    } label: {
                                        Image("button4")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        numberBtnTapped(tag: 5)
                                    } label: {
                                        Image("button5")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        numberBtnTapped(tag: 6)
                                    } label: {
                                        Image("button6")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        backBtnTapped()
                                    } label: {
                                        Image("button<green")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                }
                                HStack (spacing: 20) {
                                    Button {
                                        numberBtnTapped(tag: 1)
                                    } label: {
                                        Image("button1")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        numberBtnTapped(tag: 2)
                                    } label: {
                                        Image("button2")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        numberBtnTapped(tag: 3)
                                    } label: {
                                        Image("button3")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        equalsBtnTapped()
                                    } label: {
                                        Image("buttonequals")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                }
                                HStack (spacing: 20) {
                                    Button {
                                        
                                    } label: {
                                        Image("boxblank")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        numberBtnTapped(tag: 0)
                                    } label: {
                                        Image("button0")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        
                                    } label: {
                                        Image("boxblank")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                    Button {
                                        clearBtnTapped()
                                    } label: {
                                        Image("buttoncgreen")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.racinggreen), lineWidth: 3)
                )
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                
                Spacer()
            }
            .padding(.top, 10)
            
            Button {
                dismiss()
            } label: {
                Text("Close")
            }
            .padding(.bottom, 20)
            .buttonStyle(SmallButtonStyle())
            
            Text("Tapping + Button Shows Current Total")
                .padding(.bottom, 10)
                .font(.callout)
            
        } // End Top VStack
        .padding(30)
        .foregroundColor(Color(.racinggreen))
    }
    
    //MARK: - Functions Section
    
    func backBtnTapped() {
        if tapeText != "0" && tapeText.count > 0 {
            tapeText = String(tapeText.dropLast())
            numberText = String(numberText.dropLast())
            print("     > > > > tapeText after dropping last character: \(tapeText)")
            print("     > > > > numberText after dropping last character: \(numberText)")
        }
    }
    
    func clearBtnTapped() {
        totalNumber = 0
        resultsText = "0"
        tapeText = ""
    }
    
    func numberBtnTapped(tag: Int) {
        
        tapeText = tapeText + String(tag)
        numberText = numberText + String(tag)
    }
    
    func plusBtnTapped() {
        tapeText = tapeText + "+"
        if !numberText.isEmpty {
            resultsText = String(totalNumber + Int(numberText)!)
            totalNumber = Int(resultsText)!
        } else {
            resultsText = String(totalNumber)
        }
        numberText = ""
    }
    
    func equalsBtnTapped() {
        if !numberText.isEmpty {
            resultsText = String(totalNumber + Int(numberText)!)
            totalNumber = Int(resultsText)!
        } else {
            resultsText = String(totalNumber)
        }
        numberText = ""
    }
    
}



//struct ScratchPadSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        ScratchPadSheet()
//    }
//}
