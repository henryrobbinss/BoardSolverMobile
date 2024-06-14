public class Position {
    static let WIDTH = 7; // Width of the board
    static let HEIGHT = 6; // Height of the board
    // 0 if cell is empty, 1 for first player and 2 for second player.
    private var board : [[Int]] = Array(repeating: Array(repeating: 0, count: HEIGHT), count: WIDTH);
    private var height: [Int] = Array(repeating: 0, count: WIDTH); // number of stones per column
     private var moves: CUnsignedInt = 0; // number of moves played since the beinning of the game.
    // For debugging
    func displayBoard() {
        for i in 0...Position.WIDTH-1 {
            var curPrint : String = "";
            for j in 0...Position.HEIGHT-1 {
                if (board[i][j] == 0) {
                    curPrint += " - "
                } else if (board[i][j] == 1) {
                    curPrint += " 1 ";
                } else {
                    curPrint += " 2 ";
                }
            }
            print(curPrint);
        }
        print();
    }
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
            let curChar: Character = seq[seq.index(seq.startIndex, offsetBy: i)];
            let col : Int = Int(curChar.asciiValue!) - Int(Character("1").asciiValue!);
            if(col < 0 || col >= Position.WIDTH || !canPlay(col: col) || isWinningMove(col: col)) {
                return CUnsignedInt(i);
            }
            play(col: col);
        }
        return CUnsignedInt(seq.count);
    }

    func isWinningMove(col: Int) -> Bool {
        let current_player : Int = Int(1 + moves % 2);
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
                while (x >= 0 && x < Position.WIDTH && y >= 0 && y < Position.HEIGHT && board[x][y] == current_player) {
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
    func nbMoves() -> CUnsignedInt {
        return moves;
    }
    func copy() -> Position {
        return Position(board: self.board, height: self.height, moves: self.moves);
    }
    func deepCopyBoard(board: [[Int]]) -> [[Int]] {
        // Initialize new board
        var newBoard : [[Int]] = Array(repeating: Array(repeating: 0, count: Position.HEIGHT), count: Position.WIDTH);
        for i in 0...Position.WIDTH-1 {
            newBoard[i] = Array(board[i]);
        }
        return newBoard;
    }
    init() {
        self.board = Array(repeating: Array(repeating: 0, count: Position.HEIGHT), count: Position.WIDTH);
        self.height = Array(repeating:0, count: Position.WIDTH);
        self.moves = 0;
    }
    init(board: [[Int]],height: [Int], moves: CUnsignedInt) {
        self.board = deepCopyBoard(board: board);
        self.height = Array(height);
        self.moves = moves;
    }
}
