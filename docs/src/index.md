# IQSolver.jl Documentation

```@contents
```

## Introduction

This is a simple package for solving the [IQ Puzzler Pro](https://www.smartgames.eu/uk/one-player-games/iq-puzzler-pro)
game.

It uses a [backtracking algorithm](https://en.wikipedia.org/wiki/Backtracking)
to solve the game, recursing on disconnected empty regions on the board. It shows
the process of finding a solution, which is quite addictive to stare at.

For now it can only solve the 2D puzzles and only some levels from this specific
variant of the game are implemented. This can probably be easily extended to 
other variants.

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

## Data types

```@docs
Piece
Board
Region
```

## Basic functions

```@docs
solve
image
make_board
```

## Original game

```@docs
game_pieces
standard_board
diagonal_board
build_stage
```

## Index

```@index
```
