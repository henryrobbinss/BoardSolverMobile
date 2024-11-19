import Foundation
public class ScrabbleTest {
    /*
        Class to run tests on the scrabble solver for famous games to verify identical results
    */
    init() {

    }
    public func test1(path: String) {
        print("TEST 1 --- Testing highest scoring scrabble move possible");
        
        let solver: Solver = Solver(path: path);
        solver.loadWords();
        solver.setRack(rack:Array("OXPBAZE"));
        solver.displayBoard();
        let move = solver.newSolve();
        
    }
    
}