//
//  MenuView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/12/24.
//
//  This view represents the main menu of the Board Solver app, providing navigation to different game modes and infomation.

import SwiftUI

// The main menu view for the Board Solver app.
struct MenuView: View
{
    var body: some View
    {
        // Selection buttons
        NavigationView
        {
            ZStack
            {
                // Backgound: set to white, covering the entire screen.
                Color.white.ignoresSafeArea(.all)
                
                VStack
                {
                    // Display the title text.
                    VStack {
                        Text("BOARD")
                            .font(.custom("KoHo-Medium", size: 90))
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .monospacedDigit()
                        Text("SOLVER")
                            .font(.custom("KoHo-Medium", size: 90))
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .monospacedDigit()
                    }
                    
                    // Display the main image below the title.
                    Image("image1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 230)
                        .offset(y: -20)
                    
                    // Display a prompt to select a game.
                    Text("Select a Game Below")
                        .font(.custom("KoHo-Medium", size: 30))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                    
                    // Navigation link to the "Four In A Row" game menu.
                    NavigationLink
                    {
                        FourInARowMenuView().navigationBarTitle("").navigationBarHidden(true)
                    } label:
                    {
                        Label("", image: "fourinarow_prompt")
                    }
                    
                    // Navigation link to the "Word Scramble" game menu.
                    NavigationLink
                    {
                        WordScrambleMenuView().navigationBarTitle("").navigationBarHidden(true)
                    } label:
                    {
                        Label("", image: "scribble_prompt")
                    }
                    
                    // Navigation link to the "About" view.
                    NavigationLink
                    {
                        AboutView().navigationBarTitle("").navigationBarHidden(true)
                    } label:
                    {
                        Label("", image: "about_prompt")
                    }
                    //.offset(y: -90)
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MenuView()
}
