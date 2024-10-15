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
                        .font(.custom("KoHo-Medium", size: 30))
                        .padding(.bottom, 5)
                        .foregroundColor(.black)
                    
                    Text("(type in a '?' for blanks)")
                        .font(.custom("KoHo-Medium", size: 15))
                        .foregroundColor(.gray)
                        .padding(.bottom, 50)
                    
                    // Letter input display (interactive text boxes)
                    HStack(spacing: 10) {
                        ForEach(0..<maxLetters, id: \.self) { index in
                            ZStack {
                                if index < letters.count {
                                    let letter = String(letters[letters.index(letters.startIndex, offsetBy: index)])
                                    Text(letter.uppercased())
                                        .font(.largeTitle)
                                        .frame(width: 40, height: 50)
                                        .foregroundColor(.black)
                                } else if index == letters.count{
                                    // Highlight the current input spot with a grey box
                                    Rectangle()
                                        .foregroundColor(Color.gray.opacity(0.2))
                                        .frame(width: 50, height: 60)
                                        .cornerRadius(4.0)
                                } else {
                                    // Empty box for remaining letters
                                    Text(" ")
                                        .frame(width: 40, height: 50)
                                }
                                // Underline
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(.gray)
                                    .frame(width: 40)
                                    .padding(.top, 35)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 30)
                    .overlay(
                        // Hidden TextField to capture input
                        TextField("", text: $letters)
                            .foregroundColor(.clear) // Make text invisible
                            .accentColor(.clear)      // Hide cursor
                            .keyboardType(.alphabet)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .onChange(of: letters) {
                                // Limit input to max number of letters
                                if letters.count > maxLetters {
                                    letters = String(letters.prefix(maxLetters))
                                }
                            }
                            .padding()
                    )
                    .onTapGesture {
                        // Bring up the keyboard when tapping the letter area
                        UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                    }
                    
                    Spacer()
                    NavigationLink
                    {
                        BufferView(playerColor: $pc, g: $game, letters: $letters)
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
