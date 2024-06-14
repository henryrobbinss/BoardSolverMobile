// This is here because VSCode cant handle automatic imports for swift, so this is every solver file in one

import Foundation;
func getTimeMicrosec() -> CUnsignedLongLong {
    let NOW = Date().timeIntervalSince1970;
    return CUnsignedLongLong(NOW * 1_000_000)   
}

func main() {
    var solver : Solver;
    var line : String;
    var l : Int = 1;
    while(true) {
        line = readLine() ?? "";
        if (line == "quit") {
            break;
        }
        var P : Position;
        if (P.play(seq:line) != line.count) {
            print("Line << " + l + ": Invalid move " + (P.nbMoves() + 1) + " \"" + line);
        } else {
            var start_time : CUnsignedLongLong = getTimeMicrosec();
            var score : Int = solver.solve(P:P);
            var end_time : CUnsignedLongLong = getTimeMicrosec();
            print(line + " " + score + " " + solver.getNodeCount() + " " + (end_time - start_time));
        }
        l += 1;
    }
}

public class Position {
    static let WIDTH = 7; // Width of the board
    static let HEIGHT = 6; // Height of the board
    private var board : [[Int]] = Array(repeating: Array(repeating: 0, count: HEIGHT), count: WIDTH); // 0 if cell is empty, 1 for first player and 2 for second player.
    private var height: [Int] = [WIDTH]; // number of stones per column
     private var moves: UInt; // number of moves played since the beinning of the game.

    // Checks if the given column is full
    func canPlay(col : Int) -> Bool {
        return height[col] < Position.HEIGHT;
    }

    // Plays a given column
    func play(col : Int) {
        board[col][height[col]] = Int(1 + moves % 2);
        height[col] += 1;
        moves += 1;
    }

    // Plays a series of moves at once
    // Stops processing at invalid move
    func play(seq : String) -> CUnsignedInt {
        for i : Int in 0...seq.count-1 {
            var col : CUnsignedInt = seq[i].asciiValue - 1;
            if(col < 0 || col >= WIDTH || !canPlay(col) || isWinningMove(col)) {
                return i;
            }
            play(col);
        }
        return seq.count;
    }

    func isWinningMove(col: Int) -> Bool {
        var current_player : Int = 1 + moves % 2;
        // Check for vertical alignments
        if(height[col] >= 3
        && board[col][height[col]-1] == current_player
        && board[col][height[col]-2] == current_player
        && board[col][height[col]-3] == current_player) {
            return true;
        }
        for dy in -1...1 { // Iterate on horizontal (dy = 0) or two diagonal directions (dy = -1 or dy = 1)
            var nb : Int = 0; // counter of the number of stones of current player surrounding the played stone in tested direction
            for dx in stride(from: -1, through: 1, by: 2) { // count continuous stones of current player on the left, then right of the played column.
                var x : Int = col + dx
                var y : Int = height[col] + dx * dy
                while (x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT && board[x][y] == current_player) {
                    x += dx;
                    y += dx*dy;
                    nb += 1   
                }
            }
            if (nb >= 3) {
                return true;
                // there is an aligment if at least 3 other stones of the current user 
                // are surronding the played stone in the tested direction.
            }
        }
        return false;
    }
    func nbMoves() -> UInt {
        return moves;    
    }
    init() {
        self.board = Array(repeating: Array(repeating: 0, count: HEIGHT), count: WIDTH);
        self.height = Array(repeating:0, count: WIDTH);
        self.moves = 0;
    }
}

public class Solver {
    private var nodeCount : CLongLong = 0; // counter of explored nodes

    // Recursive solve of a negamax min-max algorithm
    // 0 is drawn game
    // Positive score if you can win whatever your opponent is playing. Your score is
    // The number of moves before the end you can win (faster win is higher score)
    // Negative score if your opponent can force you to lose. Your score is the opposite
    // of the number of moves before the end you will lose (faster loss is lower score)
    func negamax(p : Position) -> Int {
        nodeCount += 1; // Increment counter of explored nodes
        if (P.nbMoves() == Position.WIDTH*Position.HEIGHT) { // Check for drawn game
            return 0;
        }
        for x : Int in 0...Position.Width-1 { // Check i current player can win next move
            if(P.canPlay(x) && P.isWinningMove(x)) {
                return (Position.WIDTH*Position.HEIGHT + 1 - P.nbMoves())/2;
            }
        }
        var bestScore : Int = -Position.WIDTH*Position.HEIGHT; // init the best possible score with lower bound
        for x : Int in 0...Position.Width-1 { // compute the score of all possible next move and keep the best one
            if (P.canPlay(x)) {
                var P2 : Position = P.copy() as! Position; // Copy the position to do temp work with recursion
                P2.play(x); // Its opponent turn in P2 position after current player plays x column
                var score : Int = -negamax(P2); // If current player plays col x, his score will be the opposite of opponents score after this next move
                if (score > bestScore) {
                    bestScore = score; // keep track of best possible score so far
                }
            }
        }
        return bestScore;
    }

    func solve(P : Position) -> Int {
        nodeCount = 0;
        return negamax(P);
    }

    func getNodeCount() -> CUnsignedLongLong {
        return nodeCount;
    }
    init() { // Doesnt really do anything, just creates the object
    }
}