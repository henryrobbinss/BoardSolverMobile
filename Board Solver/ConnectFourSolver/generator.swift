var visited : Set<UInt64>;
func explore(temp: Position, pos_str: String, depth: Int) {
    var key : UInt64 = P.key3();
    if (!visited.insert(key).second) {
        return; // already explored position
    }
    var nb_moves : int = P.nbMoves();
    if(nb_moves <= depth) {print(pos_str + "\n");}
    if (nb_moves >= depth) {return;}
    
    // Explore all possible moves
    for i in 0...Position.WIDTH { 
        if (P.canPlay(i) && !P.isWinningMove(i)) {
            var P2 : Position = Position(P);
            P2.playCol(i);
            pos_str[nb_moves] = "1" + i; // Double check this works... trying to increment ascii
            explore(P2, pos_str, depth);
            pos_str[nb_moves] = 0;
        }
    }

    /**
    * Read scored positions from stdin and store them in an opening book
    *
    * Input lines must be a valid position (possibly empty string), a space and a valid score
    * Read input until EOF or an empty line is reached.
    */
    func generate_opening_book() {
        struct S { 
            static let BOOK_SIZE : Int = 23; // store 2^BOOK_SIZE positions in the book
            static let DEPTH : Int = 14; // max depth of every position to be stored
            static let LOG_3 : Double = 1.58496250072; // log2(3)
        }
        // template<class partial_key_t, class key_t, class value_t, int log_size>
        // Might not fully work... will check later
        var table = TranspositionTable<UInt<Int((S.DEPTH + Position.WIDTH - 1) * S.LOG_3) + 1 - S.BOOK_SIZE>, Position.position_t, UInt8, S.BOOK_SIZE>();
        var count : CLongLong = 1;
        while let line = readLine() {
            if (line.count == 0) {break;} // empty line = end of input
            var iss = InputStream(data: Data(line.utf8));
            var pos : String;
            getline(iss, pos, " "); // Read position before first space character
            var score : int;
            iss >> score;
            count += 1;

            var P : Position;
            if (iss.fail() || !iss.eof() || P.play(pos) != pos.count || score < Position.MIN_SCORE || score > Position.MAX_SCORE) { 
                // a valid line is a position a space and a valid score
                print("Invalid line (line ignored): " + line + "\n");
                continue;
            }
            table.put(P.key3(), score - Position.MIN_SCORE + 1);
            if(count % 1000000 == 0) {print("ERROR: " + count + "\n");}  
        }

        var book = OpeningBook{Position.WIDTH, Position.HEIGHT, S.DEPTH, table}; // Check this line too
        var book_file : String = String();
        book_file = Position.WIDTH + "x" + Position.HEIGHT + ".book";
        book.save(book_file.str());
    }
}
/**
 * If used with a max depth parameter: generate all uniquepsoition upto max depth
 * If no parameter: read scoredposition from standard input to store in an opening book
 */
func main() {
    let arguments = CommandLine.arguments
    if arguments.count > 1 {
        var depth : Int = Int(arguments[1])
        var pos_str : [Character] = String(repeating: "0", count: depth + 1)
        explore(Position(), pos_str, depth)
    } else {
        generate_opening_book();
    }
}