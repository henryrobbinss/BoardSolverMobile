//
//  WordScrambleMenuView.swift
//  Board Solver
//
//  Created by Henry Robbins on 7/16/24.
//

import SwiftUI

struct WordScrambleMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @State var pc = -1
    @State var game = "scramble"
    
    @State private var letters: String = ""
    let maxLetters = 7
    
    var body: some View {
        NavigationView {
            
            ZStack {
                //Background
                Color.white.ignoresSafeArea(.all)
                
                VStack {
                    // Back button and title
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Label("", image: "Back_prompt")
                        }
                        .padding()
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Main prompt text
                    Text("Please Type in Your Letters")
                        .font(.title2)
                        .padding(.bottom, 5)
                    
                    Text("(type in a '?' for blanks)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Letter input display (like the S A _)
                    HStack(spacing: 10) {
                        ForEach(0..<maxLetters, id: \.self) { index in
                            if index < letters.count {
                                let letter = String(letters[letters.index(letters.startIndex, offsetBy: index)])
                                Text(letter.uppercased())
                                    .font(.title)
                                    .padding(.horizontal, 8)
                                    .frame(width: 40, height: 50)
                                    .background(Color.clear)
                                    .overlay(Rectangle().frame(height: 2).foregroundColor(.gray), alignment: .bottom)
                            } else {
                                Text(" ")
                                    .frame(width: 40, height: 50)
                                    .background(Color.clear)
                                    .overlay(Rectangle().frame(height: 2).foregroundColor(.gray), alignment: .bottom)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    
                    Spacer()
                    
                    // TextField for input
                    TextField("Enter letters", text: $letters)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.alphabet)
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                        .onChange(of: letters) {
                            // Ensure the letters input doesn't exceed the max allowed
                            if letters.count > maxLetters {
                                letters = String(letters.prefix(maxLetters))
                            }
                        }
                    Spacer()
                    NavigationLink
                    {
                        BufferView(playerColor: $pc, g: $game)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    } label: {
                        Label("", image: "solve_prompt")
                    }
                }
            }
        }
    }
}

#Preview {
    WordScrambleMenuView()
}
