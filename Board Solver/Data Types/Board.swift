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
}
