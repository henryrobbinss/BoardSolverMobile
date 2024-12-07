//
//  MenuView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/12/24.
//
//  This view represents the main menu of the Board Solver app, providing navigation to different game modes and infomation.

import SwiftUI

struct MenuView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // Base sizes as per iPhone 13 Pro Max
                let baseWidth: CGFloat = 428
                let baseHeight: CGFloat = 926
                
                // Scaling factors based on device size relative to iPhone 13 Pro Max
                let widthScalingFactor = geometry.size.width / baseWidth
                let heightScalingFactor = geometry.size.height / baseHeight
                // Use the minimum scaling factor to prevent overflow
                let scalingFactor = min(widthScalingFactor, heightScalingFactor)
                
                VStack {
                    Spacer()
                    // Display the title text.
                    VStack(spacing: 0) {
                        Text("BOARD")
                            .font(.custom("PatrickHandSC-Regular", size: 90 * scalingFactor))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, -30 * scalingFactor)
                        Text("SOLVER")
                            .font(.custom("PatrickHandSC-Regular", size: 90 * scalingFactor))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 1 * scalingFactor)
                    
                    // Display the main image below the title.
                    Image("MenuViewLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300 * scalingFactor, height: 230 * scalingFactor)
                    
                    // Display a prompt to select a game.
                    Text("Select a Game Below")
                        .font(.custom("PatrickHandSC-Regular", size: 30 * scalingFactor))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20 * scalingFactor)
                    
                    // Navigation link to the "Four In A Row" game menu.
                    NavigationLink(destination: FourInARowMenuView()
                        .toolbar(.hidden, for: .navigationBar)) {
                            Rectangle()
                                .fill(.yellow)
                                .frame(width: 300 * scalingFactor, height: 80 * scalingFactor)
                                .cornerRadius(15.0 * scalingFactor)
                                .overlay(Group {
                                    Text("4 In-A-Row")
                                        .font(.custom("PatrickHandSC-Regular", size: 60 * scalingFactor))
                                        .foregroundStyle(.red)
                                    RoundedRectangle(cornerRadius: 15 * scalingFactor)
                                        .stroke(Color.black, lineWidth: 5 * scalingFactor)
                                })
                        }
                        .padding(.bottom, 10 * scalingFactor)
                    
                    // Navigation link to the "Word Scramble" game menu.
                    NavigationLink(destination: WordScrambleMenuView()
                        .toolbar(.hidden, for: .navigationBar)) {
                            Rectangle()
                                .fill(.red)
                                .frame(width: 300 * scalingFactor, height: 80 * scalingFactor)
                                .cornerRadius(15.0 * scalingFactor)
                                .overlay(Group {
                                    Text("Scramble")
                                        .font(.custom("PatrickHandSC-Regular", size: 60 * scalingFactor))
                                        .foregroundStyle(.white)
                                    RoundedRectangle(cornerRadius: 15 * scalingFactor)
                                        .stroke(Color.black, lineWidth: 5 * scalingFactor)
                                })
                        }
                        .padding(.bottom, 10 * scalingFactor)
                    
                    // Navigation link to the "About" view.
                    NavigationLink(destination: AboutView()
                        .toolbar(.hidden, for: .navigationBar)) {
                            Rectangle()
                                .fill(.gray)
                                .frame(width: 150 * scalingFactor, height: 80 * scalingFactor)
                                .cornerRadius(15 * scalingFactor)
                                .overlay(Group {
                                    Text("About")
                                        .font(.custom("PatrickHandSC-Regular", size: 50 * scalingFactor))
                                        .foregroundStyle(.white)
                                    RoundedRectangle(cornerRadius: 15 * scalingFactor)
                                        .stroke(Color.black, lineWidth: 5 * scalingFactor)
                                })
                        }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(colorScheme == .dark ? Color.black : Color.white)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MenuView()
}
