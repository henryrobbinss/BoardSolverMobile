import Foundation
main();
func printPosOptions(pos:[[[Bool]]]) {
    print("Right");
    for i in 0...14 {
        var curPrint = ""
        for j in 0...14 {
            if pos[0][i][j] {curPrint = curPrint + "1 ";} else {curPrint = curPrint + "0 ";}
        }
        print(curPrint);
    }
    print("Down");
    for i in 0...14 {
        var curPrint = ""
        for j in 0...14 {
            if pos[1][i][j] {curPrint = curPrint + "1 ";} else {curPrint = curPrint + "0 ";}
        }
        print(curPrint);
    }
}
func main() {
    do {
        var testingBoardRead = true;

        if(testingBoardRead) {
            print("Testing Board Read:");
            let filename : String = "board1.txt";
            let relativePath = "/Users/spauln/Documents/GitHub/BoardSolverMobile/Board Solver/ScrabbleSolver";
            let data = try String(contentsOfFile: relativePath+"/TestFiles/TestBoards/"+filename, encoding: .utf8);
            //init solver w input board
            let solver: Solver = Solver(path: data);
            

        } else {
            let filename : String = "test.txt";
//        let relativePath = "/Users/chris/Documents/ScrabbleSolver/ScrabbleSolver"
            let relativePath = "/Users/spauln/Documents/GitHub/BoardSolverMobile/Board Solver/ScrabbleSolver";

            let data = try String(contentsOfFile: relativePath+"/TestFiles/"+filename, encoding: .utf8);
            let myStrings = data.components(separatedBy: .newlines);
            print (myStrings);
            let solver : Solver = Solver();
            var gotRack : Bool = false;
            for curLine: String in myStrings {
                if (!gotRack) {
                    gotRack = true;
                    continue;
                }
                if(curLine.isEmpty) {
                    //empty string because of newline
                    continue;
                }
                let lineArr : [String] = curLine.components(separatedBy: " ");
                if (lineArr.count != 4) {
                    print ("ERROR: lineArr is not length 3");
                    break;
                }
                let word : String = lineArr[0];
                let x : Int = Int(lineArr[1]) ?? -1;
                let y : Int = Int(lineArr[2]) ?? -1;
                let dir : Bool = lineArr[3] != "right";
                if (x < 0 || y < 0 || x > 14 || y > 14 || (lineArr[3] != "right" && lineArr[3] != "down")) {
                    print("ERROR: x,y,dir are not proper");
                    return;
                }
                print("word: " + word);
                print("x: " + String(x));
                print("y: " + String(y));
                print("dir: " + String(dir));
                print("--------------------");
                solver.playMove(word:Array(word),x:x,y:y,dir:dir)
            }

        // solver.displayBoard();
        // print(rack);
        // let move : String = solver.solve();
        //  print(move);
        //  let moveSegments : [String] = move.components(separatedBy: " ");
        //  if moveSegments[3] == "down" {
        //      solver.playMove(word:Array(moveSegments[0]), x:Int(moveSegments[1])!, y:Int(moveSegments[2])!, dir:true);
        //  } else {
        //     solver.playMove(word:Array(moveSegments[0]), x:Int(moveSegments[1])!, y:Int(moveSegments[2])!, dir:false);
        // }
            var before: TimeInterval = Date().timeIntervalSince1970
            solver.loadWords();
            var after = Date().timeIntervalSince1970
            print("Time to load words (s):  ", terminator: "")
            print(+after-before);
            solver.setRack(rack:Array(myStrings[0]));
            before = Date().timeIntervalSince1970
            let _ = solver.newSolve();
            after = Date().timeIntervalSince1970
            print("Time to solve (s):  ", terminator: "")
            print(after-before);
            solver.displayBoard();
        
        }
    } catch {
        print(error);
    }
}

/*
checklist:
- make sure given an empty board returns move starting on starting square
- adjust to take in a board initially and return best move given a rack rather than take in a move
    * create a class for testing purposes to read in a board file to a board
- create function to evaluate word scores
    * requires point values per letter
    * 
*/
   