import Foundation
public class Solver {
    var pos : Position;
    init(rack : [Character]) {
        // Create an empty position given the rack
        pos = Position(rack:rack);
    }
    init() {
        // Do nothing on basic init
        pos = Position(rack: []);
    }
    func playMove(word : [Character], x : Int, y : Int, dir: Bool) {
        pos.playMove(word:word,x:x,y:y,dir:dir);
    }
    func displayBoard() {
        pos.displayBoard();
    }
    func solve() -> String {
        let posWords : [[Character]] = pos.getPossibleWords();
        var moveToScore: [String: Int] = [:]
        for word in posWords {
            let curMoves : [[[Bool]]] = pos.findSpotsForWord(word:word);
            for i in 0...1 {
                for j in 0...14 {
                    for k in 0...14 {
                        // If it passes here, valid move!
                        if (curMoves[i][j][k]) {
                            print("found word!");
                            var curString : String = "";
                            curString += word + " ";
                            curString += String(k) + " ";
                            curString += String(j) + " ";
                            var score : Int = 0;
                            if i == 1 {
                                curString += "down";
                                score = pos.scoreMove(word:word,x:k,y:j,dir:true);
                            } else {
                                curString += "right";
                                score = pos.scoreMove(word:word,x:k,y:j,dir:false);
                            }
                            moveToScore[curString] = score;
                        }
                    }
                }
            }
        }
        // Get arr of the moves and sort them
        // Sort from high to low
        let moveArr : Array<String> = Array(moveToScore.keys);
        let sortedArr = moveArr.sorted { (moveOne, moveTwo) -> Bool in
            let scoreOne = moveToScore[moveOne]!;
            let scoreTwo = moveToScore[moveTwo]!;
            return scoreOne > scoreTwo
        }
//        for key in sortedArr {
//            print(key + ": " + String(moveToScore[key]!));
//        }
        // Return the best move
        return sortedArr[0] + ": " + String(moveToScore[sortedArr[0]]!) + "pts";
    }
}
