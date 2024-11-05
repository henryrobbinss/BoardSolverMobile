import Foundation
// 0,0 in the board is the top left
public class Position {
    static let width = 15; // Board height
    static let height = 15; // Board width
    static let tw = [0:true,7:true,14:true,105:true,119:true,210:true,217:true,224:true];
    static let dw = [16:true,28:true,32:true,42:true,48:true,56:true,64:true,70:true,154:true,160:true,168:true,176:true,182:true,192:true,196:true,208:true];
    static let tl = [20:true,24:true,76:true,80:true,84:true,88:true,136:true,140:true,144:true,148:true,200:true,204:true];
    static let dl = [3:true,11:true,36:true,38:true,45:true,52:true,59:true,92:true,96:true,98:true,102:true,108:true,116:true,122:true,126:true,128:true,132:true,165:true,172:true,179:true,186:true,188:true,213:true,221:true];
    static let tileScore : [Character:Int] = ["A":1,"B":3,"C":3,"D":2,"E":1,"F":4,"G":2,"H":4,"I":1,"J":8,"K":5,"L":1,"M":3,"N":1,"O":1,"P":3,"Q":10,"R":1,"S":1,"T":1,"U":1,"V":4,"W":4,"X":8,"Y":4,"Z":10," ":0];
    
    // Create an empty 15x15 char board(all values are 0)
    var board : [[Character]] = Array();
    var curPlayerRack : [Character] = Array();
    // By knowing how many you have in the rack, and how many you have played, you know if the bag is empty
    // Becuase 100 - num in your rack - num played = num unseen
    // Other players rack can be considered part of the bag since its all unseen, until a piece is seen
    // or until the bag is known to be empty (100 - num in your rack - num played) <= 7
    // Displays a board for use in debugging
    func displayBoard() {
        var counter : Int = 0;
        for i : Int in 0...Position.height-1 {
            var curLine : String = "";
            for j : Int in 0...Position.width-1 {
                curLine += " ";
                var curChar : Character = "·";
                if (Position.tw[counter] != nil) {
                    curChar = "%";
                } else if (Position.dw[counter] != nil) {
                    curChar = "$";
                } else if (Position.tl[counter] != nil) {
                    curChar = "#";
                } else if (Position.dl[counter] != nil) {
                    curChar = "*";
                }
                if (board[i][j] != "0") {
                    curChar = board[i][j];
                }
                counter += 1;
                curLine += String(curChar);
            }
            print(curLine);
        }
    }
    func displayBoard(b: [[Character]]) {
        var counter : Int = 0;
        for i : Int in 0...Position.height-1 {
            var curLine : String = "";
            for j : Int in 0...Position.width-1 {
                curLine += " ";
                var curChar : Character = "·";
                if (Position.tw[counter] != nil) {
                    curChar = "%";
                } else if (Position.dw[counter] != nil) {
                    curChar = "$";
                } else if (Position.tl[counter] != nil) {
                    curChar = "#";
                } else if (Position.dl[counter] != nil) {
                    curChar = "*";
                }
                if (b[i][j] != "0") {
                    curChar = b[i][j];
                }
                counter += 1;
                curLine += String(curChar);
            }
            print(curLine);
        }
    }
    public func getRack() -> [Character] {
        return curPlayerRack;
    }
    public func getFullBoard() -> [[Character]] {
        return board;
    }

