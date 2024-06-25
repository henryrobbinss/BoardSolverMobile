//
//  Board.swift
//  Board Solver
//
//  Created by Alex Mattoni on 6/25/24.
//

import Foundation
import Vision

class Board
{
    // Members
    public var x: Double;
    public var y: Double;
    public var grid: [[Cell]]?;
    
    // Constructor
    init()
    {
        x = 0;
        y = 0;
    }
    
    // Fill board from results
    func fillBoard(results: [VNRecognizedObjectObservation])
    {
        // Go through every result
        for r in results
        {
            
        }
    }
}
