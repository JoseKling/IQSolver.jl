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
function solve!(board::Board{T}, subregions::Vector{Region{T}},
    pieces::Vector{Piece{T}}) where {T<:Cell}
    image(board)
    # sleep(1)
    isempty(subregions) && return true # Base case
    sort!(subregions, by=length)
    empty = popfirst!(subregions)
    length(empty) <= 2 && return false # Trivial cases
    current = minimum(empty)
    for piece in pieces
        for symm in piece.symmetries
            translated = map(cell -> cell .+ current, symm)
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
function solve(board::Board{T}, pieces::Vector{Piece{T}};
    shuffle=true) where {T<:Cell}
    board_cp = deepcopy(board)
    ps = filter(x -> x.color ∉ values(board_cp), pieces)
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
solve(board::Board{T}) where {T<:Cell} = solve(board, game_pieces(T))
function solve(stage::Int)
    board = build_stage(stage)
    pieces = game_pieces(eltype(keys(board)))
    solve(board, pieces)
end

function place_piece!(board::Board{T}, empty::Region{T}, symmetry::Region{T},
    piece::Piece{T}) where {T<:Cell}
    for cell in symmetry
        board[cell] = piece.color
        filter!(x -> x != cell, empty)
    end
end

function remove_piece!(board::Board{T}, empty::Region{T},
    symmetry::Region{T}) where {T<:Cell}
    for cell in symmetry
        board[cell] = nothing
        push!(empty, cell)
    end
end

"Checks if the second `Region` fits inside the first"
function check_space(empty::Region{T}, symm::Region{T}) where {T<:Cell}
    return all(map(cell -> cell ∈ empty, symm))
end

"""
Returns all subregions in a given region.

A subregion of a `Region` ``R`` is a `Region` inside ``R`` that is as large as
possible while still having paths connecting all its `Cell`s. A path is a sequence
of `Cell`s in which any two consecutive `Cell`s are horizontally or vertically
(not diagonally) adjacent.
"""
function get_subregions(region::Region{T}) where {T<:Cell}
    return get_subregions(region, Region{T}[])
end

function get_subregions(region::Region{T}, acc::Vector{Region{T}}) where {T<:Cell}
    isempty(region) && return acc # Base case
    subregion = one_subregion(region)
    return get_subregions(setdiff(region, subregion), push!(acc, subregion))
end

"This function extracts one subregion of a given region."
function one_subregion(region::Region{T}) where {T<:Cell}
    return one_subregion(region, [region[1]], [region[1]])
end

function one_subregion(region::Region{T}, subregion::Region{T},
    current::Region{T}) where {T<:Cell}
    isempty(current) && return subregion # Base case
    next = T[]
    for cell in current
        for neighbor in neighbors(cell)
            if (neighbor ∈ region) && (neighbor ∉ subregion)
                push!(subregion, neighbor)
                push!(next, neighbor)
            end
        end
    end
    return one_subregion(region, subregion, next)
end

function neighbors(cell::Cell2D)
    return map(x -> x .+ cell, [(1, 0), (-1, 0), (0, 1), (0, -1)])
end

function neighbors(cell::Cell3D)
    adjacent = [(1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0),
        (0.5, 0.5, 1), (-0.5, 0.5, 1), (0.5, -0.5, 1), (-0.5, -0.5, 1),
        (0.5, 0.5, -1), (-0.5, 0.5, -1), (0.5, -0.5, -1), (-0.5, -0.5, -1)]
    return map(x -> x .+ cell, adjacent)
end
