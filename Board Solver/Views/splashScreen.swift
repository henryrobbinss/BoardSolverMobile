//
//  splashScreen.swift
//  Board Solver
//
//  Created by Henry Robbins on 6/14/24.
//

import SwiftUI



struct splashScreen: View 
{
    // This is parent view, so pass down state...
    @State var isStarting: Bool = true
    @State var isActive: Bool = false
    @State var board = Array(repeating: Array(repeating: 2, count: 7), count: 6)
    @State var playerColor: Int = -1
    
    var body: some View 
    {
            ZStack
            {
                if self.isActive
                {
                    if(isStarting == true)
                    {
                        ZStack{
                            
                            // Background
                            Rectangle()
                                .background(Color.white)
                            
                            // Selection buttons
                            VStack{
                                
                                
                                // Player is yellow
                                Button
                                {
                                    playerColor = 1
                                    isStarting = false
                                } label:
                                {
                                    Label("", image: "yellow_prompt")
                                }
                                .frame(maxWidth: 175)
                                
                                // Player is red
                                Button
                                {
                                    playerColor = 0
                                    isStarting = false
                                } label: 
                                {
                                    Label("", image: "red_prompt")
                                }
                                .frame(maxWidth: 175)
                            }
                        }
                    }
                    else
                    {
                        ContentView(classifier: ImageClassifier(), boardView: BoardView(board: $board), board: $board)
                    }
                } else {
                    Rectangle()
                        .background(Color.white)
                    Image("image1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
            }
            .onAppear 
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
}

#Preview {
    splashScreen()
}
