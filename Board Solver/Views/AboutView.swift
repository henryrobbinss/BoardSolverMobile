//
//  AboutView.swift
//  Board Solver
//
//  Created by Henry Robbins on 7/16/24.
//

import SwiftUI

struct AboutView: View {
    
    // Environment variable to handle view dismissal
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            // Calculate scaling factors based on iPhone 13 Pro Max dimensions
            let baseWidth: CGFloat = 428
            let baseHeight: CGFloat = 926
            let scaleFactor = min(geometry.size.width / baseWidth, geometry.size.height / baseHeight)
            
            ZStack {
                // Set background color to white and ignore safe area
                Color.white.ignoresSafeArea(.all)
                
                VStack {
                    HStack {
                        // Back button to dismiss the view
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
                        .padding(.bottom, 20 * scaleFactor)
                        
                        Spacer()
                    }
                    
                    // Title text for the About page
                    Text("About The BOARD SOLVER Project")
                        .font(.custom("PatrickHandSC-Regular", size: 40 * scaleFactor))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .padding(.horizontal, 20 * scaleFactor)
                    
                    // Scrollable text containing the project description
                    ScrollView {
                        Text("Do you ever get stuck trying to decide on your next move in a board game? Board Solver Mobile (BSM), aims to be your assistant for strategic board games. Leveraging the power of computer vision, BSM analyzes game states through your iOS device's camera and suggests the next optimal move based on pre-trained algorithms.\n\tBSM currently supports the popular game of Connect4, with hopes to support more games in the future. For each game, BSM considers various factors like piece placement, potential threats, and strategic goals to recommend the move with the highest chance of success. The difficulty level of the solver currently only returns the best move, but we plan to make the difficulty of the opponent adjustable, allowing you to test your skills against a range of challenges.\n\tThis project is a great tool for both casual and experienced board game players. Whether you're looking for a helping hand to improve your game or simply want to explore different strategic options, BSM can be your guide to becoming a board game champion!")
                            .font(.custom("PatrickHandSC-Regular", size: 20 * scaleFactor))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .monospacedDigit()
                            .padding(.horizontal, 20 * scaleFactor)
                    }
                    .padding(.vertical, 20 * scaleFactor)
                    
                    // HStack containing the GitHub link
                    HStack {
                        Image("github-mark")
                            .resizable()
                            .frame(width: 20 * scaleFactor, height: 20 * scaleFactor)
                            .scaledToFit()
                        
                        Link("Visit our GitHub!",
                             destination: URL(string: "https://github.com/henryrobbinss/BoardSolverMobile")!)
                            .font(.custom("PatrickHandSC-Regular", size: 18 * scaleFactor))
                    }
                    .padding(.bottom, 35 * scaleFactor)
                }
                .background(colorScheme == .dark ? Color.black : Color.white)
                // Center the VStack within the GeometryReader
                .frame(width: geometry.size.width, height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AboutView()
}
