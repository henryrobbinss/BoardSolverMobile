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
