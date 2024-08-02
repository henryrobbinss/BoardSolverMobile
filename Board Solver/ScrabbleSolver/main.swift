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
        let filename : String = "test.txt";
        let relativePath = "/Users/chris/Documents/ScrabbleSolver/ScrabbleSolver"
        let data = try String(contentsOfFile: relativePath+"/TestFiles/"+filename, encoding: .utf8);
        let myStrings = data.components(separatedBy: .newlines);
        let solver : Solver = Solver();
        var gotRack : Bool = false;
        for curLine in myStrings {
            if (!gotRack) {
                gotRack = true;
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
        var before = Date().timeIntervalSince1970
        solver.loadWords();
        var after = Date().timeIntervalSince1970
        print(after-before);
        solver.setRack(rack:Array(myStrings[0]));
        before = Date().timeIntervalSince1970
        let _ = solver.newSolve();
        after = Date().timeIntervalSince1970
        print(after-before);
        solver.displayBoard();
    } catch {
        print(error);
    }
}
