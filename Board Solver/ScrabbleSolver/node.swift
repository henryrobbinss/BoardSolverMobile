import Foundation
public class Node {
    private var children : [Character : Node];
    private var letters : [Character];
    public func getLetters() -> [Character] {
        return letters;
    }
    public func checkIfChildExists(c : Character) -> Bool {
        return children.keys.contains(c);
    }
    public func getChild(c : Character) -> Node {
        return children[c]!;
    }
    // For testing purposes
    public func getAllChildren() -> [Character : Node] {
        return children;
    }
    public func addWord(l : [Character], index : Int) {
        // If the node was added and its the word as the letters
        if (l.count <= index) {return;}
        // If child exists traverse down the tree
        if checkIfChildExists(c:l[index]) {
            return getChild(c:l[index]).addWord(l:l, index:index+1);
        // Else add the next node in the children section and traverse
        } else {
            children[l[index]] = Node(l:l, index:index);
            return getChild(c:l[index]).addWord(l:l, index:index+1);
        }
    }
    init(l : [Character], index : Int) {
        // If this is the end of the word, put the word as the letters
        
        if (index >= l.count - 1) {
            letters = l;
        } else {
            letters = [l[index]];
        }
        children = [:];
    }
    // For root node
    // Init all empty variables
    init() {
        letters = [];
        children = [:];
    }
}
