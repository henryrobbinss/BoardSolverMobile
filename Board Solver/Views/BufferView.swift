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
    @State var fResultsBoard = Array(repeating: Array(repeating: 2, count: 7), count: 6)
    @State var sResultsBoard = Array(repeating: Array(repeating: Character("*"), count: 7), count: 6)
    @Binding var g: String
    @Binding var letters: String
    @Binding var fastSolver: Bool
    
    var body: some View {
        SolverView(Classifier: ImageClassifier(), FBoardView: BoardView(board: $board), playerColor: playerColor, FBoard: $board, SBoard: $sBoard, FResultsBoard: fResultsBoard, SResultsBoard: sResultsBoard, game: $g, letters: $letters, fastSolver : $fastSolver)
    }
}
