//
//  FourInARowBufferView.swift
//  Board Solver
//
//  Created by Henry Robbins on 7/12/24.
//

import SwiftUI

struct FourInARowBufferView: View {
    @Binding var playerColor: Int
    @State var board = Array(repeating: Array(repeating: 2, count: 7), count: 6)
    @State var resultsBoard = Array(repeating: Array(repeating: 2, count: 7), count: 6)
    
    var body: some View {
        FourInARowView(classifier: ImageClassifier(), boardView: BoardView(board: $board), playerColor: playerColor, board: $board, resultsBoard: resultsBoard)
    }
}
