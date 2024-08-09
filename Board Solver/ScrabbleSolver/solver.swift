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
    private func checkNewWordsCreated(word : [Character], x : Int, y : Int, dir : Bool) -> Bool {
        // Duplicate board and play next move
        let newBoard : Position = Position(p:pos);
        newBoard.playMove(word:word,x:x,y:y,dir:dir);
        return checkAllWords(b:newBoard);
    }
    func validateSingleWord(w:[Character]) -> Bool {
        return tree.checkIfWordExists(word:w);
    }
    // Validate that all words exist
    func checkAllWords(b : Position) -> Bool {
        var curWord : [Character] = [];
        // Check right first
        for i in 0...14 {
            for j in 0...14 {
                if b.getChar(x:j,y:i) == "0" {
                    if (curWord.count >= 2 && !validateSingleWord(w:curWord)) {return false;}
                    curWord = [];
                    continue;
                }
                curWord.append(b.getChar(x:j,y:i));
            }
            if (curWord.count >= 2 && !validateSingleWord(w:curWord)) {return false;}
            curWord = [];
        }
        // Check down next
        curWord = [];
        for i in 0...14 {
            for j in 0...14 {
                if b.getChar(x:i,y:j) == "0" {
                    if (curWord.count >= 2 && !validateSingleWord(w:curWord)) {return false;}
                    curWord = [];
                    continue;
                }
                curWord.append(b.getChar(x:i,y:j));
            }
            curWord = [];
        }
        if (curWord.count >= 2 && !validateSingleWord(w:curWord)) {return false;}
        return true;
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
                        if (dir == 0) {
                            if (!pos.checkConnected(word:word, x:x, y:y, dir:false)) {continue;}
                            if (!checkNewWordsCreated(word:word, x:x, y:y, dir:false)) {continue;}
                        } else {
                            if (!pos.checkConnected(word:word, x:x, y:y, dir:true)) {continue;}
                            if (!checkNewWordsCreated(word:word, x:x, y:y, dir:false)) {continue;}
                        }
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
}
