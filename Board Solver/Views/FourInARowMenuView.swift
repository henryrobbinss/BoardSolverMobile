//
//  MenuView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/12/24.
//

import SwiftUI

struct FourInARowMenuView: View
{
    @State var yellow: Int = 1
    @State var red: Int = 0
    // Disable animation transitions
    init()
    {
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View
    {
        NavigationView
        {
            // Navigation links
            ZStack
            {
                // Background
                Color.white.ignoresSafeArea(.all)
                
                VStack
                {
                    NavigationLink
                    {
                        FourInARowBufferView(playerColor: $yellow)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    } label: {
                        Label("", image: "yellow_prompt")
                    }
                    
                    NavigationLink
                    {
                        FourInARowBufferView(playerColor: $red)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    } label:
                    {
                        Label("", image: "red_prompt")
                    }
                }
            }
        }
    }
}

#Preview {
    MenuView()
}
