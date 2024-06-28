import Foundation
// 0,0 in the board is the top left
public class Position {
    static let width = 15; // Board height
    static let height = 15; // Board width
    static let tw = [0:true,7:true,14:true,105:true,119:true,210:true,217:true,224:true];
    static let dw = [16:true,28:true,32:true,42:true,48:true,56:true,64:true,70:true,154:true,160:true,168:true,176:true,182:true,192:true,196:true,208:true];
    static let tl = [20:true,24:true,76:true,80:true,84:true,88:true,136:true,140:true,144:true,148:true,200:true,204:true];
    static let dl = [3:true,11:true,36:true,38:true,45:true,52:true,59:true,92:true,96:true,98:true,102:true,108:true,116:true,122:true,126:true,128:true,132:true,165:true,172:true,179:true,186:true,188:true,213:true,221:true];
    // Create an empty 15x15 char board(all values are 0)
    var board : [[Character]] = Array();
    var curPlayerRack : [Character] = Array();
    // By knowing how many you have in the rack, and how many you have played, you know if the bag is empty
    // Becuase 100 - num in your rack - num played = num unseen
    // Other players rack can be considered part of the bag since its all unseen, until a piece is seen
    // or until the bag is known to be empty (100 - num in your rack - num played) <= 7
    var numPlayed : UInt8 = 0;
    // Displays a board for use in debugging
    func displayBoard() {
        var counter : Int = 0;
        for i : Int in 0...Position.height-1 {
            var curLine : String = "";
            for j : Int in 0...Position.height-1 {
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
    func removeFromArr(c : Character, a : [Character]) -> [Character] {
        var cpy : [Character] = a;
        if let index = a.firstIndex(where: {$0 == c}) {
            cpy.remove(at: index);
        }
        return cpy;
    }
    // plays a move given the word, position, and direction
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
    
    // Initialize by copying a board
    init(rack : [Character], curBoard : [[Character]], played : UInt8) {
        curPlayerRack = rack;
        board = curBoard;
        numPlayed = played;
    }
    // Initialize a new board
    init(rack : [Character]) {
        curPlayerRack = rack;
        board = Array(repeating: Array(repeating: "0", count: 15), count: 15);
    } // Board is initialized when declared above
}
