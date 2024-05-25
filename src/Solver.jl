function solve!(board::Board, pieces::Vector{Piece}; shuffle=true)
    ps = filter(x -> x ∉ board, pieces)
    empty = empty_region(board)
    n_cells_pieces = mapreduce(size, +, ps)
    @assert n_cells_pieces >= length(empty) "Not enough pieces to fill the board."
    @assert n_cells_pieces <= length(empty) "Too many pieces for the board."
    subregions = get_subregions(empty)
    shuffle && shuffle!(pieces)
    solved = solve!(board, subregions, ps)
    if solved
        println("The board was successfully solved.")
    else
        println("The board was not solved.")
    end
    return
end

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

function solve(board::Board, pieces::Vector{Piece}; shuffle=true)
    new_board = copy(board)
    solve!(new_board, pieces, shuffle=shuffle)
    return new_board
end

solve(board::Board) = solve(board, game_pieces)

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

function check_space(empty::Region, symm::Region)
    return all(map(cell -> cell ∈ empty, symm))
end

function get_subregions(empty::Region)
    return get_subregions(empty, Region[])
end

function get_subregions(empty::Region, acc::Vector{Region})
    isempty(empty) && return acc # Base case
    subregion = one_subregion!(empty)
    return get_subregions(setdiff(empty, subregion), append!(acc, [subregion]))
end

function one_subregion!(region::Region)
    return one_subregion!(region, [region[1]], [region[1]])
end

function one_subregion!(region::Region, subregion::Region, current::Region)
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
    return one_subregion!(region, subregion, next)
end

