import Foundation
public class Entry {
    public var key : UInt64 = 0;
    public var val : UInt8 = 0;
    init() {} // Init doesnt do anything, variables are already accessible.
    init(k : UInt64, v : UInt8) {
        key = k;
        val = v;
    }
}
