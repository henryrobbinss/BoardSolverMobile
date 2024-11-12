//
//  fastSolver.swift
//  Board Solver
//
//  Created by Akshat Prakash on 11/5/24.
//

import Foundation

let ROW_COUNT = 6
let COLUMN_COUNT = 7

let PLAYER = 0
let AI = 1

let EMPTY = 2
var PLAYER_PIECE = 0
var AI_PIECE = 1

let WINDOW_LENGTH = 4

func setPlayerandAI(playerPiece : Int, aiPiece : Int){
    PLAYER_PIECE = playerPiece
    AI_PIECE = aiPiece
}

func createBoard() -> [[Int]] {
    return Array(repeating: Array(repeating: EMPTY, count: COLUMN_COUNT), count: ROW_COUNT)
}

func dropPiece(board: inout [[Int]], row: Int, col: Int, piece: Int) {
    board[row][col] = piece
}

func isValidLocation(board: [[Int]], col: Int) -> Bool {
    return board[ROW_COUNT - 1][col] == EMPTY
}

func getNextOpenRow(board: [[Int]], col: Int) -> Int? {
    for r in 0..<ROW_COUNT {
        if board[r][col] == EMPTY {
            return r
        }
    }
    return nil
}

func printBoard(board: [[Int]]) {
    for row in board.reversed() {
        print(row)
    }
}

func winningMove(board: [[Int]], piece: Int) -> Bool {
    // Horizontal check
    for c in 0..<(COLUMN_COUNT - 3) {
        for r in 0..<ROW_COUNT {
            if board[r][c] == piece && board[r][c+1] == piece && board[r][c+2] == piece && board[r][c+3] == piece {
                return true
            }
        }
    }
    
    // Vertical check
    for c in 0..<COLUMN_COUNT {
        for r in 0..<(ROW_COUNT - 3) {
            if board[r][c] == piece && board[r+1][c] == piece && board[r+2][c] == piece && board[r+3][c] == piece {
                return true
            }
        }
    }
    
    // Positive diagonal check
    for c in 0..<(COLUMN_COUNT - 3) {
        for r in 0..<(ROW_COUNT - 3) {
            if board[r][c] == piece && board[r+1][c+1] == piece && board[r+2][c+2] == piece && board[r+3][c+3] == piece {
                return true
            }
        }
    }
    
    // Negative diagonal check
    for c in 0..<(COLUMN_COUNT - 3) {
        for r in 3..<ROW_COUNT {
            if board[r][c] == piece && board[r-1][c+1] == piece && board[r-2][c+2] == piece && board[r-3][c+3] == piece {
                return true
            }
        }
    }
    
    return false
}

func evaluateWindow(window: [Int], piece: Int) -> Int {
    var score = 0
    let oppPiece = (piece == AI_PIECE) ? PLAYER_PIECE : AI_PIECE
    
    if window.filter({ $0 == piece }).count == 4 {
        score += 100
    } else if window.filter({ $0 == piece }).count == 3 && window.filter({ $0 == EMPTY }).count == 1 {
        score += 5
    } else if window.filter({ $0 == piece }).count == 2 && window.filter({ $0 == EMPTY }).count == 2 {
        score += 2
    }
    
    if window.filter({ $0 == oppPiece }).count == 3 && window.filter({ $0 == EMPTY }).count == 1 {
        score -= 4
    }
    
    return score
}

func scorePosition(board: [[Int]], piece: Int) -> Int {
    var score = 0
    
    // Score center column
    let centerArray = board.map { $0[COLUMN_COUNT / 2] }
    let centerCount = centerArray.filter { $0 == piece }.count
    score += centerCount * 3
    
    // Score horizontal
    for r in 0..<ROW_COUNT {
        let rowArray = board[r]
        for c in 0..<(COLUMN_COUNT - 3) {
            let window = Array(rowArray[c..<(c + WINDOW_LENGTH)])
            score += evaluateWindow(window: window, piece: piece)
        }
    }
    
    // Score vertical
    for c in 0..<COLUMN_COUNT {
        let colArray = board.map { $0[c] }
        for r in 0..<(ROW_COUNT - 3) {
            let window = Array(colArray[r..<(r + WINDOW_LENGTH)])
            score += evaluateWindow(window: window, piece: piece)
        }
    }
    
    // Score positive diagonal
    for r in 0..<(ROW_COUNT - 3) {
        for c in 0..<(COLUMN_COUNT - 3) {
            let window = (0..<WINDOW_LENGTH).map { board[r + $0][c + $0] }
            score += evaluateWindow(window: window, piece: piece)
        }
    }
    
    // Score negative diagonal
    for r in 0..<(ROW_COUNT - 3) {
        for c in 0..<(COLUMN_COUNT - 3) {
            let window = (0..<WINDOW_LENGTH).map { board[r + 3 - $0][c + $0] }
            score += evaluateWindow(window: window, piece: piece)
        }
    }
    
    return score
}

