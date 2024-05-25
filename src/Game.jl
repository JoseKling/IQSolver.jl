#l These are the pieces available in the game.
# Their names refer to the color. It always start with 'l', 'm', or 'd', for
# light, middle, and dark.
# To maintain the standard and not have any conflicts with any color names I
# appended an 'm' even for colors that appear only once, like 'm_orange'.
const l_blue = Piece([(0, 0); (0, 1); (1, 0)], colorant"lightskyblue1")
const d_green = Piece([(0, 0); (0, 1); (0, 2); (1, 1)], colorant"teal")
const d_red = Piece([(0, 0); (1, 0); (1, 1); (2, 1)], colorant"red4")
const d_blue = Piece([(0, 0); (0, 1); (0, 2); (1, 0)], colorant"darkblue")
const m_yellow = Piece([(0, 0); (0, 1); (0, 2); (0, 3); (1, 1)], colorant"yellow")
const m_blue = Piece([(0, 0); (0, 1); (0, 2); (1, 0); (2, 0)], colorant"dodgerblue")
const m_red = Piece([(0, 0); (0, 1); (0, 2); (0, 3); (1, 0)], colorant"red")
const m_green = Piece([(0, 0); (0, 1); (0, 2); (1, 0); (1, 2)], colorant"olivedrab2")
const l_green = Piece([(0, 0); (0, 1); (0, 2); (1, 0); (1, 1)], colorant"darkseagreen1")
const m_purple = Piece([(0, 0); (0, 1); (1, 1); (1, 2); (2, 2)], colorant"purple4")
const m_orange = Piece([(0, 0); (0, 1); (1, 1); (1, 2); (2, 1)], colorant"orange")
const m_pink = Piece([(0, 0); (0, 1); (1, 1); (1, 2); (1, 3)], colorant"lightpink1")

const game_pieces = [l_blue,
    m_blue,
    d_blue,
    l_green,
    m_green,
    d_green,
    m_red,
    d_red,
    m_yellow,
    m_purple,
    m_orange,
    m_pink]

solve(stage::Int) = solve(build_stage(stage), game_pieces)
image(stage::Int) = image(build_stage(stage))
function standard_board(filled::Dict{Piece,Region}=Dict())
    board = make_board(5, 11)
    fill_board!(board, filled)
    return board
end

function diagonal_board(filled::Dict{Piece,Region}=Dict{Piece,Region}())
    board = make_board(9, 9)
    background = Piece([(0, 0)], colorant"white")
    outside = [(1, 1); (1, 6); (1, 7); (1, 8); (1, 9);
        (2, 6); (2, 7); (2, 8); (2, 9);
        (3, 8); (3, 9);
        (4, 8); (4, 9);
        (6, 1); (6, 2);
        (7, 1); (7, 2);
        (8, 1); (8, 2); (8, 3); (8, 4);
        (9, 1); (9, 2); (9, 3); (9, 4); (9, 9)]
    for (i, j) in outside
        board[10-i, j] = background
    end
    fill_board!(board, filled)
    return board
end

######################### Stages ##############################################
build_stage(stage::Int) = stages[stage][1](stages[stage][2])

const stages = Dict(
    38 => (standard_board,
        Dict(d_blue => [(5, 1), (4, 1), (3, 1), (3, 2)],
            m_yellow => [(3, 3), (3, 4), (3, 5), (3, 6), (2, 4)])),
    39 => (standard_board,
        Dict(d_blue => [(5, 1), (5, 2), (5, 3), (4, 3)],
            m_red => [(3, 3), (3, 4), (3, 5), (3, 6), (2, 6)])),
    40 => (standard_board,
        Dict(l_green => [(5, 1), (4, 1), (3, 1), (4, 2), (3, 2)],
            m_yellow => [(3, 3), (3, 4), (3, 5), (3, 6), (2, 5)])),
    80 => (diagonal_board,
        Dict(m_orange => [(2, 4), (2, 5), (3, 5), (3, 6), (4, 5)],
            m_blue => [(4, 6), (5, 6), (6, 6), (6, 5), (6, 4)]))
)

