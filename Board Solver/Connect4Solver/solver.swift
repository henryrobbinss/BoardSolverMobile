// This code is merely a translation and remake of the solver by Pascal Pons
// The code way originaly written in C++, and through the use of his GitHub and site, it has been rewritten for
// Swift for BoardSolver. It is a fair bit slower than his model, but by utilizing a maximum depth check, it can
// Output a response in a fast time.

public class Solver {
    private var nodeCount : UInt64 = 0; // counter of explored nodes
    private var columnOrder : [Int] = Array(repeating: 0, count: Position.WIDTH)
    private var table : TranspositionTable = TranspositionTable();
    
    func scoreAllMoves(P : Position) -> [Int] {
        var finalEvaluations : [Int] = Array(repeating : -999999, count: Position.WIDTH);
        for i in 0...Position.WIDTH-1 {
            if (P.canPlay(col:i)) {
                if(P.isWinningMove(col:i)) {
                    finalEvaluations[i] = (Position.WIDTH * Position.HEIGHT + 1 - Int(P.nbMoves())) / 2;
                }
              else {
                  let P2 : Position = P.copy();
                  P2.play(col:i);
                  finalEvaluations[i] = -solve(P:P2);
              }
            }
        }
        return finalEvaluations;
    }
    // Recursive solve of a negamax min-max algorithm
    // 0 is drawn game
    // Positive score if you can win whatever your opponent is playing. Your score is
    // The number of moves before the end you can win (faster win is higher score)
    // Negative score if your opponent can force you to lose. Your score is the opposite
    // of the number of moves before the end you will lose (faster loss is lower score)
    func negamax(P : Position, a : Int, b : Int, d : UInt) -> Int {
        // Maximum depth cutoff, any depth larger than this value will just return 0
        // In a perfect world this is considered "suboptimal", but in the real world
        // It is perfectly fine, since the solver has shown that there is a way to not
        // lose within 16 moves. Humans will make the wrong move at some point which will
        // Make the solver solve within the 16 move limit, forcing a win
        if (d>=16) {
            return 0;
        }
        assert(a<b);
        var alpha : Int = a;
        var beta : Int = b;
        nodeCount += 1; // Increment counter of explored nodes
        let next : UInt64 = P.possibleNonLosingMoves();
        if (next == 0) {return -(Position.WIDTH*Position.HEIGHT - Int(P.nbMoves()))/2;}
        if (P.nbMoves() >= Position.WIDTH*Position.HEIGHT-2) { // Check for drawn game
            return 0;
        }
        var min : Int = -(Position.WIDTH*Position.HEIGHT-2-Int(P.nbMoves()))/2;
        if (alpha < min) {alpha = min;}
        if (alpha >= beta) {return alpha;}
        // At this point since the code wouldve returned, the max score is less than that
        var max : Int = (Position.WIDTH*Position.HEIGHT - 1 - Int(P.nbMoves()))/2;
        if (beta > max) {
            beta = max;
            if (alpha >= beta) {return beta;}
        }
        
        let key : UInt64 = P.key();
        var val : Int = Int(table.get(key:key));
        if (val != 0) {
            if (val > Position.MAX_SCORE - Position.MIN_SCORE + 1) { // lower bound
                min = val + 2*Position.MIN_SCORE - Position.MAX_SCORE - 2;
                if (alpha < min) {
                    alpha = min; // no need to keep beta above max possible score
                    // prune the exploration if the alpha;beta window is empty
                    if (alpha >= beta) {return alpha;}
                }
            } else { // upper bound
                max = val + Position.MIN_SCORE - 1;
                if (beta > max) {
                    beta = max;
                    if (alpha >= beta) {return alpha;}
                }
            }
        }
        
        let moves : MoveSorter = MoveSorter();
        val = Int(table.get(key:P.key()));
        if (val != 0) {max = val + Position.MIN_SCORE - 1;}
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
            let score = -negamax(P:P2, a:-beta, b:-alpha, d: d+1); // If current player plays col x, his score will be the opposite of opponents score after this next move
            if(score >= beta) {
                return score;
            }
            if (score > alpha) {alpha = score;}
            nextMove = moves.getNext();
        }
        
        table.put(key: key, val: UInt8(alpha - Position.MIN_SCORE + 1));
        return alpha;
    }
    func findColumn(val : UInt64) -> Int {
        var colCheck : UInt64 = 128
        for i in 0...5 {
            if colCheck > val {return i;}
            colCheck = colCheck * 64;
        }
        return 6;
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
            let val : Int = negamax(P:P, a:med, b:med+1, d:0);
            if (val <= med) {max = val;}
            else {min = val;}
        }
        // At this point min and max are equal
        return min;
    }

    func getNodeCount() -> UInt64 {
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
