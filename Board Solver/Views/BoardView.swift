//
//  BoardView.swift
//  Board Solver
//
//  Created by Henry Robbins on 6/18/24.
//

import SwiftUI

struct BoardView: View {
    let rows = 6
    let columns = 7
    let holeSize: CGFloat = 40
    let spacing = 5.0
    //include array of colors to output the board onto the screen
    
    var body: some View {
        ZStack {
            // Board background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(width: CGFloat(columns) * holeSize + 40, height: CGFloat(rows) * holeSize + 40)
            
            // Grid of holes
            VStack(spacing: spacing) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<columns, id: \.self) { column in
                            Circle()
                                .fill(Color.white)
                                .frame(width: holeSize, height: holeSize)
                        }
                    }
                }
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    BoardView()
}
