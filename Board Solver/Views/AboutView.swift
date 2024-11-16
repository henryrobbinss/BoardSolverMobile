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
    
    var body: some View {
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
                            .frame(width: 80, height: 40)
                            .cornerRadius(15)
                            .overlay(Group {
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
                
                // Title text for the About page
                Text("About The BOARD SOLVER Project")
                    .font(.custom("PatrickHandSC-Regular", size: 40))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                
                // Scrollable text containing the project description
                ScrollView {
                    Text("Do you ever get stuck trying to decide on your next move in a board game? Board Solver Mobile (BSM), aims to be your assistant for strategic board games. Leveraging the power of computer vision, BSM analyzes game states through your iOS device's camera and suggests the next optimal move based on pre-trained algorithms.\n\tBSM currently supports the popular game of Connect4, with hopes to support more games in the future. For each game, BSM considers various factors like piece placement, potential threats, and strategic goals to recommend the move with the highest chance of success. The difficulty level of the solver currently only returns the best move, but we plan to make the difficulty of the opponent adjustable, allowing you to test your skills against a range of challenges.\n\tThis project is a great tool for both casual and experienced board game players. Whether you're looking for a helping hand to improve your game or simply want to explore different strategic options, BSM can be your guide to becoming a board game champion!")
                        .font(.custom("PatrickHandSC-Regular", size: 20))
                        .foregroundColor(Color.black)
                        .monospacedDigit()
                }
                .padding()
                
                // HStack containing the GitHub link
                HStack {
                    Image("github-mark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                    
                    // Link to the project's GitHub repository
                    Link("Visit our GitHub!", destination: URL(string: "https://github.com/henryrobbinss/BoardSolverMobile")!)
                }
            }
        }
    }
}
    
    // Preview provider for SwiftUI previews
#Preview {
    AboutView()
}

