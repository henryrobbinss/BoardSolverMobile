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
    @State var letters: String = ""
    // Disable animation transitions
    init()
    {
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Set the background color to white and ignore safe area edges
                Color.white.ignoresSafeArea(.all)
                
                
                VStack {
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Rectangle()
                                .fill(.gray)
                                .frame(width: 80, height: 40)
                                .cornerRadius(15)
                                .overlay(Group{
                                    Text("BACK")
                                        .font(.custom("PatrickHandSC-Regular", size: 25))
                                        .foregroundStyle(.white)
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.black, lineWidth: 2.5)
                                    })
                        }
                        .padding()
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Custom back button
                    Text("Please Select Which\nColor Went First")
                        .font(.custom("PatrickHandSC-Regular", size: 40))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    // Buttons for selecting the first player color
                    HStack
                    {
                        // Navigation link to BufferView with yellow as the first player
                        NavigationLink
                        {
                            BufferView(playerColor: $yellow, g: $game, letters: $letters)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                        } label: {
                            // Custom yellow button
                            Rectangle()
                                .fill(.yellow)
                                .frame(width: 150, height: 75)
                                .cornerRadius(15)
                                .overlay(Group{
                                    Text("YELLOW")
                                        .font(.custom("PatrickHandSC-Regular", size: 40))
                                        .foregroundStyle(.white)
                                    RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.black, lineWidth: 5)
                                    })
                        }
                        
                        NavigationLink
                        {
                            BufferView(playerColor: $red, g: $game, letters: $letters)
                                .navigationBarTitle("")// Hide the navigation bar title
                                .navigationBarHidden(true) // Hide the navigation bar
                        } label:
                        {
                            Rectangle()
                                .fill(.red)
                                .frame(width: 150, height: 75)
                                .cornerRadius(15)
                                .overlay(Group{
                                    Text("RED")
                                        .font(.custom("PatrickHandSC-Regular", size: 40))
                                        .foregroundStyle(.white)
                                    RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.black, lineWidth: 5)
                                    })
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
