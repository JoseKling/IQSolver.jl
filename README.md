# [IQSolver](https://josekling.github.io/IQSolver.jl)

This is a simple package for solving the [IQ Puzzler Pro](https://www.smartgames.eu/uk/one-player-games/iq-puzzler-pro)
game. It works for all three variantes of the game, including the 3D pyramid!.

It uses a [backtracking algorithm](https://en.wikipedia.org/wiki/Backtracking)
to solve the game, recursing on disconnected empty regions on the board. Although 
it is really cool to see it solving the puzzle, the plotting is too slow, so
only the initial and final states are shown.

To see it in action, first install it.

```julia
using Pkg
Pkg.add("https://github.com/JoseKling/IQSolver.jl.git")
using IQSolver
```

And then simply run this command to solve a specific stage.

```julia
solve(80)
```

For more information, check out the [**Documentation**](https://josekling.github.io/IQSolver.jl).
