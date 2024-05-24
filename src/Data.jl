
####################### Piece #################################################
struct Piece
    symmetries::Vector{Matrix{Int}}
    color::Color

    function Piece(squares::Matrix{Int}, color::RGB; shuffle=true)
        normalize_piece!(squares)
        squares = sortslices(squares, dims=1)
        symmetries = Vector{Matrix{Int}}()
        next = squares
        while next ∉ symmetries
            while next ∉ symmetries
                push!(symmetries, next)
                next = rotate(next)
            end
            next = reflect(next)
        end
        shuffle && shuffle!(symmetries)
        new(symmetries, color)
    end

    function Piece(squares::Matrix{Int}; shuffle=true)
        Piece(squares, rand(RGB{Float64}), shuffle=shuffle)
    end
end

Base.length(p::Piece) = length(p.symmetries)
Base.iterate(p::Piece, state=1) =
    state > length(p) ? nothing : (p.symmetries[state], state + 1)
Base.size(p::Piece) = size(p.symmetries[1], 1)

function rotate(squares::Matrix{Int})
    rotated = [squares[:, 2] -squares[:, 1]]
    normalize_piece!(rotated)
    rotated = sortslices(rotated, dims=1)
    return Matrix{Int}(rotated)
end

function reflect(squares::Matrix{Int})
    reflected = [-squares[:, 1] squares[:, 2]]
    normalize_piece!(reflected)
    reflected = sortslices(reflected, dims=1)
    return reflected
end

"""
This function takes a symmetry that might be translated an indefinite ammount
in any direction and makes it so that all the first coordinates are non-negative
and one of the cells is the origin.
"""
function normalize_piece!(squares::Matrix{Int})
    squares[:, 2] .-= minimum(squares[:, 2])
    squares[:, 1] .-= minimum(squares[squares[:, 2].==0, 1])
end

###################### Board ##################################################
Board = Matrix{Union{Nothing,Piece}}
Cell = Tuple{Int,Int}
Region = Vector{Cell}

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
            board[10-i, j] = piece
        end
    end
end
