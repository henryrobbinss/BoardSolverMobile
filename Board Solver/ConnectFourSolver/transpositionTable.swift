import Foundation
public class TranspositionTable {
    // Allow for up to 10 million entries in the transposition table (~80mb)
    // Introduces a lot of overhead but is a saving grace with large positions
    private var maxElements : UInt64 = 10_000_000;
    private var table : [UInt : Entry] = [UInt : Entry]();
    private func index(key: UInt64) -> UInt {
        return (UInt)(key%maxElements);
    }
    public func put(key : UInt64, val : UInt8) {
        table[index(key:key)] = Entry(k:key,v:val);
    }
    public func reset() {
        table = [UInt : Entry]();
    }
    // Return either the value at that index or 0 if it isnt the right key
    public func get(key : UInt64) -> UInt8 {
        let curIndex : UInt = index(key:key);
        let val = table[curIndex];
        if (val != nil && val!.key == key) {
            return val!.val;
        }
        return 0;
    }
    init() {}// Dont really do anything sine the array is initialized above
}
