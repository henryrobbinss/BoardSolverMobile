//
//  MenuView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/12/24.
//

import SwiftUI

struct FourInARowMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @State var yellow: Int = 1
    @State var red: Int = 0
    @State var game = "four"
    @State var letters: String = ""
    
    // Disable animation transitions
    init() {
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // Calculate scaling factors based on iPhone 13 Pro Max dimensions
                let baseWidth: CGFloat = 428
                let baseHeight: CGFloat = 926
                let scaleFactor = min(geometry.size.width / baseWidth, geometry.size.height / baseHeight)

                ZStack {
                    // Set the background color to white and ignore safe area edges
                    Color.white.ignoresSafeArea(.all)
                    
                    VStack {
                        // Back button
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Rectangle()
                                    .fill(.gray)
                                    .frame(width: 80 * scaleFactor, height: 40 * scaleFactor)
                                    .cornerRadius(15 * scaleFactor)
                                    .overlay(Group {
                                        Text("BACK")
                                            .font(.custom("PatrickHandSC-Regular", size: 25 * scaleFactor))
                                            .foregroundStyle(.white)
                                        RoundedRectangle(cornerRadius: 15 * scaleFactor)
                                            .stroke(Color.black, lineWidth: 2.5 * scaleFactor)
                                    })
                            }
                            .padding(.leading, 15 * scaleFactor)
                            .padding(.top, 63 * scaleFactor)

                            Spacer()
                        }
                        
                        Spacer()
                        
                        // Title text
                        Text("Please Select Which\nColor Went First")
                            .font(.custom("PatrickHandSC-Regular", size: 40 * scaleFactor))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 50 * scaleFactor)
                        
                        // Buttons for selecting the first player color
                        HStack(spacing: 20 * scaleFactor) {
                            // Yellow button
                            NavigationLink {
                                BufferView(playerColor: $yellow, g: $game, letters: $letters)
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                            } label: {
                                Rectangle()
                                    .fill(.yellow)
                                    .frame(width: 150 * scaleFactor, height: 75 * scaleFactor)
                                    .cornerRadius(15 * scaleFactor)
                                    .overlay(Group {
                                        Text("YELLOW")
                                            .font(.custom("PatrickHandSC-Regular", size: 40 * scaleFactor))
                                            .foregroundStyle(.white)
                                        RoundedRectangle(cornerRadius: 15 * scaleFactor)
                                            .stroke(Color.black, lineWidth: 5 * scaleFactor)
                                    })
                            }
                            
                            // Red button
                            NavigationLink {
                                BufferView(playerColor: $red, g: $game, letters: $letters)
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                            } label: {
                                Rectangle()
                                    .fill(.red)
                                    .frame(width: 150 * scaleFactor, height: 75 * scaleFactor)
                                    .cornerRadius(15 * scaleFactor)
                                    .overlay(Group {
                                        Text("RED")
                                            .font(.custom("PatrickHandSC-Regular", size: 40 * scaleFactor))
                                            .foregroundStyle(.white)
                                        RoundedRectangle(cornerRadius: 15 * scaleFactor)
                                            .stroke(Color.black, lineWidth: 5 * scaleFactor)
                                    })
                            }
                        }
                        
                        Spacer()
                    }
                    // Center the VStack within the GeometryReader
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    FourInARowMenuView()
}
