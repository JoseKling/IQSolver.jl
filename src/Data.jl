export Piece, Board, solution
export n_squares, n_symmetries, height, width, shape, image

mutable struct Piece
    const squares::Matrix{Int}
    const symmetries::Vector{Matrix{Int}}
    const color::RGB
    const position::Vector{Int}
    symmetry::Int
    function Piece(squares::Matrix{Int}, color::RGB)
        squares[:,1] .-= minimum(squares[:,1])
        squares[:,2] .-= minimum(squares[:,2])
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
        new(squares, symmetries, color, [1, 1], 1)
    end
    function Piece(squares::Matrix{Int})
        Piece(squares, rand(RGB{Float64}))
    end
end

struct Board
    squares::Matrix{Union{Piece, Nothing}}
    regions::Set{Matrix{Int}}
    function Board(squares::Matrix{Union{Piece, Nothing}})
        regions = []
        pl_holder = Piece([0,0])
        cp_squares = copy(squares)
        while any(x -> x === nothing, cp_squares)
            start_idx = findfirst(x -> x === nothing, cp_squares)
            start = [start_idx.I[1], start_idx.I[2]]
            region = [start]
            cp_squares[start...] = pl_holder
            to_check = [start]
            while !isempty(to_check)
                current = pop!(to_check)
                to_add = [current .+ [1, 0], current .+ [0, 1], current .+ [-1, 0], current .+ [0, -1]]
                select(x) = (x[1] > 0) && 
                            (x[2] > 0) && 
                            (x[1] <= size(squares, 1)) && 
                            (x[2] <= size(squares, 2)) && 
                            (squares[x...] !== nothing)
                filter!(select, to_add)
                for position in select
                    cp_squares[position...] = pl_holder
                end
                region = [region; to_add]
                to_check = [to_check; to_add]
            end
            push!(regions, region)
        end
    new(squares, regions)
    end
end

struct Solution
    pieces::Vector{Piece}
    positions::Vector{Vector{Int}}
    symmetries::Vector{Int}
    board::Board
end

function n_symmetries(piece::Piece)
    return length(piece.symmetries)
end

function n_squares(piece::Piece)
    return size(piece.symmetries[1], 1)
end

function shape(board::Board)
    return size(board.squares)
end

function width(board::Board)
    return size(board.squares, 2)
end

function height(board::Board)
    return size(board.squares, 1)
end

function copy(board::Board)
    return Board(copy(board.squares), copy(board.regions))
end

function image(board::Board)
    p = plot(map(x -> x === nothing ? RGB(0.0, 0.0, 0.0) : x.color, board.squares), axis=([], false))  
    display(p)
end

function rotate(squares::Matrix{Int})
    rotated = []
    for square in eachrow(squares)
        new_square = [square[2] -square[1]]
        rotated = [rotated; new_square]
    end
    rotated[:,1] .-= minimum(rotated[:,1])
    rotated[:,2] .-= minimum(rotated[:,2])
    rotated = sortslices(rotated, dims=1)
    return Matrix{Int}(rotated)
end

function reflect(squares::Matrix{Int})
    reflected = squares
    reflected[:,1] = -reflected[:,1]
    reflected[:,1] .-= minimum(reflected[:,1])
    reflected[:,2] .-= minimum(reflected[:,2])
    reflected = sortslices(reflected, dims=1)
    return reflected
end
