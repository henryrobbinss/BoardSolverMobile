//
//  FourInARowBufferView.swift
//  Board Solver
//
//  Created by Henry Robbins on 7/12/24.
//

import SwiftUI

struct BufferView: View {
    @Binding var playerColor: Int
    @State var board = Array(repeating: Array(repeating: 2, count: 7), count: 6)
    @State var sBoard: [[Character]] = Array(repeating: Array(repeating: Character("*"), count: 15), count: 15)
    @State var resultsBoard = Array(repeating: Array(repeating: 2, count: 7), count: 6)
    @Binding var g: String
    @Binding var letters: String
    
    var body: some View {
        SolverView(FClassifier: ImageClassifier(), FBoardView: BoardView(board: $board), playerColor: playerColor, FBoard: $board, SBoard: $sBoard, FResultsBoard: resultsBoard, game: $g, letters: $letters)
    }
}
