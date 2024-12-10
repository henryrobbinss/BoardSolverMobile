import Foundation
public class ScrabbleTest {
    /*
        Class to run tests on the scrabble solver for famous games and edge cases to verify identical/correct results

        NOTABLE BUGS SUMMARY:
            Test 1 -    Test meant to test highest scoring scrabble move possible, "OXYPHENBUTAZONE" 
                        supposed to be played at (0, 0) downwards using either test1A.txt or test1B.txt 
                        (Both are valid boards where this word should be able to be played). There is 
                        an error, likely within checkdown in the solver class, so that this is not a 
                        valid move. In addition, the score for this word when forcibly scored with 
                        the testscore function is different than theorized to be:
                            1A: shoud be 1780, tester is 1782
                            1B: should be 1778, tester is 1769

            Test 2 -    Uses test2.txt. Started testing on 2023 world championship finals game between David Eldar and 
                        Harshan Lamabadusuriya. I soon realized that while our disctionary is the Collins 
                        American disctionary, championship games use the UK dictionary. While the first 
                        word is common to both, "QUOIF" is only within the UK version. If temporarily 
                        inserted, the next move that is played in the actua game is "MINISTRY" (4, 4) right
                        which does not appear as an option. Likely an error in checkright in the solver class.
                        
                        Also, the original rack from the game contains a blank tile " ", and there being no solutions
                        for this may also be a bug with the use of blank tiles as a whole.

            Test 3 -    Uses test3.txt. Same as test 2 but just the move "MINISTRY" for debugging purposes.

            Test 4 -    Testing of US 2023 Scrabble championship between Joey Mallick and Joshua Sokol. First move is "GOGO",
                        there is a bug on the second move played "ATAP" (6, 6) down not registering as a valid move, should 
                        be worth 22 points.

            PrintTester:    
                        Uses test2.txt or any other empty board file. Uses the command line to easier test 
                        or demonstrate singular moves.  

        NEEDS TESTING:
            -   Blank tiles should be tested, their use, their point values when contained in a word being played
                /already played
            -   solving empty board with a set rack should check for best possible solutions using the given letters
                covering the middle square (7, 7) in some way rather than returning no solutions.

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

        solver.setRack(rack:Array("IMRY ST"));

        //solver.setRack(rack:Array("IMRYAST"));
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
//        solver.setRack(rack:Array("IMRY ST"));
        solver.setRack(rack:Array("IMRYNST"));

        solver.displayBoard();
        let move = solver.newSolve();
       
        solver.displayBoard();

    }

//should find atap down 6 6 as valid move, doesn't
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
            word1.append(c);
        }

        let move1 = solver.newSolve();
        solver.testScore(word:word1, x:6, y:6, dir:true);
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