//
//  WordScrambleMenuView.swift
//  Board Solver
//
//  Created by Henry Robbins on 7/16/24.
//

import SwiftUI

// View for the Word Scramble menu
struct WordScrambleMenuView: View {
    // Environment variable to dismiss the view
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var pc = -1
    @State var game = "scramble"
    // State variable to hold the user's letter input
    @State private var letters: String = ""
    
    // Maximum number of letters allowed
    let maxLetters = 7
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // Calculate scaling factors based on iPhone 13 Pro Max dimensions
                let baseWidth: CGFloat = 428
                let baseHeight: CGFloat = 926
                let scaleFactor = min(geometry.size.width / baseWidth, geometry.size.height / baseHeight) 
                
                ZStack {
                    // Background color
                    Color.white.ignoresSafeArea(.all)
                    
                    VStack {
                        // Back button
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Rectangle()
                                    .fill(.gray)
                                    .frame(width: 80 * scaleFactor, height: 40 * scaleFactor)
                                    .cornerRadius(15 * scaleFactor)
                                    .overlay(Group {
                                        Text("BACK")
                                            .font(.custom("PatrickHandSC-Regular", size: 25 * scaleFactor))
                                            .foregroundStyle(.white)
                                        RoundedRectangle(cornerRadius: 15 * scaleFactor)
                                            .stroke(Color.black, lineWidth: 2.5 * scaleFactor)
                                    })
                            }
                            .padding(.leading, 15 * scaleFactor)
                            .padding(.top, 63 * scaleFactor)
                            .padding(.bottom, 20 * scaleFactor)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        // Main prompt text
                        Text("please type in your letters")
                            .font(.custom("PatrickHandSC-Regular", size: 30 * scaleFactor))
                            .padding(.bottom, 5 * scaleFactor)
                            .foregroundColor(colorScheme == .dark ? .white : .black)

                        Text("(type in a '?' for blanks)")
                            .font(.custom("PatrickHandSC-Regular", size: 15 * scaleFactor))
                            .foregroundColor(.gray)
                            .padding(.bottom, 50 * scaleFactor)
                        
                        // Letter input display
                        HStack(spacing: 10 * scaleFactor) {
                            ForEach(0..<maxLetters, id: \.self) { index in
                                ZStack {
                                    if index < letters.count {
                                        // Display the entered letter at the current index
                                        let letter = String(letters[letters.index(letters.startIndex, offsetBy: index)])
                                        Text(letter.uppercased())
                                            .font(.system(size: 40 * scaleFactor))
                                            .frame(width: 40 * scaleFactor, height: 50 * scaleFactor)
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                    } else if index == letters.count {
                                        // Highlight the current input spot with a grey box
                                        Rectangle()
                                            .foregroundColor(Color.gray.opacity(0.2))
                                            .frame(width: 50 * scaleFactor, height: 60 * scaleFactor)
                                            .cornerRadius(4.0 * scaleFactor)
                                    } else {
                                        // Empty box for remaining letters
                                        Text(" ")
                                            .frame(width: 40 * scaleFactor, height: 50 * scaleFactor)
                                    }
                                    // Underline for each letter box
                                    Rectangle()
                                        .frame(height: 2 * scaleFactor)
                                        .foregroundColor(.gray)
                                        .frame(width: 40 * scaleFactor)
                                        .padding(.top, 35 * scaleFactor)
                                }
                            }
                        }
                        .padding(.vertical, 20 * scaleFactor)
                        .padding(.horizontal, 30 * scaleFactor)
                        .overlay(
                            // Hidden TextField to capture input
                            TextField("", text: $letters)
                                .foregroundColor(.clear)  // Make text invisible
                                .accentColor(.clear)      // Hide cursor
                                .keyboardType(.alphabet)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .onChange(of: letters) {
                                    // Limit input to maximum number of letters
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
                        
                        // Navigation link to proceed to the next view
                        NavigationLink {
                            BufferView(playerColor: $pc, g: $game, letters: $letters)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                        } label: {
                            // "NEXT" button
                            Rectangle()
                                .fill(.orange)
                                .frame(width: 180 * scaleFactor, height: 75 * scaleFactor)
                                .cornerRadius(15 * scaleFactor)
                                .overlay(Group {
                                    Text("NEXT")
                                        .font(.custom("PatrickHandSC-Regular", size: 50 * scaleFactor))
                                        .foregroundStyle(.white)
                                    RoundedRectangle(cornerRadius: 15 * scaleFactor)
                                        .stroke(Color.black, lineWidth: 5 * scaleFactor)
                                })
                        }
                        .padding(.bottom, 35 * scaleFactor)
                    }
                    // Center the VStack within the GeometryReader
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }.ignoresSafeArea()
        }
    }
}

#Preview {
    WordScrambleMenuView()
}
