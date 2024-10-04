import Foundation
main();
func main() {
    do {
        
        let _ : Solver = Solver();
        let filename : String = "test1.txt";
        let relativePath = "/Users/spauln/Documents/GitHub/BoardSolverMobile/Board Solver/ScrabbleSolver"
        let data = try String(contentsOfFile: relativePath+"/TestFiles/"+filename, encoding: .utf8);
        let myStrings = data.components(separatedBy: .newlines);
        let curPos : Position = Position(rack: Array(myStrings[0]));
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
                return;
            }
            let word : String = lineArr[0];
            let x : Int = Int(lineArr[1]) ?? -1;
            let y : Int = Int(lineArr[2]) ?? -1;
            let dir : Bool = lineArr[3] == "right";
            if (x < 0 || y < 0 || x > 14 || y > 14 || (lineArr[3] != "right" && lineArr[3] != "down")) {
                print("ERROR: x,y,dir are not proper");
                return;
            }
            print("word: " + word);
            print("x: " + String(x));
            print("y: " + String(y));
            print("dir: " + String(dir));
            curPos.playMove(word:Array(word), x:x, y:y, dir:dir);
            curPos.displayBoard();
        }
    } catch {
        print(error);
    }
}
