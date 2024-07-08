//
//  splashScreen.swift
//  Board Solver
//
//  Created by Henry Robbins on 6/14/24.
//

import SwiftUI



struct splashScreen: View {
    // This is parent view, so pass down state...
    @State var isActive: Bool = false
    var board = Array(repeating: Array(repeating: 2, count: 7), count: 6)
    
    var body: some View {
        ZStack{
            if self.isActive 
            {
                ContentView(classifier: ImageClassifier(), boardView: BoardView(board: board))
            } else {
                Rectangle()
                    .background(Color.white)
                Image("image1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
        .onAppear {
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
