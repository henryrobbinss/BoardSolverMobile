import Foundation;
main();

func getTimeMicrosec() -> CUnsignedLongLong {
    let NOW = Date().timeIntervalSince1970;
    return CUnsignedLongLong(NOW * 1_000_000)
}
func main() {
    print("Running Code...");
    let solver : Solver = Solver();
    var line : String;
    var l : Int = 1;
    while(true) {
        line = readLine() ?? "";
        if (line == "quit") {
            break;
        }
        let P : Position = Position();
        if (P.play(seq: line) != line.count) {
            print("Line << " + String(l) + ": Invalid move " + String((P.nbMoves() + 1)) + " \"" + String(line) + "\"");
        } else {
            let start_time : CUnsignedLongLong = getTimeMicrosec();
            let score : Int = solver.solve(P:P);
            let end_time : CUnsignedLongLong = getTimeMicrosec();
            print(line + " " + String(score) + " " + String(solver.getNodeCount()) + " " + String((end_time - start_time)));
        }
        l += 1;
    }
}
