import Foundation
public class Trie {
    private var root : Node;
    public func addWord(l:[Character]) {
        root.addWord(l:l, index:0);
    }
    public func getRoot() -> Node {
        return root;
    }
    // For testing purposes, prints out all the nodes of the tree and their children
    public func displayWords() {
        displaySingleWord(n:root);
    }
    public func displaySingleWord(n : Node) {
        let tempDict : [Character : Node] = n.getAllChildren();
        for i in tempDict.keys {
            print("Parent: " + String(n.getLetters()));
            print("Child: " + String(i))
            displaySingleWord(n:tempDict[i]!);
        }
    }
    public func checkIfWordExists(word : [Character]) -> Bool {
        var cur : Node = root;
        for i in word {
            if cur.checkIfChildExists(c:i) {
                cur = cur.getChild(c:i);
            } else {return false;}
        }
        if cur.getLetters().count >= 2 {return true;}
        return false;
    }
    init() {
        root = Node();
    }
}
