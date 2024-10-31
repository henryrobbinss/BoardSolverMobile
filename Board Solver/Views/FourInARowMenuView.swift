//
//  FourInARowMenuView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/12/24.
//

import SwiftUI

struct FourInARowMenuView: View {
    // Environment variable to handle view dismissal
    @Environment(\.dismiss) private var dismiss
    
    // State variables to manage game settings
    @State var yellow: Int = 1
    @State var red: Int = 0
    @State var game = "four"
    @State var letters: String = ""
    
    // Disable animation transitions for the navigation bar
    init(){
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Set the background color to white and ignore safe area edges
                Color.white.ignoresSafeArea(.all)
                
                VStack {
                    // Top bar with a back button
                    HStack {
                        Button {
                            // Dismiss the current view
                            dismiss()
                        } label: {
                            // Custom back button image
                            Image("Back_prompt")
                        }
                        .padding()
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Instructional text for the user
                    Text("Please Select Which\nColor Went First")
                        .font(.custom("KoHo-Medium", size: 20))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .monospaced()
                        .scaledToFit()
                
                    // Buttons for selecting the first player color
                    HStack {
                        // Navigation link to BufferView with yellow as the first player
                        NavigationLink {
                            BufferView(playerColor: $yellow, g: $game, letters: $letters)
                                .toolbar(.hidden, for: .navigationBar)
                        } label: {
                            // Custom yellow button image
                            Image("yellow_prompt")
                        }
                        
                        // Navigation link to BufferView with red as the first player
                        NavigationLink {
                            BufferView(playerColor: $red, g: $game, letters: $letters)
                                .toolbar(.hidden, for: .navigationBar)
                        } label: {
                            // Custom red button image
                            Image("red_prompt")
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    FourInARowMenuView()
}
