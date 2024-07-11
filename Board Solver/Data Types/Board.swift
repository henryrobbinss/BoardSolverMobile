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
    // Members
    public var x: Double;
    public var y: Double;
    public static var grid: [[Cell]]?;
    public static var image: Image?;
    
    // Constructor
    init()
    {
        x = 0;
        y = 0;
    }
    
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
        
        let solveString = getSolverString(board: board, playerColor: playerColor)
        if solveString == ""{
            return board
        }
        print("\(solveString)")
        let pos = Position()
        let solver = Solver()
        let _ = pos.play(seq: solveString)
        let colarray = solver.scoreAllMoves(P: pos)
        let col = colarray.firstIndex(of: colarray.max()!)!
        if colarray[col] == -999999{
            return board
        }
        for row in board.reversed() {
            if row[col] == 2{
                board[board.firstIndex(of: row)!][col] = 3
                break
            }
        }
        
        return board
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
                } else if next == "red" && row[i] == RED {
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
        return concatIntsToString(string: result, intArray: pending)
    }
}
