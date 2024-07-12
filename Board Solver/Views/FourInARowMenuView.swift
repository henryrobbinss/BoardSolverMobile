//
//  MenuView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/12/24.
//

import SwiftUI

struct FourInARowMenuView: View
{
    // Disable animation transitions
    init()
    {
            UINavigationBar.setAnimationsEnabled(false)
    }
    
    // This is parent view for FourInARow, so pass down state...
    @State var isStarting: Bool = true
    @State var isActive: Bool = false
    @State var board = Array(repeating: Array(repeating: 2, count: 7), count: 6)
    @State var playerColor: Int = -1
    @State var resultsBoard = Array(repeating: Array(repeating: 2, count: 7), count: 6)
    
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
                        ContentView(classifier: ImageClassifier(), boardView: BoardView(board: $board), playerColor: 1, board: $board, resultsBoard: resultsBoard).navigationBarTitle("")
                            .navigationBarHidden(true)
                    } label: {
                        Label("", image: "yellow_prompt")
                    }
                    
                    NavigationLink
                    {
                        //ContentView(classifier: ImageClassifier(), boardView: BoardView(board: $board), playerColor: 0, board: $board, resultsBoard: resultsBoard).navigationBarTitle("")
                            //.navigationBarHidden(true)
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
