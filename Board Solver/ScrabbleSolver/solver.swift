import Foundation
public class Solver {
    var pos : Position;
    init(rack : [Character]) {
        // Create an empty position given the rack
        pos = Position(rack:rack);
    }
    func playMove(word : [Character], x : Int, y : Int, dir: Bool) {
        pos.playMove(word:word,x:x,y:y,dir:dir);
    }
    func solve(p:Position) -> Array<Array<String>> {
        let posWords : [[Character]] = pos.getPossibleWords();
        var allMoves : Array<Array<String>> = [];
        for word in posWords {
            let curMoves : [[[Bool]]] = pos.findSpotsForWord(word:word);
            for i in 0...1 {
                for j in 0...14 {
                    for k in 0...14 {
                        if (curMoves[i][j][k]) {
                            var curArray : Array<String> = []
                            if i == 1 {
                                curArray.append(pos.scoreMove(word:word,x:j,y:i,dir:true))
                            } else {
                                curArray.append(pos.scoreMove(word:word,x:j,y:i,dir:false))
                            }
                            curArray.append(word)
                            curArray.append(j)
                            curArray.append(i);
                            
                            if (i == 1) {
                            }
                            
                        }
                    }
                }
            }
        }
        curPos.playMove(word:Array(word), x:x, y:y, dir:dir);
        curPos.displayBoard();
        return allMoves;
       //     printPosOptions(pos:curPos.findSpotsForWord(word:word));
        }
    }
}