    /*
        params - int x, int y, coordinates on board to check

        If the coordinates are out of bounds of the board, returns false
        else returns true that the square is filled if there is any character 
        other than "0".
    */
    public func isFilled(x: Int, y: Int) -> Bool {
        if (x < 0 || x > 14 || y < 0 || y > 14) {return false;}
        return board[y][x] != "0";
    }
    public func getChar(x:Int, y:Int) -> Character {
        return board[y][x];
    }
    func removeFromArr(c : Character, a : [Character]) -> [Character] {
        var cpy : [Character] = a;
        if let index = a.firstIndex(where: {$0 == c}) {
            cpy.remove(at: index);
        }
        return cpy;
    }
    // plays a move given the word, position, and direction
    // Does not check if word can be placed there
    func playMove(word : [Character], x : Int, y : Int, dir: Bool) {
        // Add word to board and remove from rack
        for i in 0...word.count-1 {
            if (dir && board[y+i][x] == "0") {
                curPlayerRack = removeFromArr(c: word[i], a: curPlayerRack);
                board[y+i][x] = word[i];
            } else if (!dir && board[y][x+i] == "0"){
                curPlayerRack = removeFromArr(c: word[i], a: curPlayerRack);
                board[y][x+i] = word[i];
            }
        }
    }
    func scoreMove(word : [Character], x : Int, y : Int, dir : Bool) -> Int {
        var score : Int = 0;
        // Get new board with word added
        var newBoard : [[Character]] = Array(repeating: Array(repeating: "0", count: 15), count: 15);
        for i in 0...14 {
            for j in 0...14 {
                newBoard[i][j] = board[i][j];
            }
        }
        for i in 0...word.count-1 {
            if (dir) {
                newBoard[y+i][x] = word[i];
                continue;
            }
            newBoard[y][x+i] = word[i];
        }
        // List of bonuses that are applied this turn and on what squares
        var doubleL : Set<Int> = [];
        var tripleL : Set<Int> = [];
        var doubleW : Set<Int> = [];
        var tripleW : Set<Int> = [];
        // Get difference (what was added this turn)
        var diff : [[Character]] = Array(repeating: Array(repeating: "0", count: 15), count: 15);
        var count = 0;
        var diffCount : Int = 0;
        for i in 0...14 {
            for j in 0...14 {
                if (newBoard[i][j] != board[i][j]) {
                    diff[i][j] = newBoard[i][j];
                    diffCount = diffCount + 1;
                    if (Position.dl[count] ?? false) {doubleL.insert(count);}
                    else if (Position.tl[count] ?? false) {tripleL.insert(count);}
                    else if (Position.dw[count] ?? false) {doubleW.insert(count);}
                    else if (Position.tw[count] ?? false) {tripleW.insert(count);}
                }
                count = count + 1;
            }
        }
        if (diffCount == 7) {score = score + 50;}
        // Down
        if (dir) {
            // Check main word score
            var curWordScore : Int = 0;
            for i in 0...word.count-1 {
                // Check for dl/tl
                if (doubleL.contains((y+i)*15+x)) {
                    curWordScore = curWordScore + 2*Position.tileScore[word[i]]!;
                } else if (tripleL.contains((y+i)*15+x)) {
                    curWordScore = curWordScore + 3*Position.tileScore[word[i]]!;
                } else {
                    curWordScore = curWordScore + Position.tileScore[word[i]]!;
                }
            }
            // Check for dw/tw
            for _ in doubleW {
                curWordScore = curWordScore * 2;
            }
            for _ in tripleW {
                curWordScore = curWordScore * 2;
            }
            score = score + curWordScore;
            // Check words to the right
            for i in 0...word.count-1 {
                if (diff[y+i][x] == "0") {continue;} // If word sideways wasnt altered at all
                curWordScore = 0;
                // Set curX to the leftmost letter in the word
                var curX : Int = x;
                while(curX > 0) {
                    if (newBoard[y+i][curX] != "0") { curX = curX - 1;} else {curX = curX + 1; break;}
                }
                var curLength : Int = 1;
                while (curX+curLength <= 14) {
                    if (newBoard[y+i][curX+curLength] != "0") { curLength = curLength + 1;} else {break;}
                }
                // Skip the word if it is length 1
                if (curLength < 2) {continue;}
                for j in 0...curLength-1 {
                    curWordScore = curWordScore + Position.tileScore[newBoard[y+i][curX+j]]!;
                }
                // Since only 1 tile can have the bonus...
                if (doubleL.contains((y+i)*15+x)) {
                    curWordScore = curWordScore + Position.tileScore[word[i]]!;
                } else if (tripleL.contains((y+i)*15+x)) {
                    curWordScore = curWordScore + 2*Position.tileScore[word[i]]!;
                } else if (doubleW.contains((y+i)*15+x)) {
                    curWordScore = curWordScore * 2;
                } else if (tripleW.contains((y+i)*15+x)) {
                    curWordScore = curWordScore * 3;
                }
                score = score + curWordScore;
            }
            return score;
        }
        // Right
        // Check main word score
        var curWordScore : Int = 0;
        for i in 0...word.count-1 {
            // Check for dl/tl
            if (doubleL.contains(y*15+x+i)) {
                curWordScore = curWordScore + 2*Position.tileScore[word[i]]!;
            } else if (tripleL.contains(y*15+x+i)) {
                curWordScore = curWordScore + 3*Position.tileScore[word[i]]!;
            } else {
                curWordScore = curWordScore + Position.tileScore[word[i]]!;
            }
        }
        // Check for dw/tw
        for _ in doubleW {
            curWordScore = curWordScore * 2;
        }
        for _ in tripleW {
            curWordScore = curWordScore * 2;
        }
        score = score + curWordScore;
        // Check words down
        for i in 0...word.count-1 {
            if (diff[y][x+i] == "0") {continue;} // If word downwards wasnt altered at all
            curWordScore = 0;
            // Set curY to the topmost letter in the word
            var curY : Int = y;
            while(curY > 0) {
                if (newBoard[curY][x+i] != "0") { curY = curY - 1;} else {curY = curY + 1; break;}
            }
            var curLength : Int = 1;
            while (curY+curLength <= 14) {
                if (newBoard[curY+curLength][x+i] != "0") { curLength = curLength + 1;} else {break;}
            }
            // Skip the word if it is length 1
            if (curLength < 2) {continue;}
            for j in 0...curLength-1 {
                curWordScore = curWordScore + Position.tileScore[newBoard[curY+j][x+i]]!;
            }
            // Since only 1 tile can have the bonus...
            if (doubleL.contains(y*15+x+i)) {
                curWordScore = curWordScore + Position.tileScore[word[i]]!;
            } else if (tripleL.contains(y*15+x+i)) {
                curWordScore = curWordScore + 2*Position.tileScore[word[i]]!;
            } else if (doubleW.contains(y*15+x+i)) {
                curWordScore = curWordScore * 2;
            } else if (tripleW.contains(y*15+x+i)) {
                curWordScore = curWordScore * 3;
            }
            score = score + curWordScore;
        }
        return score;
    }
    
