//
//  Board.swift
//  Board Solver
//
//  Created by Alex Mattoni on 6/25/24.
//

import Foundation
import Vision
import SwiftUI

class Board
{
    // Fill board from results
    static func fillBoard(results: [VNRecognizedObjectObservation], width: CGFloat, height: CGFloat) -> UIImage
    {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        // Go through every result
        return renderer.image
        {
            context in let cgContext = context.cgContext

            cgContext.setStrokeColor(UIColor.red.cgColor)
            cgContext.setLineWidth(2)
            
            for box in results
            {
                let rect = CGRect(x: box.boundingBox.minX, y: box.boundingBox.minY, width: box.boundingBox.width, height: box.boundingBox.height)
                cgContext.stroke(rect)
            }
        }
    }
    
    static func convertBoard(results: [VNRecognizedObjectObservation], width: CGFloat, height: CGFloat, playerColor: Int) -> [[Int]]
    {
        struct piece{
            var label: String
            var midx: CGFloat
            var midy: CGFloat
        }
        var board: [[Int]] = Array(repeating: Array(repeating: 2, count: 7), count: 6)
        
        // Assuming 0,0 is top left
        var topBoard: CGFloat = height
        var bottomBoard: CGFloat = 0
        var leftBoard: CGFloat = width
        var rightBoard: CGFloat = 0
        
        // pieces array
        var pieces: [piece] = []
        
        for r in results{
            if r.labels[0].confidence < 0.75{
                continue
            }
            let x1 = r.boundingBox.minX*width
            let y1 = r.boundingBox.minY*height
            
            let x2 = r.boundingBox.maxX*width
            let y2 = r.boundingBox.maxY*height
            
            leftBoard = min(x1, leftBoard)
            rightBoard = max(x2, rightBoard)
            topBoard = min(y1, topBoard)
            bottomBoard = max(y2, bottomBoard)
            
            let p = piece(label: r.labels[0].identifier, midx: r.boundingBox.midX*width, midy: r.boundingBox.midY*height)
            pieces.append(p)
        }
        
        let bwidth = rightBoard - leftBoard
        let bheight = topBoard - bottomBoard
        let columns = [(bwidth/14)+leftBoard, (bwidth/14 + bwidth/7)+leftBoard,
                       (bwidth/14 + 2*bwidth/7)+leftBoard, (bwidth/14 + 3*bwidth/7)+leftBoard,
                       (bwidth/14 + 4*bwidth/7)+leftBoard, (bwidth/14 + 5*bwidth/7)+leftBoard,
                       (bwidth/14 + 6*bwidth/7)+leftBoard]
        
        let rows = [(bheight/12)+bottomBoard, (bheight/12 + bheight/6)+bottomBoard,
                    (bheight/12 + 2*bheight/6)+bottomBoard, (bheight/12 + 3*bheight/6)+bottomBoard,
                    (bheight/12 + 4*bheight/6)+bottomBoard, (bheight/12 + 5*bheight/6)+bottomBoard]
        
        for p in pieces{
            let rowsLength = rows.count
            let row = rows.enumerated().min(by: { abs($0.element - p.midy) < abs($1.element - p.midy) })?.offset ?? rowsLength

            let columnsLength = columns.count
            let col = columns.enumerated().min(by: { abs($0.element - p.midx) < abs($1.element - p.midx) })?.offset ?? columnsLength
            
            if(p.label == "Red Piece"){
                board[row][col] = 0
            } else if (p.label == "Yellow Piece"){
                board[row][col] = 1
            }
        }
        
        return board
    }
    
