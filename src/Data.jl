##################### Aliases #################################################
"A `Cell` is a tuple of integer coordinates."
Cell = Tuple{Vararg{Real}}
Cell2D = NTuple{2,Int}
Cell3D = NTuple{3,Float64}
"A region is a collection of `Cell`s."
Region{T} = Vector{T} where {T<:Cell}

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
struct Piece{T<:Cell}
    symmetries::Vector{Region{T}}
    color::Color

    function Piece(cells::Region{T}, color::RGB; shuffle=true) where {T<:Cell}
        symms = build_symmetries(cells)
        shuffle && shuffle!(symms)
        new{T}(symms, color)
    end

    function Piece(cells::Region{T}; shuffle=true) where {T<:Cell}
        Piece(cells, rand(RGB{Float64}), shuffle=shuffle)
    end
end

Base.length(p::Piece) = length(p.symmetries)
Base.iterate(p::Piece, state=1) =
    state > length(p) ? nothing : (p.symmetries[state], state + 1)
Base.size(p::Piece) = length(p.symmetries[1])

function build_symmetries(cells::Region{Cell2D})
    symmetries = Region{Cell2D}[]
    next = sort(normalize_symmetry(cells))
    while next ∉ symmetries
        while next ∉ symmetries
            push!(symmetries, next)
            next = next |> rotatexy |> normalize_symmetry |> sort
        end
        next = next |> reflect |> normalize_symmetry |> sort
    end
    return symmetries
end

function build_symmetries(cells::Region{Cell3D})
    symmetries = Region{Cell3D}[]
    initial = [[cells]; rotatez(normalize_symmetry(cells))]
    for next in initial
        next = sort(normalize_symmetry(next))
        while next ∉ symmetries
            while next ∉ symmetries
                push!(symmetries, next)
                next = next |> rotatexy |> normalize_symmetry |> sort
            end
            next = next |> reflect |> normalize_symmetry |> sort
        end
    end
    return unique(symmetries)
end

rotatexy(cells::Region{T}) where {T<:Cell} = map(cell -> rotatexy(cell), cells)
reflect(cells::Region{T}) where {T<:Cell} = map(reflect, cells)
function rotatez(cells::Region{Cell3D})
    symms = Region{Cell3D}[]
    push!(symms, map(c -> ((c[1] - c[2]) / 2, (c[1] - c[2]) / 2, (c[1] + c[2])), cells))
    push!(symms, map(c -> ((c[1] - c[2]) / 2, (c[1] - c[2]) / 2, (-c[1] - c[2])), cells))
    push!(symms, map(c -> ((c[1] + c[2]) / 2, (c[1] + c[2]) / 2, (-c[1] + c[2])), cells))
    push!(symms, map(c -> ((c[1] + c[2]) / 2, (c[1] + c[2]) / 2, (c[1] - c[2])), cells))
    return symms
end

function rotatexy(cell::Cell)
    vec = [cell...]
    vec[[1, 2]] .= [vec[2], -vec[1]]
    return Tuple(vec)
end

function reflect(cell::Cell)
    vec = [cell...]
    vec[1] = -vec[1]
    return Tuple(vec)
end

"""
This function takes a symmetry that might be translated an indefinite ammount
in any direction and makes it so that all the first coordinates are non-negative
and one of the cells is the origin.
"""
function normalize_symmetry(cells::Region{Cell2D})
    min1 = minimum([cell[1] for cell in cells])
    min2 = minimum([cell[2] for cell in cells if cell[1] == min1])
    return map(cell -> cell .- (min1, min2), cells)
end

function normalize_symmetry(cells::Region{Cell3D})
    min1 = minimum([cell[1] for cell in cells])
    min2 = minimum([cell[2] for cell in cells if cell[1] == min1])
    min3 = minimum([cell[3] for cell in cells if (cell[1], cell[2]) == (min1, min2)])
    return map(cell -> cell .- (min1, min2, min3), cells)
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
Board{T} = Dict{T,Union{Nothing,Color}} where {T<:Cell}

empty_region(board::Board{T}) where {T<:Cell} =
    [cell for (cell, color) in board if color === nothing]

"""
Fills the board with the provided `Piece`s and `Region`s in place. Checks if the
provided `Region` is consistent with the shape of the `Piece`.datapieci
"""
function fill_board!(board::Board{T}, filled::Dict{Piece{T},Region{T}}, check::Bool=true) where {T<:Cell}
    for (piece, cells) in filled
        @assert !check || check_piece(piece, cells) "Check the shape of the pieces $(cells)"
        for cell in cells
            board[cell] = piece.color
        end
    end
end

"Check if `Region` is a symmetry of `Piece`"
check_piece(piece::Piece{T}, region::Region{T}) where {T<:Cell} =
    sort(normalize_symmetry(region)) ∈ sort(normalize_symmetry.(piece.symmetries))

"""
If a `Board` is passed, shows the board with empty `Cell`s in black and `Cell`s
with pieces with the corresponding color.

If an `Int` `n` is passed, shows the configuration of the board in stage `n` of
the original game.
"""
function image(board::Board{Cell2D})
    p = scatter(collect(keys(board)), color=collect(values(board)),
        aspect_ratio=:equal, xticks=[], yticks=[], axis=([], false),
        markersize=25, legend=false)
    display(p)
end

function image(board::Board{Cell3D})
    p = scatter(map(c -> (c[1], c[2] + sum(6:-1:7-c[3])), collect(keys(board))), color=collect(values(board)),
        aspect_ratio=:equal, xticks=[], yticks=[], axis=([], false),
        markersize=11, legend=false)
    display(p)
end

image(stage::Int) = image(build_stage(stage))

function image(piece::Piece{Cell2D})
    p = scatter(piece.symmetries[1], color=piece.color,
        aspect_ratio=:equal, xticks=[], yticks=[], axis=([], false),
        markersize=25, legend=false)
    display(p)
end

function image(piece::Piece{Cell3D}, symm_n::Int=1; cam=(20, 30))
    p = scatter(piece.symmetries[symm_n], color=piece.color,
        aspect_ratio=:equal, camera=cam,
        markersize=11, legend=false)
    display(p)
end

function image(region::Region{Cell2D})
    p = scatter(region, color=:black, aspect_ratio=:equal, markersize=10, legend=false)
    display(p)
end

function image(region::Region{Cell3D})
    p = scatter(map(c -> (c[1], c[2] + sum(6:-1:7-c[3])), collect(keys(pyramid_board()))), color=:black)
    scatter!(p, map(c -> (c[1], c[2] + sum(6:-1:7-c[3])), region), color=:blue)
    plot!(p, region, color=:black, aspect_ratio=:equal, markersize=10, legend=false)
    display(p)
end

