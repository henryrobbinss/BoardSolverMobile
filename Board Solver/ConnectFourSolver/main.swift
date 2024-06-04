func CallToSolve() {
    var solver : Solver
    var weak : bool = false
    // Need to implement the .book
    var opening_book : String = "solver/7x6.book"
    solver.loadBook(opening_book);
    var line : String = "172737"
    var P : Position
    if (P.play(line) != line.size()) {
        print("ERROR: Invalid Move: " + P.nbMoves()+1 + " \"" + line + "\"" + "\n")
    } else {
        print(line)
        var scores : [int] = solver.analyze(P, weak);
        for i in range(0,6) {print(" " + scores[i])}
        var score : int = solver.solve(P, weak);
        print(" " + score + "\n");
    }
}