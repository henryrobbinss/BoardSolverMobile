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
                        FourInARowMenuView().navigationBarTitle("").navigationBarHidden(true)
                    } label:
                    {
                        Label("", image: "scribble_prompt")
                    }
                    
                }
            }
        }
    }
}

#Preview {
    MenuView()
}