func isTerminalNode(board: [[Int]]) -> Bool {
    return winningMove(board: board, piece: PLAYER_PIECE) || winningMove(board: board, piece: AI_PIECE) || getValidLocations(board: board).isEmpty
}

func getValidLocations(board: [[Int]]) -> [Int] {
    return (0..<COLUMN_COUNT).filter { isValidLocation(board: board, col: $0) }
}

func printAiChoice(){
    print("Finding the best move for" + String(AI_PIECE))
}

func minimax(board: [[Int]], depth: Int, alpha: Int, beta: Int, maximizingPlayer: Bool) -> (Int?, Int) {
    var alpha = alpha
    var beta = beta
    let validLocations = getValidLocations(board: board)
    let isTerminal = isTerminalNode(board: board)
   
    if depth == 0 || isTerminal {
        if isTerminal {
            if winningMove(board: board, piece: AI_PIECE) {
                return (nil, 100000000000000)
            } else if winningMove(board: board, piece: PLAYER_PIECE) {
                return (nil, -10000000000000)
            } else {
                return (nil, 0)
            }
        } else {
            return (nil, scorePosition(board: board, piece: AI_PIECE))
        }
    }
    
    if maximizingPlayer {
        var value = Int.min
        var column = validLocations.randomElement()
        
        for col in validLocations {
            if let row = getNextOpenRow(board: board, col: col) {
                var boardCopy = board
                dropPiece(board: &boardCopy, row: row, col: col, piece: AI_PIECE)
                let newScore = minimax(board: boardCopy, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: false).1
                if newScore > value {
                    value = newScore
                    column = col
                }
                alpha = max(alpha, value)
                if alpha >= beta {
                    break
                }
            }
        }
        return (column, value)
    } else {
        var value = Int.max
        var column = validLocations.randomElement()
        
        for col in validLocations {
            if let row = getNextOpenRow(board: board, col: col) {
                var boardCopy = board
                dropPiece(board: &boardCopy, row: row, col: col, piece: PLAYER_PIECE)
                let newScore = minimax(board: boardCopy, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: true).1
                if newScore < value {
                    value = newScore
                    column = col
                }
                beta = min(beta, value)
                if alpha >= beta {
                    break
                }
            }
        }
        return (column, value)
    }
}

func getBestMove(board: [[Int]], piece: Int) -> Int? {
    let maximizingPlayer = (piece == AI_PIECE)
    let bestMove = minimax(board: board, depth: 5, alpha: Int.min, beta: Int.max, maximizingPlayer: maximizingPlayer)
    return bestMove.0
}

//
//var board = createBoard()
//var gameOver = false
//var turn = 0
//print("Board created")
//
//
//board =         [[2, 2, 2, 2, 2, 2, 2],
//                 [2, 2, 2, 2, 2, 2, 2],
//                 [2, 2, 2, 2, 2, 2, 2],
//                 [2, 2, 2, 2, 0, 1, 2],
//                 [2, 2, 2, 2, 0, 1, 2],
//                 [2, 2, 2, 2, 0, 1, 2]]
//
//
//
//let reverse = Array(board.reversed())
//board = reverse
//
//
//
//printBoard(board:board)
//let bestMove = getBestMove(board: board, piece: AI_PIECE)
//
//if let move = bestMove {
//    let bestMoveColumn = move
//    print("Best move is: \(bestMoveColumn)")
//} else {
//    print("No valid move available.")
//}

//
//printBoard(board: board)
//print("reversing")
//let reverse = Array(board.reversed())
//printBoard(board: reverse)
//board = reverse
//
//
//while true {
//    // Player's turn
//    print("Enter the column (0-\(COLUMN_COUNT - 1)) where you want to drop your piece:")
//    if let input = readLine(), let playerCol = Int(input), playerCol >= 0, playerCol < COLUMN_COUNT {
//        if let playerRow = getNextOpenRow(board: board, col: playerCol) {
//            dropPiece(board: &board, row: playerRow, col: playerCol, piece: PLAYER_PIECE)
//            print("Player dropped piece in column \(playerCol)")
//            printBoard(board: board)
//
//            if winningMove(board: board, piece: PLAYER_PIECE) {
//                print("Player wins!")
//                break
//            }
//
//            // AI's turn
//            let aiMove = minimax(board: board, depth: 5, alpha: Int.min, beta: Int.max, maximizingPlayer: true)
//            if let aiCol = aiMove.0, let aiRow = getNextOpenRow(board: board, col: aiCol) {
//                dropPiece(board: &board, row: aiRow, col: aiCol, piece: AI_PIECE)
//                print("AI dropped piece in column \(aiCol)")
//                printBoard(board: board)
//
//                if winningMove(board: board, piece: AI_PIECE) {
//                    print("AI wins!")
//                    break
//                }
//            }
//        }
//    }
//}