    func scoreWord(word : [Character], x : Int, y : Int, dir : Bool) -> Int {
        //ASSUMES GIVEN WORD is valid!!! both in the dictionary and on a valid square, will not go out of bounds
        var mainWScore = 0;
        var adjScore = 0;
        var i = x;
        var j = y;
        var main_dw = 0;
        var main_tw = 0;
        for curLetter: Character in word {
            //check if already present on the board! if so, add ONLY tile value to score and continue to next letter
            var loc_1d = j*15 + i;
            print("*curletter: " + String(curLetter) + " loc 1d " + String(loc_1d));
            //check current squares tl, dl, tw, dw: (compute 1d array equiv and check if in each)
            let cur_tl = Position.tl[loc_1d] != nil;
            let cur_dl = Position.dl[loc_1d] != nil;
            let cur_tw = Position.tw[loc_1d] != nil;
            let cur_dw = Position.dw[loc_1d] != nil;

            //if alr present in board, add current val to main word score
            if(board[j][i] == curLetter) {
                mainWScore += Position.tileScore[curLetter]!;
                if(!dir) {
                    i = i+1;
                } else {
                    j = j+1;
                }
            } else {
                //right
                if(!dir) {     
                    //check up and down to see if this is connecting to a new word
                    var connected = false;
                    var component_score = 0;
                    //up
                    if(isFilled(x: i, y: j-1)) {
                        connected = true;
                        var a = j-1;
                        while(isFilled(x: i, y: a)) {
                            component_score += Position.tileScore[board[a][i]]!
                            a = a-1;
                        }
                    }
                    //down
                    if(isFilled(x: i, y: j+1)) {
                        connected = true;
                        var a = j+1;
                        while(isFilled(x: i, y: a)) {
                            component_score += Position.tileScore[board[a][i]]!
                            a = a+1;
                        }
                    }

                    var cur_letter_points = Position.tileScore[curLetter]!;
                    if(cur_dl) {
                        cur_letter_points *= 2;
                    }
                    if(cur_tl) {
                        cur_letter_points *= 3;
                    }

                    if(connected) {
                        print("connected");               

                        component_score += cur_letter_points;
                    } 

                    if(cur_dw) {
                        main_dw += 1;
                        if(connected) {
                            component_score *= 2;
                        }
                    }
                    if(cur_tw) {
                        main_tw += 1;
                        if(connected) {
                            component_score *= 3;
                        }
                    }
                    
                    //if not connected to anything, component score = 0, s just add to adjscore
                    adjScore += component_score;
                    mainWScore += cur_letter_points;    
                    print("main score: " + String(mainWScore)); 
                    i = i+1;

                //down
                } else {
                    //check left and right to see if this is connecting to a new word
                    var connected = false;
                    var component_score = 0;
                    //left
                    if(isFilled(x: i-1, y: j)) {
                        connected = true;
                        var a = i-1;
                        while(isFilled(x: a, y: j)) {
                            component_score += Position.tileScore[board[j][a]]!
                            a = a-1;
                        }
                    }
                    //right
                    if(isFilled(x: i+1, y: j)) {
                        connected = true;
                        var a = i+1;
                        while(isFilled(x: a, y: j)) {
                            component_score += Position.tileScore[board[j][a]]!
                            a = a+1;
                        }
                    }

                    var cur_letter_points = Position.tileScore[curLetter]!;
                    if(cur_dl) {
                        cur_letter_points *= 2;
                    }
                    if(cur_tl) {
                        cur_letter_points *= 3;
                    }

                    if(connected) {
                        component_score += cur_letter_points;
                    } 

                    if(cur_dw) {
                        main_dw += 1;
                        if(connected) {
                            component_score *= 2;
                        }
                    }
                    if(cur_tw) {
                        main_tw += 1;
                        if(connected) {
                            component_score *= 3;
                        }
                    }
                    
                    //if not connected to anything, component score = 0, s just add to adjscore
                    adjScore += component_score;
                    mainWScore += cur_letter_points;                    
                    j = j+1;
                }
            }
        }
        //apply bonuses to main word and condense scores to final score
        if(main_dw != 0) {
            for d: Int in 1...main_dw {
                mainWScore *= 2;
            }
        }
        if(main_tw != 0) {
            for t: Int in 1...main_tw {
                mainWScore *= 3;
            }
        }
        if(word.count == 7) {
            mainWScore += 50;
        }
        return mainWScore + adjScore;
    }