    static func convertSBoard(results: [VNRecognizedObjectObservation], width: CGFloat, height: CGFloat) -> [[Character]]
    {
        struct piece{
            var label: String
            var midx: CGFloat
            var midy: CGFloat
        }
        var board: [[Character]] = Array(repeating: Array(repeating: Character("*"), count: 15), count: 15)
        
        // Assuming 0,0 is top left
        var topBoard: CGFloat = height
        var bottomBoard: CGFloat = 0
        var leftBoard: CGFloat = width
        var rightBoard: CGFloat = 0
        var foundBoard = false
        
        // pieces array
        var pieces: [piece] = []
        
        for r in results {
            if r.labels[0].identifier == "board"{
                foundBoard = true
                topBoard = r.boundingBox.minY*height
                bottomBoard = r.boundingBox.maxY*height
                leftBoard = r.boundingBox.minX*width
                rightBoard = r.boundingBox.maxX*width
            }
        }
        
        for r in results{
            if r.labels[0].confidence < 0.75{
                continue
            }
            let x1 = r.boundingBox.minX*width
            let y1 = r.boundingBox.minY*height
            
            let x2 = r.boundingBox.maxX*width
            let y2 = r.boundingBox.maxY*height
            
            if !foundBoard{
                leftBoard = min(x1, leftBoard)
                rightBoard = max(x2, rightBoard)
                topBoard = min(y1, topBoard)
                bottomBoard = max(y2, bottomBoard)
            }
            
            let p = piece(label: r.labels[0].identifier, midx: r.boundingBox.midX*width, midy: r.boundingBox.midY*height)
            pieces.append(p)
        }
        
        let bwidth = rightBoard - leftBoard
        let bheight = topBoard - bottomBoard
        
        let columns = [(bwidth/30)+leftBoard, (bwidth/30 + bwidth/15)+leftBoard,
                       (bwidth/30 + 2*bwidth/15)+leftBoard, (bwidth/30 + 3*bwidth/15)+leftBoard,
                       (bwidth/30 + 4*bwidth/15)+leftBoard, (bwidth/30 + 5*bwidth/15)+leftBoard,
                       (bwidth/30 + 6*bwidth/15)+leftBoard, (bwidth/30 + 7*bwidth/15)+leftBoard,
                       (bwidth/30 + 8*bwidth/15)+leftBoard, (bwidth/30 + 9*bwidth/15)+leftBoard,
                       (bwidth/30 + 10*bwidth/15)+leftBoard, (bwidth/30 + 11*bwidth/15)+leftBoard,
                       (bwidth/30 + 12*bwidth/15)+leftBoard, (bwidth/30 + 13*bwidth/15)+leftBoard,
                       (bwidth/30 + 14*bwidth/15)+leftBoard]
        
        let rows = [(bheight/30)+bottomBoard, (bheight/30 + bheight/15)+bottomBoard,
                    (bheight/30 + 2*bheight/15)+bottomBoard, (bheight/30 + 3*bheight/15)+bottomBoard,
                    (bheight/30 + 4*bheight/15)+bottomBoard, (bheight/30 + 5*bheight/15)+bottomBoard,
                    (bheight/30 + 6*bheight/15)+bottomBoard, (bheight/30 + 7*bheight/15)+bottomBoard,
                    (bheight/30 + 8*bheight/15)+bottomBoard, (bheight/30 + 9*bheight/15)+bottomBoard,
                    (bheight/30 + 10*bheight/15)+bottomBoard, (bheight/30 + 11*bheight/15)+bottomBoard,
                    (bheight/30 + 12*bheight/15)+bottomBoard, (bheight/30 + 13*bheight/15)+bottomBoard,
                    (bheight/30 + 14*bheight/15)+bottomBoard]

        for p in pieces{
            let rowsLength = rows.count
            let row = rows.enumerated().min(by: { abs($0.element - p.midy) < abs($1.element - p.midy) })?.offset ?? rowsLength

            let columnsLength = columns.count
            let col = columns.enumerated().min(by: { abs($0.element - p.midx) < abs($1.element - p.midx) })?.offset ?? columnsLength
            
            if(p.label.count > 1){
                board[row][col] = Character("-")
            } else {
                board[row][col] = Character(p.label)
            }
        }
        
        for row in board {
            for col in row {
                print(col, terminator: " ")
            }
            print("")
        }
        
        return board
    }
    
