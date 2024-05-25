##################### Aliases #################################################
"A `Cell` is simply its coordinates. Alias for `Tuple{Int,Int}`."
Cell = Tuple{Int,Int}
"A region is a collection of `Cell`s. Alias for `Vector{Cell}`."
Region = Vector{Cell}

####################### Piece #################################################
"""
A `Piece` is the collection of all its symmetries with a correspoding color.
A symmetry of a piece is just a `Region` (a collection of `Cell`s), which will
be always in a normal form. This means that a symmetry always contains the `Cell`
`(0, 0)` and the horizontal component of all the `Cell`s in it (the first index)
is always non-negative.

The implemented methods for this data type are:
- `length` -> number of symmetries
- `size` -> how many cells it occupies
- `rotate` -> rotates the piece counter-clockwise
- `reflect` -> reflects the piece horizontally
- `iterate` -> iterate over its symmetries
- `normalize_symmetry` -> returns the normal form of the symmetry (see above)
"""
struct Piece
    symmetries::Vector{Region}
    color::Color

    function Piece(squares::Region, color::RGB; shuffle=true)
        symmetries = Region[]
        next = sort(normalize_symmetry(squares))
        while next ∉ symmetries
            while next ∉ symmetries
                push!(symmetries, next)
                next = rotate(next)
                next = sort(normalize_symmetry(next))
            end
            next = reflect(next)
            next = sort(normalize_symmetry(next))
        end
        shuffle && shuffle!(symmetries)
        new(symmetries, color)
    end

    function Piece(squares::Region; shuffle=true)
        Piece(squares, rand(RGB{Float64}), shuffle=shuffle)
    end
end

Base.length(p::Piece) = length(p.symmetries)
Base.iterate(p::Piece, state=1) =
    state > length(p) ? nothing : (p.symmetries[state], state + 1)
Base.size(p::Piece) = length(p.symmetries[1])
rotate(squares::Region) = map(cell -> (cell[2], -cell[1]), squares)
reflect(squares::Region) = map(cell -> (-cell[1], cell[2]), squares)

"""
This function takes a symmetry that might be translated an indefinite ammount
in any direction and makes it so that all the first coordinates are non-negative
and one of the cells is the origin.
"""
function normalize_symmetry(squares::Region)
    min2 = minimum([cell[2] for cell in squares])
    min1 = minimum([cell[1] for cell in squares if cell[2] == min2])
    return map(cell -> (cell[1] - min1, cell[2] - min2), squares)
end

###################### Board ##################################################
"""
A `Board` is a matrix containing either a `Piece` or `nothing`. Alias for
`Matrix{Union{Nothing, Piece}}`.

Implemented methods for this dasta type:
- `width` -> Returns the width of the board
- `heigth` -> Returns the height of the board
- `empty_region` -> Returns the collection of empty `Cell`s
- `image` -> Plots the current state of the board
"""
Board = Matrix{Union{Nothing,Piece}}

"Creates an empty rectangular board"
function make_board(height::Int, width::Int)
    return Board(fill(nothing, height, width))
end

"""
Creates a rectangular board filled with the provided `Piece`s and `Regions`.

`filled` is a `Dict` of `Piece` => `Region`.
"""
function make_board(height::Int, width::Int,
    filled::Dict{Piece,Region})
    board = make_board(height, width)
    fill_board!(board, filled)
    return board
end

width(board::Board) = size(board, 2)
height(board::Board) = size(board, 1)
empty_region(board::Board) = [(i, j) for i in 1:height(board), j in 1:width(board) if board[i, j] === nothing]

"""
If a `Board` is passed, shows the board with empty `Cell`s in black and `Cell`s
with pieces with the corresponding color.

If an `Int` `n` is passed, shows the configuration of the board in stage `n` of
the original game.
"""
function image(board::Board)
    p = plot(map(x -> x === nothing ? RGB(0.0, 0.0, 0.0) : x.color, board),
        axis=([], false))
    display(p)
end

image(stage::Int) = image(build_stage(stage))

"""
Fills the board with the provided `Piece`s and `Region`s in place. Checks if the
provided `Region` is consistent with the shape of the `Piece`.
"""
function fill_board!(board::Board, filled::Dict{Piece,Region})
    for (piece, cells) in filled
        @assert check_piece(piece, cells) "Check the shape of the pieces"
        for (i, j) in cells
            board[height(board)+1-i, j] = piece
        end
    end
end

"Check if `Region` is a symmetry of `Piece`"
function check_piece(piece::Piece, region::Region)
    norm_region = normalize_symmetry(region)
    return norm_region ∈ piece.symmetries
end
