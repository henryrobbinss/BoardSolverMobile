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
    
    static func convertBoard(results: [VNRecognizedObjectObservation], width: CGFloat, height: CGFloat)
    {
        struct piece{
            var label: String
            var midx: CGFloat
            var midy: CGFloat
        }
        let board: [[Cell]] = Array(repeating: Array(repeating: Cell(), count: 7), count: 6)

        
        // Assuming 0,0 is top left
        var topBoard: CGFloat = 0
        var bottomBoard: CGFloat = height
        var leftBoard: CGFloat = width
        var rightBoard: CGFloat = 0
        
        // pieces array
        var pieces: [piece] = []
        
        for r in results{
            let x1 = r.boundingBox.minX*width
            let y1 = r.boundingBox.maxX*height
            
            let x2 = r.boundingBox.maxX*width
            let y2 = r.boundingBox.minY*height
            
            leftBoard = min(x1, leftBoard)
            rightBoard = max(x2, rightBoard)
            topBoard = max(y1, topBoard)
            bottomBoard = min(y2, bottomBoard)
            
            let p = piece(label: r.labels[0].identifier, midx: r.boundingBox.midX*width, midy: r.boundingBox.midY*height)
            pieces.append(p)
        }
        
        let bwidth = rightBoard - leftBoard
        let bheight = topBoard - bottomBoard
        let columns = [(bwidth/14)+leftBoard, (bwidth/14 + bwidth/7)+leftBoard,
                       (width/14 + 2*width/7)+leftBoard, (width/14 + 3*width/7)+leftBoard,
                       (width/14 + 4*width/7)+leftBoard, (width/14 + 5*width/7)+leftBoard,
                       (width/14 + 6*width/7)+leftBoard]
        
        let rows = [(bwidth/12)+bottomBoard, (bwidth/12 + bheight/6)+bottomBoard,
                    (bwidth/12 + 2*bheight/6)+bottomBoard, (bwidth/12 + 3*bheight/6)+bottomBoard,
                    (bwidth/12 + 4*bheight/6)+bottomBoard, (bwidth/12 + 5*bheight/6)+bottomBoard]
        
        for p in pieces{
            let rowsLength = rows.count
            let row = rows.enumerated().min(by: { abs($0.element - p.midy) < abs($1.element - p.midy) })?.offset ?? rowsLength

            let columnsLength = columns.count
            let col = columns.enumerated().min(by: { abs($0.element - p.midx) < abs($1.element - p.midx) })?.offset ?? columnsLength
            
            if(p.label == "Red Piece"){
                board[row][col].type = 0
            } else if (p.label == "Yellow Piece"){
                board[row][col].type = 1
            } else {
                board[row][col].type = 2
            }
        }
        
        for row in board {
          for cell in row {
            print(cell.type, terminator: " ")
          }
          print()
        }
    }
}
