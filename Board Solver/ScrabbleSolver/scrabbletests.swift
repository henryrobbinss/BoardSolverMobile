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
        print("***************************");
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
        print("***************************");

        solver.setRack(rack:Array("IMRYAST"));
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

    public func test3(path: String) {
        print("TEST 3 --- Testing specific board for no moves possible error");
        
        let solver: Solver = Solver(path: path);
        solver.loadWords();
//        solver.displayWords();
        solver.setRack(rack:Array("IMRYNST"));
        solver.displayBoard();
        let move = solver.newSolve();
       
        solver.displayBoard();

    }

    public func test4(path: String) {
        print("TEST 4 --- Testing NASPA game 2023 Championship Finals - Josh Sokol vs. Joey Mallick - Game 5");
        let solver: Solver = Solver(path: path);
        solver.loadWords();
//******************** Move 1 *****************************

        var word: [Character] = Array()
        var w: String = "GOGO";
        for c:Character in w {
            word.append(c);
        }

        solver.playMove(word:word, x:7, y:6, dir:true, debug: false);
        solver.displayBoard();

        solver.setRack(rack:Array("AAEPRTU"));

        var word1: [Character] = Array()
        var w1: String = "ATAP";
        for c:Character in w1 {
            word.append(c);
        }

        let move1 = solver.newSolve();
        //solver.testScore();
    }


    //small command line tester to demonstrate program
    public func printTester(path: String) {
        let solver: Solver = Solver(path: path);
        solver.loadWords();
        var keep_playing: Bool = true;
        //first move
        while(keep_playing) {
            print("Enter rack:");
            let rack: String? = readLine();
            solver.setRack(rack:Array(rack!));


            let move = solver.newSolve();
            solver.displayBoard();

            print("Enter word to play:");
            let w: String? = readLine();
            print("Enter x:");
            let x_s = readLine();
            let x : Int = Int(x_s!) ?? -1;
            print("Enter y:");
            let y_s = readLine();
            let y : Int = Int(y_s!) ?? -1;
            print("Enter direction: (right/down)");
            let d = readLine();
            var dir: Bool = true;
            if(d == "right") {
                dir = false;
            }

            var word: [Character] = Array();

            for c:Character in w! {
                word.append(c);
            }

            solver.playMove(word:word, x:x, y:y, dir:dir, debug: false);
            //solver.displayBoard();

                    

        
            //ask whether to continue
            print("Continue Playing? (y/n)");
            let leaveCond = readLine();
            if(leaveCond != "y") {
                keep_playing = false;
            }
            print("*******");

        }
    }


}