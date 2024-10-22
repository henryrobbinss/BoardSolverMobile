//
//  MenuView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/12/24.
//
//  This view represents the main menu of the Board Solver app, providing navigation to different game modes and infomation.


// Todo: found a bug on iPhone SE (3rd generation, iOS 17.5), where some elements are overflow with the screen boundary. Trying to make it adaptive. (Attached the behavour on OverflowBug.png)


import SwiftUI

// The main menu view for the Board Solver app.
struct MenuView: View {
    var body: some View {
        NavigationStack {
            GeometryReader {geometry in
                ZStack {
                    // Background: set to white, covering the entire screen.
                    Color.white
                        .ignoresSafeArea()

                    VStack (spacing: geometry.size.height * 0.02) {
                        // Calculate the fond size based on screen width
                        let titleFontSize = geometry.size.width * 0.15
                        
                        // Display the title text.
                        VStack(spacing: 0) {
                            Text("BOARD")
                                .font(.custom("KoHo-Medium", size: titleFontSize))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.5)
                            Text("SOLVER")
                                .font(.custom("KoHo-Medium", size: titleFontSize))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.5)
                        }
                        .padding(.top, geometry.size.height * 0.05)

                        // Display the main image below the title.
                        Image("image1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.8)
                            .offset(y: -geometry.size.height * 0.02)

                        // Display a prompt to select a game.
                        Text("Select a Game Below")
                            .font(.custom("KoHo-Medium", size: geometry.size.width * 0.07))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, geometry.size.height * 0.01)
                            .minimumScaleFactor(0.5)

                        // Navigation links
                        VStack(spacing: geometry.size.height * 0.015) {
                            // Navigation link to the "Four In A Row" game menu.
                            NavigationLink(destination: FourInARowMenuView()
                                .toolbar(.hidden, for: .navigationBar)) {
                                Image("fourinarow_prompt")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width * 0.6)
                            }

                            // Navigation link to the "Word Scramble" game menu.
                            NavigationLink(destination: WordScrambleMenuView()
                                .toolbar(.hidden, for: .navigationBar)) {
                                Image("scribble_prompt")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width * 0.6)
                            }

                            // Navigation link to the "About" view.
                            NavigationLink(destination: AboutView()
                                .toolbar(.hidden, for: .navigationBar)) {
                                Image("about_prompt")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width * 0.6)
                            }
                        }
                        .padding(.bottom, geometry.size.height * 0.05)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
    }
}

#Preview {
    MenuView()
}
