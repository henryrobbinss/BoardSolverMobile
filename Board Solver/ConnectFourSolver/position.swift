// This code is merely a translation and remake of the solver by Pascal Pons
// The code way originaly written in C++, and through the use of his GitHub and site, it has been rewritten for
// Swift for BoardSolver. It is a fair bit slower than his model, but by utilizing a maximum depth check, it can
// Output a response in a fast time.

public class Position {
    static let WIDTH = 7; // Width of the board
    static let HEIGHT = 6; // Height of the board
    static let MIN_SCORE = -(WIDTH*HEIGHT)/2 + 3;
    static let MAX_SCORE = (WIDTH*HEIGHT)/2 + 3;
    let bottom : UInt64 = 4432676798593; // This number represents all 1s in the bottom row
    // 0 if cell is empty, 1 for first player and 2 for second player.
    private var board : UInt64 = 0;
    private var mask : UInt64 = 0;
    private var boardMask : UInt64 = 4432676798593 * ((UInt64(1) << Position.HEIGHT) - 1);
     private var moves: CUnsignedInt = 0; // number of moves played since the beinning of the game.

    func display() {
        print("position   mask      key       bottom");
        var bitMask : UInt64 = UInt64(1) << (Position.HEIGHT);
        let tempKey : UInt64 = key();
        for _ in 0...(Position.HEIGHT) {
            var boardPrint : String = "";
            var maskPrint : String = "";
            var keyPrint : String = "";
            var bottomPrint : String = "";
            for j in 0...(Position.WIDTH-1) {
                let curMask : UInt64 = bitMask << (j*(Position.HEIGHT+1));
                if (0 != curMask & board) {
                    boardPrint+="1";}
                else {boardPrint+="0";}
                if (0 != curMask & mask) {
                    maskPrint+="1";}
                else {maskPrint+="0";}
                if (0 != curMask & tempKey) {
                    keyPrint+="1";}
                else {keyPrint+="0";}
                if (0 != curMask & bottom) {
                    bottomPrint+="1";}
                else {bottomPrint+="0";}
            }
            bitMask = bitMask >> 1;
            print(boardPrint+" | "+maskPrint+" | "+keyPrint+" | "+bottomPrint);
        }
    }
    func display (pos: UInt64) {
        var bitMask : UInt64 = UInt64(1) << (Position.HEIGHT);
        for _ in 0...(Position.HEIGHT) {
            var boardPrint : String = "";
            for j in 0...(Position.WIDTH-1) {
                let curMask : UInt64 = bitMask << (j*(Position.HEIGHT+1));
                if (0 != curMask & pos) {
                    boardPrint+="1";}
                else {boardPrint+="0";}
            }
            bitMask = bitMask >> 1;
            print(boardPrint);
        }
    }
    // Checks if the given column is full
    func canPlay(col : Int) -> Bool {
        // Checks if the bit corresponding to a full column at col is 1
        return (mask & topBit(col: col)) == 0;
    }
    // Returns mask of top bit in actual board, not including that weird extra bit
    private func topBit(col : Int) -> UInt64 {
        return (UInt64(1) << ((Position.HEIGHT-1) + col*(Position.HEIGHT+1)));
    }
    func columnMask(col : Int) -> UInt64 {
        // Get mask of a single column all as 1s
        let temp : UInt64 = (UInt64(1) << Position.HEIGHT)-1;
        return temp << (col*(Position.HEIGHT+1));
    }
    // Plays a given column
    func play(col : Int) {
        // add new move to the mask
        mask |= mask + bottomBit(col: col);
        // xor board with mask to flip players to the current player
        board ^= mask;
        moves += 1;
    }
    func play(move : UInt64) {
        // add new move to the mask
        mask |= move;
        // xor board with mask to flip players to the current player
        board ^= mask;
        moves += 1;
    }
    private func bottomBit(col : Int) -> UInt64 {
        return (UInt64(1) << (col*(Position.HEIGHT+1)));
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
    func canWinNext() -> Bool {
        return (0 != (opponentWinningPosition() & possible()));
    }
    func possible() -> UInt64 {
        return (mask + bottom) & boardMask;
    }
    func possibleNonLosingMoves() -> UInt64 {
        var possible_mask : UInt64 = possible();
        let opponent_win : UInt64 = winning_position();
        let forced_moves : UInt64 = (possible_mask & opponent_win);
        if (forced_moves != 0) {
            if (0 != (forced_moves & (forced_moves - 1))) {
                return 0;
            } else {
                possible_mask = forced_moves;
            }
        }
        return possible_mask & ~(opponent_win >> 1);
    }
    func key() -> UInt64 {
        return board + mask + bottom;
    }
    func isWinningMove(col: Int) -> Bool {
        return (opponentWinningPosition() & possible() & columnMask(col: col)) != 0;
    }
    func winning_position() -> UInt64 {
        return compute_winning_position(position:board,m:mask);
    }
    func opponentWinningPosition() -> UInt64 {
        return compute_winning_position(position:(board ^ mask),m:mask);
    }
    func compute_winning_position(position : UInt64, m : UInt64) -> UInt64 {
        // Vertical
        // 1 here means 3 in a row up
        // Dont need to check anything else for this because it wouldve already been found
        var r : UInt64 = (position << 1) & (position << 2) & (position << 3);
        // Horizontal
        // 1 here means 2 in a row to the right
        var p : UInt64 = ((position << (Position.HEIGHT+1)) & (position << (2*(Position.HEIGHT+1))));
        r |= p & (position << (3*(Position.HEIGHT+1))); // Check 3 to the right
        r |= p & (position >> (Position.HEIGHT+1)); // Check 2 to the right and 1 to the left
        p = ((position >> (Position.HEIGHT+1)) & (position >> (2*(Position.HEIGHT+1))));// 2 to the left
        r |= p & (position << (Position.HEIGHT + 1)); // 2 to the left 1 to the right
        r |= p & (position >> (3*(Position.HEIGHT + 1))) // 3 to the left
        // Diagonal 1
        p = ((position << (Position.HEIGHT)) & (position << (2*(Position.HEIGHT))));
        r |= p & (position << (3*(Position.HEIGHT)));
        r |= p & (position >> (Position.HEIGHT));
        p = ((position >> (Position.HEIGHT)) & (position >> (2*(Position.HEIGHT))));
        r |= p & (position << (Position.HEIGHT));
        r |= p & (position >> (3*(Position.HEIGHT)))
        // Diagonal 2
        p = ((position << (Position.HEIGHT+2)) & (position << (2*(Position.HEIGHT+2))));
        r |= p & (position << (3*(Position.HEIGHT+2)));
        r |= p & (position >> (Position.HEIGHT+2));
        p = ((position >> (Position.HEIGHT+2)) & (position >> (2*(Position.HEIGHT+2))));
        r |= p & (position << (Position.HEIGHT+2));
        r |= p & (position >> (3*(Position.HEIGHT+2)));
        return r & (boardMask ^ m);
    }
    func nbMoves() -> CUnsignedInt {
        return moves;
    }
    func moveScore(move : UInt64) -> Int {
        return Int(popCount(m : compute_winning_position(position:((board ^ mask) | move),m:mask)));
    }
    func popCount(m : UInt64) -> UInt {
        var temp : UInt64 = m;
        var c : UInt = 0;
        while (temp != 0) {
            temp &= (temp - 1); // Take away one row from m at a time to count the rows with 1s in them
            c += 1;
        }
        return c;
    }
    func copy() -> Position {
        return Position(board: self.board, mask: self.mask, moves: self.moves);
    }
    init() {} // Doesnt do anything since default values are set above
    init(board: UInt64, mask: UInt64, moves: CUnsignedInt) {
        self.board = board;
        self.mask = mask;
        self.moves = moves;
    }
}
