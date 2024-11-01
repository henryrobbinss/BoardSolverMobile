//
//  ScrambleBoardView.swift
//  Board Solver
//
//  Created by Henry Robbins on 9/24/24.
//

import SwiftUI

struct ScrambleBoardView: View {
    
    let rows = 15
    let columns = 15
    @Binding var board: [[Character]]
    
    // Grid colors corresponding to different tile types
    func colorForTile(row: Int, column: Int) -> Color {
        // Example color logic based on grid position
        if (row == 0 && (column == 0 || column == 7 || column == 14))
            || (row == 7 && (column == 0 || column == 14))
            || (row == 14 && (column == 0 || column == 7 || column == 14)){
            return .red // red tiles in corners
        } else if ((row == 0 || row == 7 || row == 14) && (column == 3 || column == 11))
                || ((row == 2 || row == 6 || row == 8 || row == 12) && (column == 6 || column == 8))
                || ((row == 3 || row == 11) && (column == 0 || column == 7 || column == 14))
                || ((row == 6 || row == 8) && (column == 2 || column == 6 || column == 8 || column == 12)){
            return Color.scrambleLb
        } else if (row == 23) {
            return .orange // other tiles
        } else if (((row == 1 || row == 5 || row == 9 || row == 13) && (column == 1 || column == 5 || column == 9 || column == 13)) && ((row != column && row != 14 - column) || (row == 5 || row == 9))){
            return .blue
        } else if (row == column || row == 14 - column) {
            return .orange
        } else {
            return .gray // default tiles
        }
    }
    
    var body: some View {
        VStack{
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
            .frame(maxWidth: 500, maxHeight: 400)
            
            
            ZStack {
                Rectangle()
                    .fill(Color.brown)
                    .frame(width: (15+4)*CGFloat(columns), height: (15+4)*CGFloat(rows))
                    .opacity(0.5)
                    .cornerRadius(15.0)
                VStack(spacing: 2) { // Vertical stack for rows
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 2) { // Horizontal stack for columns
                            ForEach(0..<columns, id: \.self) { column in
                                Rectangle()
                                    .fill(colorForTile(row: row, column: column))
                                    .frame(width: 15, height: 15)
                                    .cornerRadius(2.0)
                                    .opacity(0.75)
                                    
                                    .overlay(Group {
                                        Text(board[row][column] == "*" ? "" : String(board[row][column]))
                                    })
                            }
                        }
                    }
                }
                .padding()
            }
            .offset(y: -100)
        }
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
    @Previewable @State var tempBoard: [[Character]] = Array(repeating: Array(repeating: Character("*"), count: 15), count: 15)
    ScrambleBoardView(board: $tempBoard)
}
