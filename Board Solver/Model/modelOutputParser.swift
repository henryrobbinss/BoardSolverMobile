//
//  modelOutputParser.swift
//  Board Solver
//
//  Created by Henry Robbins on 6/18/24.
//

import Foundation

// Ensure a board is found
// Go through all bounding boxes class names and postions
//  1. get bounding box coordinates
//  2. get class name of each
//  3. continue below to fil in the board

//            width = board_dims[2] - board_dims[0]
//            height = board_dims[3] - board_dims[1]
//
//            # may need to edit these value if mirroring is an issue on non webcam cameras
//            columns = [int(width/14)+board_dims[0], int(width/14 + width/7)+board_dims[0],
//                        int(width/14 + 2*width/7)+board_dims[0], int(width/14 + 3*width/7)+board_dims[0],
//                        int(width/14 + 4*width/7)+board_dims[0], int(width/14 + 5*width/7)+board_dims[0],
//                        int(width/14 + 6*width/7)+board_dims[0]]
//            
//            rows = [int(height/12) + board_dims[1], int(height/12 + height/6) + board_dims[1],
//                    int(height/12 + 2*height/6) + board_dims[1], int(height/12 + 3*height/6) + board_dims[1],
//                    int(height/12 + 4*height/6) + board_dims[1], int(height/12 + 5*height/6) + board_dims[1]]
//
//            for piece in pieces:
//                mid_x = int((piece[3] - piece[1]) / 2) + piece[1]
//                mid_y = int((piece[4] - piece[2]) / 2) + piece[2]
//
//                row = min(range(len(rows)), key = lambda i: abs(rows[i]-mid_y))
//                col = min(range(len(columns)), key = lambda i: abs(columns[i]-mid_x))
//
//                if piece[0] == "Red Piece":
//                    board[row, col] = 1
//                else:
//                    board[row, col] = -1
