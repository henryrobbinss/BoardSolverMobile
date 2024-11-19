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
    init(path: String) {
        //init with given board (input is string path to board file)
        tree = Trie();
        //iterate through each tile and create position board
        var b: [[Character]] = Array(repeating: Array(repeating: "*", count: 15), count: 15);
        let rows: [String] = path.components(separatedBy: .newlines);
        var x: Int = 0;
        var y: Int = 0;
        //for each y value (each row)
        for curRow: String in rows {
            x = 0;
            if(curRow.isEmpty) {
                continue;
            }
            let lineArr : [String] = curRow.components(separatedBy: " ");
            if (lineArr.count != 15) {
                print ("ERROR: lineArr is not length 15");
                break;
            }
            //for each tile in x direction of current row
            for curTile: String in lineArr {
                if(curTile.count != 1) {
                    print ("ERROR: current tile is not length 1 (1 character)");
                    break;
                }
                
                var tile : Character = Character(curTile);
                b[y][x]=tile;
                x += 1;
            }
            y += 1;
        }
        
        pos = Position(b: b);

    }

    public func playMove(word : [Character], x : Int, y : Int, dir: Bool, debug: Bool) {
        pos.playMove(word:word,x:x,y:y,dir:dir, debug: debug);
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
            //let relativePath = "/Users/chris/Documents/ScrabbleSolver/ScrabbleSolver"
            let relativePath = "/Users/spauln/Documents/GitHub/BoardSolverMobile/Board Solver/ScrabbleSolver"
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

    /*
    Function that takes parameters:
        x, y (Int)          - x, y location of current  
        n (Node)            - root node of solver tree
        l (Char Array)      - current player rack
        cur (Char Array)    - empty array
    Returns:
        2d array of Characters containing all possible words
    */
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
                    var tempRack: [Character] = l;
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

    /*
        params - int x, int y, bool dir (false -> right, true -> down)

        For a given square (y, x), checks if there is room on either side
        to connect to a word or if all of the neighboring squares are full
        in the direction of the word that is to be played.
    */
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
    private func checkNewWordsCreated(word : [Character], x : Int, y : Int, dir : Bool, debug: Bool) -> Bool {
        // Duplicate board and play next move
        if(debug) {
            print("checkpoint 7");
        }
        let newBoard : Position = Position(p:pos);
        if(debug) {
            print("checkpoint 8");
        }
        newBoard.playMove(word:word,x:x,y:y,dir:dir, debug: debug);
        if(debug) {
            print("checkpoint 9");
        }
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
        var testTrigger = false; //variable used for printline debugging on windows, ignore
        var final : String = "";
        var finalscore: Int = 0;
        var finalx: Int = -1;
        var finaly: Int = -1;
        var finaldir: Int = -1;
        var foundWords : [String] = Array();
        for dir: Int in 0...1 {
            for y in 0...14 {
                for x in 0...14 {
                    var tempWords : [[Character]] = Array();
                    // Right
                    if (dir == 0) {
                         if(testTrigger) {
                            print("x " + String(x) + " y " + String(y));
                        }
                        if (x>0 && pos.isFilled(x:x-1,y:y)) {continue;}
                        if (!checkIfCanConnect(x:x,y:y, dir:false)) {continue;}
                        // "WORD","X","Y","DIRINT"
                        tempWords = checkRight(x:x,y:y,n:tree.getRoot(),l:pos.curPlayerRack, cur:Array())
                    // Down
                    } else {
                        if(testTrigger) {
                            print("x " + String(x) + " y " + String(y));
                        }
                        if (y>0 && pos.isFilled(x:x,y:y-1)) {continue;}

                        if (!checkIfCanConnect(x:x,y:y, dir:true)) {continue;}

                        // "WORD","X","Y","DIRINT"
                        tempWords = checkDown(x:x,y:y,n:tree.getRoot(),l:pos.curPlayerRack, cur:Array())

                    }
                    for word in tempWords {
                        //right
                        if (dir == 0) {
                            if (!pos.checkConnected(word:word, x:x, y:y, dir:false)) {continue;}
                            if (!checkNewWordsCreated(word:word, x:x, y:y, dir:false, debug: false)) {continue;}
                        //down
                        } else {
                            if (!pos.checkConnected(word:word, x:x, y:y, dir:true)) {continue;}                            
                            if (!checkNewWordsCreated(word:word, x:x, y:y, dir:true, debug: false)) {continue;}

                        }
                        //if made it this far, score word right is false, :
                        let scoreval = pos.scoreWord(word:word, x:x, y:y, dir:dir != 0);
                        let score: String = String(scoreval);
                        let curStr : String = String(word) + " " + String(x) + " " + String(y) + " " + String(dir) + " s " + score;
                        if(scoreval > finalscore) {
                            finalscore = scoreval;
                            final = String(word);
                            finalx = x;
                            finaly = y;
                            finaldir = dir;
                        }
                        foundWords.append(curStr)
                        print(curStr);
                    }
                    foundWords = Array(Set(foundWords)).sorted()
                }
            }
        }
        for word in foundWords {print(word+"\n");}
        if(finalx != -1) {
            print("FINAL:  ")
            print(final);
            print("score " + String(finalscore));
            print("x: " + String(finalx) + " y: " + String(finaly));
            if(finaldir == 0) {
                print("right");
            } else {
                print("down");
            }
        } else {
            print("no valid moves")
        }
        
        return final;
        
    }

    public func testScore(word:[Character],x:Int, y:Int,dir:Bool) {
        print("*******");
        
        print( String(word) + " x: " + String(x) + " y: " + String(y) + " score: " + String(pos.scoreWord(word:word,x:x, y:y,dir:false)));

        print("*******");
    }


    public func testerFunction() {
        var x = 0;
        var y = 1;
        var word: [Character] = Array()
        word.append(Character("T"));
        word.append(Character("E"));
        word.append(Character("E"));

        print("*******");
        
        print( String(word) + " x: " + String(x) + " y: " + String(y) + " score: " + String(pos.scoreWord(word:word,x:x, y:y,dir:false)));

        print("*******");
    }
}
