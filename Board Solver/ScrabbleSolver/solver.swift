import Foundation
public class Solver {
    var pos : Position;
    var tree : Trie;
    init(rack : [Character]) {
        // Create an empty position given the rack
        pos = Position(rack:rack);
        tree = Trie();
    }
    init() {
        // Do nothing on basic init
        pos = Position();
        tree = Trie();
    }
    public func playMove(word : [Character], x : Int, y : Int, dir: Bool) {
        pos.playMove(word:word,x:x,y:y,dir:dir);
    }
    public func displayBoard() {
        pos.displayBoard();
    }
    public func setRack(rack : [Character]) {
        pos.setRack(rack:rack);
    }
    public func loadWords() {
        do {
            let wordfile : String = "words.txt";
            // Change relative path with the path from the pc to the folder of the words file
            let relativePath = "/Users/chris/Documents/ScrabbleSolver/ScrabbleSolver"
            let data = try String(contentsOfFile: relativePath+"/"+wordfile, encoding: .utf8).components(separatedBy: .newlines);
            for word in data {
                tree.addWord(l:Array(word)); 
            }
        } catch {
            print(error);
        }
    }
    public func displayWords() {
        tree.displayWords();
    }
    private func checkRight(x:Int,y:Int, n:Node, l:[Character], cur:[Character]) -> [[Character]] {
        var final : [[Character]] = Array();
        if (x > 14 || l.count == 0) {return final;}
        if n.getLetters().count > 1 {final.append(cur)}
        // Already played on board, traverse down tree and continue
        if (pos.isFilled(x:x,y:y)) {
            if (n.checkIfChildExists(c: Character(pos.getChar(x:x,y:y).uppercased()))) {
                var newWord : [Character] = cur;
                newWord.append(pos.getChar(x:x,y:y));
                final.append(contentsOf:checkRight(x:x+1,y:y,n: n.getChild(c:Character(pos.getChar(x:x,y:y).uppercased())), l:l, cur:newWord));
            }
        // No letters played yet, check all letters recursively
        } else {
            for i in 0...l.count-1 {
                // If space, go through every child
                if l[i] == " " {
                    let allChildren : [Character : Node] = n.getAllChildren();
                    var tempRack = l;
                    tempRack.remove(at: i);
                    for j in allChildren.keys {
                        var newWord : [Character] = cur;
                        newWord.append(Character(j.lowercased()));
                        final.append(contentsOf: checkRight(x:x+1,y:y,n:allChildren[j]!,l:tempRack, cur:newWord));
                    }
                } else if n.checkIfChildExists(c:l[i]) {
                    var tempRack = l;
                    tempRack.remove(at: i);
                    var newWord : [Character] = cur;
                    newWord.append(l[i]);
                    final.append(contentsOf: checkRight(x:x+1,y:y,n:n.getChild(c:l[i]),l:tempRack, cur:newWord));
                }
            }
        }
        return final;
    }
    // Lotta copy paste but its necessary because it checks y now instead of x
    private func checkDown(x:Int,y:Int, n:Node, l:[Character], cur:[Character]) -> [[Character]] {
        var final : [[Character]] = Array();
        if (y > 14 || l.count == 0) {return final;}
        if n.getLetters().count > 1 {final.append(cur)}
        // Already played on board, traverse down tree and continue
        if (pos.isFilled(x:x,y:y)) {
            if (n.checkIfChildExists(c: Character(pos.getChar(x:x,y:y).uppercased()))) {
                var newWord : [Character] = cur;
                newWord.append(pos.getChar(x:x,y:y));
                final.append(contentsOf:checkDown(x:x,y:y+1,n: n.getChild(c:Character(pos.getChar(x:x,y:y).uppercased())), l:l, cur:newWord));
            }
        // No letters played yet, check all letters recursively
        } else {
            for i in 0...l.count-1 {
                // If space, go through every child
                if l[i] == " " {
                    let allChildren : [Character : Node] = n.getAllChildren();
                    var tempRack = l;
                    tempRack.remove(at: i);
                    for j in allChildren.keys {
                        var newWord : [Character] = cur;
                        newWord.append(Character(j.lowercased()));
                        final.append(contentsOf: checkDown(x:x,y:y+1,n:allChildren[j]!,l:tempRack, cur:newWord));
                    }
                } else if n.checkIfChildExists(c:l[i]) {
                    var tempRack = l;
                    tempRack.remove(at: i);
                    var newWord : [Character] = cur;
                    newWord.append(l[i]);
                    final.append(contentsOf: checkDown(x:x,y:y+1,n:n.getChild(c:l[i]),l:tempRack, cur:newWord));
                }
            }
        }
        return final;
    }
    public func checkIfCanConnect(x : Int, y:Int, dir: Bool) -> Bool {
        // Down
        if dir {
            for i in y-1...y+6 {
                if !(i == y-1 || i == y+6) {
                    if (pos.isFilled(x:x-1,y:i)) {return true;}
                    if (pos.isFilled(x:x+1,y:i)) {return true;}
                }
                if (pos.isFilled(x:x,y:i)) {return true;}
            }
            return false;
        }
        // Right
        for i in x-1...x+6 {
            if !(i == x-1 || i == x+6) {
                if (pos.isFilled(x:i,y:y-1)) {return true;}
                if (pos.isFilled(x:i,y:y+1)) {return true;}
            }
            if (pos.isFilled(x:x,y:i)) {return true;}
        }
        return false;
    }
    public func newSolve() -> String {
        let final : String = "";
        var foundWords : [String] = Array();
        for dir in 0...1 {
            for y in 0...14 {
                for x in 0...14 {
                    var tempWords : [[Character]] = Array();
                    // Right
                    if (dir == 0) {
                        if (x>0 && pos.isFilled(x:x-1,y:y)) {continue;}
                        if (!checkIfCanConnect(x:x,y:y, dir:false)) {continue;}
                        // "WORD","X","Y","DIRINT"
                        tempWords = checkRight(x:x,y:y,n:tree.getRoot(),l:pos.curPlayerRack, cur:Array())
                    // Down
                    } else {
                        if (y>0 && pos.isFilled(x:x,y:y-1)) {continue;}
                        if (!checkIfCanConnect(x:x,y:y, dir:true)) {continue;}
                        // "WORD","X","Y","DIRINT"
                        tempWords = checkDown(x:x,y:y,n:tree.getRoot(),l:pos.curPlayerRack, cur:Array())
                    }
                    for word in tempWords {
                        let curStr : String = String(word) + " " + String(x) + " " + String(y) + " " + String(dir)
                        foundWords.append(curStr)
                    }
                    foundWords = Array(Set(foundWords)).sorted()
                }
            }
        }
        for word in foundWords {print(word+"\n");}
        return final;
    }
    public func solve() -> String {
        let posWords : [[Character]]  = Array()//= pos.getPossibleWords();
        var moveToScore: [String: Int] = [:]
        for word in posWords {
            let curMoves : [[[Bool]]] = pos.findSpotsForWord(word:word);
            for i in 0...1 {
                for j in 0...14 {
                    for k in 0...14 {
                        // If it passes here, valid move!
                        if (curMoves[i][j][k]) {
                            print("found word!")
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