    // Takes the detected board and the player's color and then generates a solution. Returns the solution
    // as a [[Int]], whereby the solution placement cell equals 3.
    public static func startSolving(board: [[Int]], playerColor: Int) -> [[Int]]
    {
        // Check for winner
        if checkForWinner(board: board) != nil {
            return board;
        }
        
        var board2 = board
        // clean up any current solved pieces and count the number of pieces
        var numPieces = 0;
        for i in 0..<board2.count{
            for j in 0..<board2[i].count {
                if board2[i][j] == 3{
                    board2[i][j] = 2
                }
                if board2[i][j] != 2{
                    numPieces+=1;
                }
            }
        }
        
        // *******************************************************************************
        // Current solver is below this line
        // DEPRACATED
        //        let solveString = getSolverString(board: board2, playerColor: playerColor)
        //        if(solveString == ""){
        //            board2[5][3] = 3
        //            return board2
        //        }
        //        let pos = Position()
        //        let solver = Solver()
        //        let _ = pos.play(seq: solveString)
        //        let colarray = solver.scoreAllMoves(P: pos)
        //        let col = colarray.firstIndex(of: colarray.max()!)!
        //        if colarray[col] == -999999{
        //            return board2
        //        }
        // *******************************************************************************
        
        // NOTES:
        // RED is 0, YELLOW is 1, EMPTY is 2

        //tell the AI which color it should play as
        let oppositePiece = 1 - playerColor;
        if(numPieces % 2 == 0){
            //the aiPiece is the piece the ai will try to make win
            setPlayerandAI(playerPiece: oppositePiece, aiPiece: playerColor)
        }
        else{
            setPlayerandAI(playerPiece: playerColor, aiPiece: oppositePiece)
        }
        
        //reverse the board because the FastSolver views it as reversed
        let reverse = Array(board2.reversed())
        let bestMove = getBestMove(board: reverse, piece: 0)
        let col = bestMove!//store the best move
        
        // Here should have col variable that is the column we want to play in
        // place in first open column
        for i in 0..<board2.count {
            if board2.reversed()[i][col] == 2{
                board2[5-i][col] = 3
                return board2
            }
        }
        return board2
    }
    
    private static func concatIntsToString(string: String, intArray: [Int]) -> String {
      var result = string
      for num in intArray {
        result += "\(num)"
      }
      return result
    }
    
    static func getSolverString(board: [[Int]], playerColor: Int) -> String {
        var flippedBoard = board
        flippedBoard.reverse()
        
        var pending: [Int] = []
        var conflict: [Int] = []
        var result = ""
        
            
        var first = "red"
        if(playerColor == 0)
        {
            first = "red"
        }
        else if(playerColor == 1)
        {
            first = "yellow"
        }
        else
        {
            return "epic fail"
        }
        
        var next = first
        // 0 - red, 1 - yellow, 2 - nothing
        let RED = 0, YELLOW = 1
        for row in flippedBoard {
            for i in 0..<row.count {
                if row[i] == 2 {
                    continue
                } else if row[i] == 3 {
                    continue
                }else if next == "red" && row[i] == RED {
                    if pending.contains(i + 1) {
                        conflict.append(i+1)
                        continue
                    }
                    result = result + String(i + 1)
                    if pending.count != 0{
                        result = result + String(pending[0])
                        pending.removeFirst()
                    } else if conflict.count != 0{
                        result = result + String(conflict[0])
                        conflict.removeFirst()
                    } else {
                        next = "yellow"
                    }
                } else if next == "yellow" && row[i] == YELLOW {
                    if pending.contains(i + 1) {
                        conflict.append(i+1)
                        continue
                    }
                    result = result + String(i + 1)
                    if pending.count != 0{
                        result = result + String(pending[0])
                        pending.removeFirst()
                    } else if conflict.count != 0{
                        result = result + String(conflict[0])
                        conflict.removeFirst()
                    }  else {
                        next = "red"
                    }
                } else {
                    pending.append(i+1)
                }
            }
        }
        while !(pending.isEmpty || conflict.isEmpty) {
            result = result + String(conflict[0])
            conflict.removeFirst()
            result = result + String(pending[0])
            pending.removeFirst()
        }
        result = concatIntsToString(string: result, intArray: conflict)
        return concatIntsToString(string: result, intArray: pending)
    }
    
    static func checkForWinner(board: [[Int]]) -> Int? {
        let rows = board.count
        let cols = board[0].count
        
        func checkDirection(row: Int, col: Int, dRow: Int, dCol: Int, player: Int) -> Bool {
            for i in 0..<4 {
                let r = row + i * dRow
                let c = col + i * dCol
                if r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != player {
                    return false
                }
            }
            return true
        }
        
        for row in 0..<rows {
            for col in 0..<cols {
                let player = board[row][col]
                if player == 2 { continue }  // Skip empty cells
                
                // Check horizontal, vertical, diagonal-right, diagonal-left
                if checkDirection(row: row, col: col, dRow: 0, dCol: 1, player: player) ||  // Horizontal
                    checkDirection(row: row, col: col, dRow: 1, dCol: 0, player: player) ||  // Vertical
                    checkDirection(row: row, col: col, dRow: 1, dCol: 1, player: player) ||  // Diagonal-right
                    checkDirection(row: row, col: col, dRow: 1, dCol: -1, player: player) {  // Diagonal-left
                    return player
                }
            }
        }
        
        return nil  // No winner
    }

}

