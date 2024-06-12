public class Position {
    static let WIDTH = 7; // Width of the board
    static let HEIGHT = 6; // Height of the board
    private var board : [[Int]] = [WIDTH][HEIGHT]; // 0 if cell is empty, 1 for first player and 2 for second player.
    private var height: [Int] = [WIDTH]; // number of stones per column
     private var moves: UInt; // number of moves played since the beinning of the game.

    // Checks if the given column is full
    func canPlay(col : Int) -> Bool {
        return height[col] < HEIGHT;
    }

    // Plays a given column
    func play(col : Int) {
        board[col][height[col]] = 1 + moves % 2;
        height[col]++;
        moves += 1;
    }

    // Plays a series of moves at once
    // Stops processing at invalid move
    func play(seq : String) -> UnsignedInteger {
        for i : Int in 0...seq.count-1 {
            var col : UnsignedInteger = seq[i].asciiValue - 1;
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