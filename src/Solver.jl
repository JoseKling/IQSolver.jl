export initialize, solve

#---------------- Initialization -------------------
function initialize()
    pieces = Piece[]
    push!(pieces, Piece([0 0; 0 1; 1 0]))
    push!(pieces, Piece([0 0; 0 1; 0 2; 1 1]))
    push!(pieces, Piece([0 0; 1 0; 1 1; 2 1]))
    push!(pieces, Piece([0 0; 0 1; 0 2; 1 0]))
    push!(pieces, Piece([0 0; 0 1; 0 2; 0 3; 1 1]))
    push!(pieces, Piece([0 0; 0 1; 0 2; 1 0; 2 0]))
    push!(pieces, Piece([0 0; 0 1; 0 2; 0 3; 1 0]))
    push!(pieces, Piece([0 0; 0 1; 0 2; 1 0; 1 2]))
    push!(pieces, Piece([0 0; 0 1; 0 2; 1 0; 1 1]))
    push!(pieces, Piece([0 0; 0 1; 1 1; 1 2; 2 2]))
    push!(pieces, Piece([0 0; 0 1; 1 1; 1 2; 2 1]))
    push!(pieces, Piece([0 0; 0 1; 1 1; 1 2; 1 3]))
    board = Board(fill(nothing, 5, 11))
    return pieces, board
end

function solve(board::Board, pieces::Vector{Piece})
    solved_board = copy(board)
    current_piece = 1
    while (current_piece <= length(pieces)) && (current_piece > 0)
        placed_piece = false
        while !placed_piece && (symmetries[current_piece] <= n_symmetries(pieces[current_piece]))
            while !placed_piece && (positions[current_piece][1] <= height(solved_board))
                while !placed_piece && (positions[current_piece][2] <= width(solved_board))
                    check = check_piece(pieces[current_piece], 
                                        symmetries[current_piece], 
                                        positions[current_piece],
                                        solved_board)
                    if check
                        place_piece!(solved_board, 
                                     pieces[current_piece], 
                                     symmetries[current_piece], 
                                     positions[current_piece])
                        current_piece += 1
                        placed_piece = true
                    else
                        positions[current_piece][2] += 1
                    end
                end
                if !placed_piece
                    positions[current_piece][2] = 1
                    positions[current_piece][1] += 1
                end
            end
            if !placed_piece
                positions[current_piece][2] = 1
                positions[current_piece][1] = 1
                symmetries[current_piece] += 1
            end
        end
        if !placed_piece
            symmetries[current_piece] = 1
            positions[current_piece][2] = 1
            positions[current_piece][1] = 1
            current_piece -= 1
            remove_piece!(solved_board, pieces[current_piece], symmetries[current_piece], positions[current_piece])
            positions[current_piece][2] += 1
        end
        image(solved_board)
    end 
    if current_piece == 0
        return nothing
    else
        return Solution(pieces, positions, symmetries, solved_board)
    end
end

function check_piece(piece::Piece, symmetry::Int, position::Vector{Int}, board::Board)
    sym = piece.symmetries[symmetry]
    if (maximum(sym[:,1]) + position[1] > height(board)) || (maximum(sym[:,2]) + position[2] > width(board))
        return false
    else
        for i in 1:size(sym, 1)
            if board.squares[(position .+ sym[i,:])...] !== nothing
                return false
            end
        end
    end
    return true && check_regions(board, )
end

function place_piece!(board::Board, piece::Piece, symmetry::Int, position::Vector{Int})
    sym = piece.symmetries[symmetry]
    for i in 1:size(sym, 1)
        board.squares[(position .+ sym[i,:])...] = piece
    end
end

function remove_piece!(board::Board, piece::Piece, symmetry::Int, position::Vector{Int})
    sym = piece.symmetries[symmetry]
    for i in 1:size(sym, 1)
        board.squares[(position .+ sym[i,:])...] = nothing
    end
end