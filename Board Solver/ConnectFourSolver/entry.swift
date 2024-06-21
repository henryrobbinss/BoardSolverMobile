// This code is merely a translation and remake of the solver by Pascal Pons
// The code way originaly written in C++, and through the use of his GitHub and site, it has been rewritten for
// Swift for BoardSolver. It is a fair bit slower than his model, but by utilizing a maximum depth check, it can
// Output a response in a fast time.

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
