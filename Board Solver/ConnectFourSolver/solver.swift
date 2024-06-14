public class Solver {
    private var nodeCount : CUnsignedLongLong = 0; // counter of explored nodes

    // Recursive solve of a negamax min-max algorithm
    // 0 is drawn game
    // Positive score if you can win whatever your opponent is playing. Your score is
    // The number of moves before the end you can win (faster win is higher score)
    // Negative score if your opponent can force you to lose. Your score is the opposite
    // of the number of moves before the end you will lose (faster loss is lower score)
    func negamax(P : Position) -> Int {
        nodeCount += 1; // Increment counter of explored nodes
        if (P.nbMoves() == Position.WIDTH*Position.HEIGHT) { // Check for drawn game
            return 0;
        }
        for x : Int in 0...Position.WIDTH-1 { // Check i current player can win next move
            if(P.canPlay(col:x) && P.isWinningMove(col:x)) {
                return (Position.WIDTH*Position.HEIGHT + 1 - Int(P.nbMoves()))/2;
            }
        }
        var bestScore : Int = -Position.WIDTH*Position.HEIGHT; // init the best possible score with lower bound
        for x : Int in 0...Position.WIDTH-1 { // compute the score of all possible next move and keep the best one
            if (P.canPlay(col:x)) {
                let P2 : Position = P.copy(); // Copy the position to do temp work with recursion
                P2.play(col:x); // Its opponent turn in P2 position after current player plays x column
                let score : Int = -negamax(P:P2); // If current player plays col x, his score will be the opposite of opponents score after this next move
                if (score > bestScore) {
                    bestScore = score; // keep track of best possible score so far
                }
            }
        }
        return bestScore;
    }

    func solve(P : Position) -> Int {
        nodeCount = 0;
        return negamax(P: P);
    }

    func getNodeCount() -> CUnsignedLongLong {
        return nodeCount;
    }
    init() {} // Does nothing, just needs to have an initializer
}
