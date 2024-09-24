//
//  ScrambleBoardView.swift
//  Board Solver
//
//  Created by Henry Robbins on 9/24/24.
//

import SwiftUI

struct ScrambleBoardView: View {
var body: some View {
        ZStack {
            // Corner overlays
            GeometryReader { geometry in
                let SIDE_BUF = 50.0
                let LEN = geometry.size.width - SIDE_BUF * 2.0
                let TOP_BUF = (geometry.size.height - LEN) / 2.0
                ZStack {
                    // Top Left Corner (L shape facing inside)
                    LShape()
                        .frame(width: 30, height: 30)
                        .position(x: SIDE_BUF, y: TOP_BUF)
                    
                    // Top Right Corner (L shape rotated 90 degrees)
                    LShape()
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(90))
                        .position(x: SIDE_BUF + LEN, y: TOP_BUF)
                    
                    // Bottom Left Corner (L shape rotated 270 degrees)
                    LShape()
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(270))
                        .position(x: SIDE_BUF, y: TOP_BUF + LEN)
                    
                    // Bottom Right Corner (L shape rotated 180 degrees)
                    LShape()
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(180))
                        .position(x: SIDE_BUF + LEN, y: TOP_BUF + LEN)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LShape: View {
    var body: some View {
        ZStack {
            // Vertical leg along the box edge
            Rectangle()
                .frame(width: 5, height: 30)
                .offset(x: -12.5) // Moves the leg to the inside edge of the box
            
            // Horizontal leg along the box edge
            Rectangle()
                .frame(width: 30, height: 5)
                .offset(y: -12.5) // Moves the leg to the inside edge of the box
        }
    }
}

#Preview {
    ScrambleBoardView()
}
