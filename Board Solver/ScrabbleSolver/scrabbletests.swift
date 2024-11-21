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
        var w: String = "OXYPHENBUTAZONE";
        for c:Character in w {
            word.append(c);
        }
        solver.displayBoard();

        solver.testScore(word:word,x:0, y:0, dir:true );
    }

    public func test2(path: String) {
        print("TEST 2 --- Testing 2023 world championship finals game");
        
        let solver: Solver = Solver(path: path);
        solver.loadWords();

        //******************** Move 1 *****************************
        solver.setRack(rack:Array("DFIORST"));
        solver.displayBoard();

        var word: [Character] = Array()
        var w: String = "FIORD";
        for c:Character in w {
            word.append(c);
        }

        solver.playMove(word:word, x:7, y:3, dir:true, debug: false);
        
        //******************** Move 2 *****************************
        solver.setRack(rack:Array("BIOOQUT"));
        let move1 = solver.newSolve();
        solver.displayBoard();

        w = "QUOIF";
        word = [];
        for c:Character in w {
            word.append(c);
        }

        solver.playMove(word:word, x:3, y:3, dir:false, debug: false);

        //******************** Move 3 *****************************
        solver.setRack(rack:Array("IMRY ST"));
        let move2 = solver.newSolve();
        solver.displayBoard();

/*
        w = "QUOIF";
        word = [];
        for c:Character in w {
            word.append(c);
        }

        solver.playMove(word:word, x:3, y:3, dir:false, debug: false);
*/

    }
    
}