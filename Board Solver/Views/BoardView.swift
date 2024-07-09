//
//  BoardView.swift
//  Board Solver
//
//  Created by Henry Robbins on 6/18/24.
//

import SwiftUI

struct BoardView: View {
    @Binding var board: [[Int]]
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
                            if board[row][column] == 0{
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: holeSize, height: holeSize)
                                    .onTapGesture(){
                                        board[row][column] = (board[row][column] + 1) % 3
                                    }
                            } else if board[row][column] == 1{
                                Circle()
                                    .fill(Color.yellow)
                                    .frame(width: holeSize, height: holeSize)
                                    .onTapGesture(){
                                        board[row][column] = (board[row][column] + 1) % 3
                                    }
                            } else {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: holeSize, height: holeSize)
                                    .onTapGesture(){
                                        board[row][column] = (board[row][column] + 1) % 3
                                    }
                            }
                        }
                    }
                }
            }
        }.onChange(of: board) {}
        .padding(.bottom)
    }
    func updateBoard(brd: [[Int]]){
        board = brd
    }
}
