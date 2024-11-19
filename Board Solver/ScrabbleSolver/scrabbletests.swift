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
        var word: [Character] = Array()
        word.append(Character("O"));
        word.append(Character("X"));
        word.append(Character("Y"));
        word.append(Character("P"));
        word.append(Character("H"));
        word.append(Character("E"));
        word.append(Character("N"));
        word.append(Character("B"));
        word.append(Character("U"));
        word.append(Character("T"));
        word.append(Character("A"));
        word.append(Character("Z"));
        word.append(Character("O"));
        word.append(Character("N"));
        word.append(Character("E"));
        solver.testScore(word:word,x:0, y:0, dir:true );
        solver.playMove(word:word,x:0, y:0, dir:true,debug:false );
        solver.displayBoard();

    }
    
}