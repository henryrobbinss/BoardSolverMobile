// This code is merely a translation and remake of the solver by Pascal Pons
// The code way originaly written in C++, and through the use of his GitHub and site, it has been rewritten for
// Swift for BoardSolver. It is a fair bit slower than his model, but by utilizing a maximum depth check, it can
// Output a response in a fast time.

import Foundation
public class MoveSorter {
    var sortedArr: [Entry] = [Entry]();
    func add(move : UInt64, score : Int) {
        sortedArr.append(Entry(k: move, v : UInt8(score)));
        sortedArr.sort(by: {entry1, entry2 in
            entry1.val < entry2.val;
        })
    }
    func getNext() -> UInt64 {
        if (sortedArr.count == 0) {
            return 0;
        }
        let val : UInt64 = sortedArr[sortedArr.count-1].key;
        sortedArr.removeLast();
        return val;
    }
    init() {} // Doesnt really do anything of importance
}
