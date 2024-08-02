//
//  MenuView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/12/24.
//

import SwiftUI

struct FourInARowMenuView: View
{
    @Environment(\.dismiss) private var dismiss
    @State var yellow: Int = 1
    @State var red: Int = 0
    @State var game = "four"
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
                
                
                VStack {
                    
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
                    
                    Text("Please Select Which\nColor Went First")
                        .font(.custom("KoHo-Medium", size: 20))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .monospaced()
                        .scaledToFit()
                
                    HStack
                    {
                        NavigationLink
                        {
                            BufferView(playerColor: $yellow, g: $game)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                        } label: {
                            Label("", image: "yellow_prompt")
                        }
                        
                        NavigationLink
                        {
                            BufferView(playerColor: $red, g: $game)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                        } label:
                        {
                            Label("", image: "red_prompt")
                        }
                    }
                    Spacer()
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    FourInARowMenuView()
}
