##################### Aliases #################################################
Cell = Tuple{Int,Int}
Region = Vector{Cell}

####################### Piece #################################################
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
Board = Matrix{Union{Nothing,Piece}}

function make_board(height::Int, width::Int)
    return Board(fill(nothing, height, width))
end

function make_board(height::Int, width::Int,
    filled::Dict{Piece,Region})
    board = make_board(height, width)
    fill_board!(board, filled)
    return board
end

shape(board::Board) = size(board)
width(board::Board) = size(board, 2)
height(board::Board) = size(board, 1)
empty_region(board::Board) = [(i, j) for i in 1:height(board), j in 1:width(board) if board[i, j] === nothing]

function image(board::Board)
    p = plot(map(x -> x === nothing ? RGB(0.0, 0.0, 0.0) : x.color, board),
        axis=([], false))
    display(p)
end

function fill_board!(board::Board, filled::Dict{Piece,Region})
    for (piece, cells) in filled
        for (i, j) in cells
            board[height(board)+1-i, j] = piece
        end
    end
end
