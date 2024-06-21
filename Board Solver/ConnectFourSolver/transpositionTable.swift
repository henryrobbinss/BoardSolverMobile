// This code is merely a translation and remake of the solver by Pascal Pons
// The code way originaly written in C++, and through the use of his GitHub and site, it has been rewritten for
// Swift for BoardSolver. It is a fair bit slower than his model, but by utilizing a maximum depth check, it can
// Output a response in a fast time.

import Foundation
public class TranspositionTable {
    // Allow for up to 10 million entries in the transposition table (~80mb)
    // Introduces a lot of overhead but is a saving grace with large positions
    private var key_size : UInt = 49;
    private var value_size : UInt = 7;
    private var log_size : UInt = 23;
    private var size : size_t = 8388617;
    private var thirtytwobitmask : UInt64 = 4294967295;
    private var K : UnsafeMutablePointer<uint_least32_t>
    private var V : UnsafeMutablePointer<uint_least8_t>
    
    private func index(key: UInt64) -> size_t {
        return size_t(key)%size;
    }
    public func put(key : UInt64, val : uint_least8_t) {
        let pos : size_t = index(key:key);
            K[pos] = uint_least32_t(key & thirtytwobitmask);
            V[pos] = val;
    }
    public func reset() {
        K = UnsafeMutablePointer<uint_least32_t>.allocate(capacity: size);
        V = UnsafeMutablePointer<uint_least8_t>.allocate(capacity: size);
    }
    // Return either the value at that index or 0 if it isnt the right key
    public func get(key : UInt64) -> uint_least8_t {
        let pos : size_t = index(key:key);
        if(K[pos] == uint_least32_t(key & thirtytwobitmask)) {return uint_least8_t(V[pos]);}
        else {return 0;}
    }
    init() {
        K = UnsafeMutablePointer<uint_least32_t>.allocate(capacity: size);
        V = UnsafeMutablePointer<uint_least8_t>.allocate(capacity: size);
    }
}
