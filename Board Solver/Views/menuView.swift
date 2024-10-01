//
//  MenuView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/12/24.
//

import SwiftUI

struct MenuView: View 
{
    var body: some View
    {
        // Selection buttons
        NavigationView
        {
            ZStack
            {
                //Background
                Color.white.ignoresSafeArea(.all)
                
                VStack
                {
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
                    
                    Image("image1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 230)
                        .offset(y: -20)
                    
                    Text("Select a Game Below")
                        .font(.custom("KoHo-Medium", size: 30))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                    
                    // Four In A Row
                    NavigationLink
                    {
                        FourInARowMenuView().navigationBarTitle("").navigationBarHidden(true)
                    } label:
                    {
                        Label("", image: "fourinarow_prompt")
                    }
                    
                    // Word scramble
                    NavigationLink
                    {
                        WordScrambleMenuView().navigationBarTitle("").navigationBarHidden(true)
                    } label:
                    {
                        Label("", image: "scribble_prompt")
                    }
                    
                    // About
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
