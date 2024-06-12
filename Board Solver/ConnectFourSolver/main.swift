import Foundation;
func getTimeMicrosec() -> CUnsignedLongLong {
    let NOW = Date().timeIntervalSince1970;
    return CUnsignedLongLong(NOW * 1_000_000)   
}

func main() {
    var solver : Solver;
    var line : String;
    var l : Int = 1;
    while(true) {
        line = readLine() ?? "";
        if (line == "quit") {
            break;
        }
        var P : Position;
        if (P.play(line) != line.count) {
            print("Line << " + l + ": Invalid move " + (P.nbMoves() + 1) + " \"" + line);
        } else {
            var start_time : CUnsignedLongLong = getTimeMicrosec();
            var score : Int = solver.solve(P);
            var end_time : CUnsignedLongLong = getTimeMicrosec();
            print(line + " " + score + " " + solver.getNodeCount() + " " + (end_time - start_time));
        }
        l += 1;
    }
}