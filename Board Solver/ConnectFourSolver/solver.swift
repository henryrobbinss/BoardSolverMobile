public class Solver {
    private var nodeCount : CUnsignedLongLong = 0; // counter of explored nodes
    private var columnOrder : [Int] = Array(repeating: 0, count: Position.WIDTH)
    private var table : TranspositionTable = TranspositionTable();

    // Recursive solve of a negamax min-max algorithm
    // 0 is drawn game
    // Positive score if you can win whatever your opponent is playing. Your score is
    // The number of moves before the end you can win (faster win is higher score)
    // Negative score if your opponent can force you to lose. Your score is the opposite
    // of the number of moves before the end you will lose (faster loss is lower score)
    func negamax(P : Position, a : Int, b : Int) -> Int {
        assert(a<b);
        var alpha : Int = a;
        var beta : Int = b;
        nodeCount += 1; // Increment counter of explored nodes
        let next : UInt64 = P.possibleNonLosingMoves();
        if (next == 0) {return -(Position.WIDTH*Position.HEIGHT - Int(P.nbMoves()))/2;}
        if (P.nbMoves() >= Position.WIDTH*Position.HEIGHT-2) { // Check for drawn game
            return 0;
        }
        let min : Int = -(Position.WIDTH*Position.HEIGHT-2-Int(P.nbMoves()))/2;
        if (alpha < min) {alpha = min;}
        if (alpha >= beta) {return alpha;}
        // At this point since the code wouldve returned, the max score is less than that
        var max : Int = (Position.WIDTH*Position.HEIGHT - 1 - Int(P.nbMoves()))/2;
        let val : Int = Int(table.get(key:P.key()));
        if (val != 0) {max = val + Position.MIN_SCORE - 1;}
        if (beta > max) {
            beta = max;
            if (alpha >= beta) {return beta;}
        }
        let moves : MoveSorter = MoveSorter();
        // Add all possible moves to move sorter in order by column order
        var i : Int = Position.WIDTH - 1;
        while(i >= 0) {
            let move : UInt64 = next & P.columnMask(col: columnOrder[i]);
            // if theres a possible move in this column
            if (move != 0) {
                moves.add(move: move, score: P.moveScore(move: move));
            }
            i -= 1;
        }
        var nextMove : UInt64 = moves.getNext();
        while(0 != nextMove) {
            let P2 : Position = P.copy(); // Copy the position to do temp work with recursion
            P2.play(move: nextMove); // Its opponent turn in P2 position after current player plays x column
            let score : Int = -negamax(P:P2, a:-beta, b:-alpha); // If current player plays col x, his score will be the opposite of opponents score after this next move
            if(score >= beta) {return score;}
            if (score > alpha) {alpha = score;}
            nextMove = moves.getNext();
        }
        
        table.put(key: P.key(), val: UInt8(alpha - Position.MIN_SCORE + 1));
        return alpha;
    }
    func resetTable() {
        table.reset();
    }
    func solve(P : Position) -> Int {
        if (P.canWinNext()) {return (Position.WIDTH*Position.HEIGHT+1 - Int(P.nbMoves()))/2;}
        // iterative deepening
        var min : Int = -(Position.WIDTH*Position.HEIGHT-Int(P.nbMoves()))/2;
        var max : Int = (Position.WIDTH*Position.HEIGHT-Int(P.nbMoves()))/2;
        while (min < max) { // Narrow the min-max window
            // Get the median of the min and max
            var med : Int = min + (max - min)/2;
            // Set med within min and max bounds
            if (med <= 0 && min/2 < med) {med = min/2;}
            else if (med >= 0 && max/2 > med) {med = max/2;}
            // Call negamax with a alpha;beta value of med;med+1
            // This is the null search window optimization
            let val : Int = negamax(P:P, a:med, b:med+1);
            if (val <= med) {max = val;}
            else {min = val;}
        }
        // At this point min and max are equal
        return min;
    }

    func getNodeCount() -> CUnsignedLongLong {
        return nodeCount;
    }
    init() {
        for i : Int in 0...Position.WIDTH-1 {
            // Sets column order so that middle is 0, and further out from middle is higher order check
            // Allows for more optimal pruning since the middle has a better chance of leading to a better
            // Score than the outside does
            columnOrder[i] = Position.WIDTH/2 + (1-2*(i%2))*(i+1)/2;
        }
    }
}
