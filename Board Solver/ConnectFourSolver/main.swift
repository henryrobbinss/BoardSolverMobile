func CallToSolve() {
    var solver : Solver
    var weak : Bool = false
    // Need to implement the .book
    var opening_book : String = "solver/7x6.book"
    solver.loadBook(opening_book);
    var line : String = "172737"
    var P : Position
    if (P.play(line) != line.count) {
        print("ERROR: Invalid Move: " + P.nbMoves()+1 + " \"" + line + "\"" + "\n")
    } else {
        print(line)
        var scores : [Int] = solver.analyze(P, weak);
        for i in 0...Position.Width-1 {print(" " + scores[i])}
        var score : Int = solver.solve(P, weak);
        print(" " + score + "\n");
    }
}

func main() {
    CallToSolve();
}