"""
Implements the solving algorithm.

This is, in essence, a simple backtracking algorithm. It goes through every
`Cell` on the `Board` and tries to place a `Piece`. If it fails, it goes back
to th previous `Cell`.

Some details:

The algorithm runs recursively on the list of disconnected empty `Region`s on
the `Board` in ascending order of size, so it fails early.

It fills the `Board` in order, starting from the bottom left and going up. Only
when the column is filled it tries to fill the next one. This favors the creation
of small empty subregions, so it can detect badly placed `Piece`s early and
correct.

In each `Cell`, the algorithm tries to place a `Piece`. Every time a `Piece` is
placed, it recalculates the empty subregions and starts again without the placed
`Piece`. 

If there are no more empty subregions, then the algorithm has solver the `Board`
successfully.
"""
function solve!(board::Board, subregions::Vector{Region}, pieces::Vector{Piece})
    image(board)
    isempty(subregions) && return true # Base case
    sort!(subregions, by=length)
    empty = popfirst!(subregions)
    length(empty) <= 2 && return false # Trivial cases
    (i, j) = reverse(minimum(reverse.(empty)))
    for piece in pieces
        for symm in piece.symmetries
            translated = map(cell -> cell .+ (i, j), symm)
            if check_space(empty, translated)
                place_piece!(board, empty, translated, piece)
                solve!(board, append!(get_subregions(empty), subregions),
                    filter(x -> x != piece, pieces)) && return true
                remove_piece!(board, empty, translated)
            end
        end
    end
    return false
end

"""
Can be called in three different ways:
- `Board` + `Piece`s -> Use the collection of `Piece`s to solve the `Board`. Any
`Piece`s in the collection that are already on the `Board` will be disconsidered.
- `Board` -> Solves the `Board` with the original game `Piece`s. Again, `Piece`s
already on the `Board` are discarded.
- Number -> Solves the corresponding game's stage.
"""
function solve(board::Board, pieces::Vector{Piece}; shuffle=true)
    board_cp = copy(board)
    ps = filter(x -> x ∉ board_cp, pieces)
    empty = empty_region(board_cp)
    n_cells_pieces = mapreduce(size, +, ps)
    @assert n_cells_pieces >= length(empty) "Not enough pieces to fill the board."
    @assert n_cells_pieces <= length(empty) "Too many pieces for the board."
    subregions = get_subregions(empty)
    shuffle && shuffle!(ps)
    solved = solve!(board_cp, subregions, ps)
    if solved
        println("The board was successfully solved.")
    else
        println("The board was not solved.")
    end
    return board_cp
end

solve(board::Board) = solve(board, game_pieces)
solve(stage::Int) = solve(build_stage(stage), game_pieces)

function place_piece!(board::Board, empty::Region, symmetry::Region, piece::Piece)
    for (i, j) in symmetry
        board[i, j] = piece
        filter!(x -> x != (i, j), empty)
    end
end

function remove_piece!(board::Board, empty::Region, symmetry::Region)
    for (i, j) in symmetry
        board[i, j] = nothing
        push!(empty, (i, j))
    end
end

"Checks if the second `Region` fits inside the first"
function check_space(empty::Region, symm::Region)
    return all(map(cell -> cell ∈ empty, symm))
end

"""
Returns all subregions in a given region.

A subregion of a `Region` ``R`` is a `Region` inside ``R`` that is as large as
possible while still having paths connecting all its `Cell`s. A path is a sequence
of `Cell`s in which any two consecutive `Cell`s are horizontally or vertically
(not diagonally) adjacent.
"""
function get_subregions(empty::Region)
    return get_subregions(empty, Region[])
end

function get_subregions(empty::Region, acc::Vector{Region})
    isempty(empty) && return acc # Base case
    subregion = one_subregion(empty)
    return get_subregions(setdiff(empty, subregion), append!(acc, [subregion]))
end

"This function extracts one subregion of a given region."
function one_subregion(region::Region)
    return one_subregion(region, [region[1]], [region[1]])
end

function one_subregion(region::Region, subregion::Region, current::Region)
    isempty(current) && return subregion # Base case
    next = Cell[]
    for (i, j) in collect(current)
        for neighbor in [(1, 0), (-1, 0), (0, 1), (0, -1)]
            if ((i, j) .+ neighbor ∈ region) && ((i, j) .+ neighbor ∉ subregion)
                push!(subregion, (i, j) .+ neighbor)
                push!(next, (i, j) .+ neighbor)
            end
        end
    end
    return one_subregion(region, subregion, next)
end

