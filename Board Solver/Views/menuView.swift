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
                    Spacer()
                    // Display the title text.
                    VStack {
                        Text("BOARD")
                            .font(.custom("PatrickHandSC-Regular", size: 90))
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .offset(y: 30)
                        Text("SOLVER")
                            .font(.custom("PatrickHandSC-Regular", size: 90))
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Display the main image below the title.
                    Image("image1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 230)
                        .offset(y: -60)
                    
                    // Display a prompt to select a game.
                    Text("Select a Game Below")
                        .font(.custom("PatrickHandSC-Regular", size: 30))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .offset(y: -60)
                    
                    // Navigation link to the "Four In A Row" game menu.
                    NavigationLink
                    {
                        FourInARowMenuView().navigationBarTitle("").navigationBarHidden(true)
                    } label:
                    {
                        Rectangle()
                            .fill(.yellow)
                            .frame(width: 300, height: 80)
                            .cornerRadius(15.0)
                            .overlay(Group{
                                Text("4 In-A-Row")
                                    .font(.custom("PatrickHandSC-Regular", size: 60))
                                    .foregroundStyle(.red)
                                RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.black, lineWidth: 5)
                                })
                    }
                    .offset(y: -60)
                    
                    // Navigation link to the "Word Scramble" game menu.
                    NavigationLink
                    {
                        WordScrambleMenuView().navigationBarTitle("").navigationBarHidden(true)
                    } label:
                    {
                        Rectangle()
                            .fill(.red)
                            .frame(width: 300, height: 80)
                            .cornerRadius(15.0)
                            .overlay(Group{
                                Text("Scramble")
                                    .font(.custom("PatrickHandSC-Regular", size: 60))
                                    .foregroundStyle(.white)
                                RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.black, lineWidth: 5)
                                })
                    }
                    .offset(y: -50)
                    
                    // Navigation link to the "About" view.
                    NavigationLink
                    {
                        AboutView().navigationBarTitle("").navigationBarHidden(true)
                    } label:
                    {
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 150, height: 80)
                            .cornerRadius(15)
                            .overlay(Group{
                                Text("About")
                                    .font(.custom("PatrickHandSC-Regular", size: 50))
                                    .foregroundStyle(.white)
                                RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.black, lineWidth: 5)
                                })
                    }
                    .offset(y: -40)
                }
            }
        }
    }
}

#Preview {
    MenuView()
}
