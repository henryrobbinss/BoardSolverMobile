import Foundation;
main();

main();

func getTimeMicrosec() -> CUnsignedLongLong {
    let NOW = Date().timeIntervalSince1970;
    return CUnsignedLongLong(NOW * 1_000_000)
    return CUnsignedLongLong(NOW * 1_000_000)
}
func main() {
    print("Running Code...");
    let solver : Solver = Solver();
    print("Running Code...");
    let solver : Solver = Solver();
    var line : String;
    var l : Int = 1;
    while(true) {
        line = readLine() ?? "";
        if (line == "quit") {
            break;
        }
        if (line == "readfile") {
            let filename : String = "endeasy.txt";
            let numTests : Int = 1000;
            var curPercent : Int = 0;
            var numPositions: UInt64 = 0;
            let relativePath = "/Users/chris/Documents/simplesolver/connect4solver"
            let url = URL( fileURLWithPath: relativePath+"/TestOutputs/"+filename);
            do {
                try "".write(to: url, atomically: true, encoding: .utf8)
                let relativePath = "/Users/chris/Documents/simplesolver/connect4solver"
                let data = try String(contentsOfFile: relativePath+"/TestInputs/"+filename, encoding: .utf8);
                let myStrings = data.components(separatedBy: .newlines);
                var counter : Int = 0;
                let start_time : CUnsignedLongLong = getTimeMicrosec();
                for curLine in myStrings {
                    let inOut = curLine.components(separatedBy: " ");
                    if (inOut.count != 2) {
                        return;
                    }
                    let input : String = inOut[0];
                    let output : String = inOut[1];
                    let P : Position = Position();
                    if (P.play(seq: input) != input.count) {
                        // Invalid pos
                        let outputString = "ERROR: Invalid Line: " + input + "\n"
                        print(outputString);
                        if let fileHandle = FileHandle(forWritingAtPath: url.path) {
                            // Append to file
                            fileHandle.seekToEndOfFile()
                            fileHandle.write(outputString.data(using: .utf8)!)
                            fileHandle.closeFile()
                        } else {
                            // File doesn't exist, create a new one and write
                            try outputString.write(to: url, atomically: true, encoding: .utf8)
                        }
                    } else {
                        solver.resetTable();
                        let score : Int = solver.solve(P:P);
                        numPositions += UInt64(solver.getNodeCount());
                        if (score != Int(output)) {
                            let outputString = "ERROR: Invalid Score: " + String(score) + " | " + output + "\n"
                            print(outputString);
                            P.display();
                            print(input);
                            if let fileHandle = FileHandle(forWritingAtPath: url.path) {
                                // Append to file
                                fileHandle.seekToEndOfFile()
                                fileHandle.write(outputString.data(using: .utf8)!)
                                fileHandle.closeFile()
                            } else {
                                // File doesn't exist, create a new one and write
                                try outputString.write(to: url, atomically: true, encoding: .utf8)
                            }
                        }
                    }
                    counter += 1;
                    let cur_time : CUnsignedLongLong = getTimeMicrosec();
                    if (counter*100/numTests > curPercent) {
                        curPercent = counter*100/numTests;
                        print(String(curPercent) + "% done in " + String(cur_time-start_time));
                    }
                }
                print("Avg Num Positions: " + String(numPositions/1000));
            } catch {
                print(error)
            }
            return;
        }
        let P : Position = Position();
        if (P.play(seq: line) != line.count) {
            print("Line << " + String(l) + ": Invalid move " + String((P.nbMoves() + 1)) + " \"" + String(line) + "\"");
        } else {
            let start_time : CUnsignedLongLong = getTimeMicrosec();
            let score : Int = solver.solve(P:P);
            let end_time : CUnsignedLongLong = getTimeMicrosec();
            print(line + " " + String(score) + " " + String(solver.getNodeCount()) + " " + String((end_time - start_time)));
            let start_time : CUnsignedLongLong = getTimeMicrosec();
            let score : Int = solver.solve(P:P);
            let end_time : CUnsignedLongLong = getTimeMicrosec();
            print(line + " " + String(score) + " " + String(solver.getNodeCount()) + " " + String((end_time - start_time)));
        }
        l += 1;
    }
}