    // Precondition: word at this x and y wont go out of bounds in the direction listed
    func checkConnected(word : [Character], x : Int, y : Int, dir : Bool) -> Bool {
        if (dir) {
            // Check for letters placed inside this word already or connected to 7,7
            for i in 0...word.count-1 {
                if (board[y+i][x] == "0" && !(x == 7 && y+i == 7)) {continue;}
                return true;
            }
            // Check before and after word
            if (y > 0) {
                if board[y-1][x] != "0" {return true;}
            }
            if (y+word.count-1 < 14) {
                if board[y+word.count][x] != "0" {return true;}
            }
            // Check left and right sides
            for i in 0...word.count-1 {
                if (x > 0) {
                    if board[y+i][x-1] != "0" {return true;}
                }
                if (x < 14) {
                    if board[y+i][x+1] != "0" {return true;}
                }
            }
            return false;
        }
    for i in 0...word.count-1 {
        if (board[y][x+i] == "0" && !(x+i == 7 && y == 7)) {continue;}
        return true;
    }
    // Check before and after word
    if (x > 0) {
        if board[y][x-1] != "0" {return true;}
    }
    if (x+word.count-1 < 14) {
        if board[y][x+word.count] != "0" {return true;}
    }
    // Check top and bottom sides
    for i in 0...word.count-1 {
        if (y > 0) {
            if board[y-1][x+i] != "0" {return true;}
        }
        if (y < 14) {
            if board[y+1][x+i] != "0" {return true;}
        }
    }
    return false;
    }
    public func setRack(rack : [Character]) {
        curPlayerRack = rack;
    }
    // Initialize a new board
    init(rack : [Character]) {
        curPlayerRack = rack;
        board = Array(repeating: Array(repeating: "0", count: 15), count: 15);

    }
    init() {
        curPlayerRack = Array();
        board = Array(repeating: Array(repeating: "0", count: 15), count: 15);
    }
    init(p : Position) {
        curPlayerRack = p.getRack();
        board = p.getFullBoard().map{$0.map{$0}};
    }
    init(b: [[Character]]) {
        curPlayerRack = Array();
        board = b;
    }
    
}
