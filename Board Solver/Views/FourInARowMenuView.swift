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
                    
                    Text("Please Select Which \n Color Went First")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .monospaced()
                        .scaledToFit()
                
                    HStack
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
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    FourInARowMenuView()
}
