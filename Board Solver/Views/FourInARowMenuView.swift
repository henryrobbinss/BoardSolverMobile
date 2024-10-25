//
//  FourInARowMenuView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/12/24.
//

import SwiftUI

struct FourInARowMenuView: View
{
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
    
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
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
                            Label("", image: "Back_prompt")
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
                    HStack
                    {
                        // Navigation link to BufferView with yellow as the first player
                        NavigationLink
                        {
                            BufferView(playerColor: $yellow, g: $game, letters: $letters)
                                .navigationBarTitle("") // Hide the navigation bar title
                                .navigationBarHidden(true) // Hide the navigation bar
                        } label: {
                            // Custom yellow button image
                            Label("", image: "yellow_prompt")
                        }
                        
                        // Navigation link to BufferView with red as the first player
                        NavigationLink
                        {
                            BufferView(playerColor: $red, g: $game, letters: $letters)
                                .navigationBarTitle("") // Hide the navigation bar title
                                .navigationBarHidden(true) // Hide the navigation bar
                        } label:
                        {
                            // Custom red button image
                            Label("", image: "red_prompt")
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        // Use stack navigation style for better compatibility across devices
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    FourInARowMenuView()
}
