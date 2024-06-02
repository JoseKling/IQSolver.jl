const l_blue = Piece([(0, 0); (0, 1); (1, 0)], colorant"lightskyblue1")
const m_blue = Piece([(0, 0); (0, 1); (0, 2); (1, 0); (2, 0)], colorant"dodgerblue")
const d_blue = Piece([(0, 0); (0, 1); (0, 2); (1, 0)], colorant"darkblue")
const l_green = Piece([(0, 0); (0, 1); (0, 2); (1, 0); (1, 1)], colorant"darkseagreen1")
const m_green = Piece([(0, 0); (0, 1); (0, 2); (1, 0); (1, 2)], colorant"olivedrab2")
const d_green = Piece([(0, 0); (0, 1); (0, 2); (1, 1)], colorant"teal")
const m_red = Piece([(0, 0); (0, 1); (0, 2); (0, 3); (1, 0)], colorant"red")
const d_red = Piece([(0, 0); (1, 0); (1, 1); (2, 1)], colorant"red4")
const m_yellow = Piece([(0, 0); (0, 1); (0, 2); (0, 3); (1, 1)], colorant"yellow")
const m_purple = Piece([(0, 0); (0, 1); (1, 1); (1, 2); (2, 2)], colorant"purple4")
const m_orange = Piece([(0, 0); (0, 1); (1, 1); (1, 2); (2, 1)], colorant"orange")
const m_pink = Piece([(0, 0); (0, 1); (1, 1); (1, 2); (1, 3)], colorant"lightpink1")

const l_blue3D = Piece([(0.0, 0.0, 0.0); (0.0, 1.0, 0.0); (1.0, 0.0, 0.0)], colorant"lightskyblue1")
const m_blue3D = Piece([(0.0, 0.0, 0.0); (0.0, 1.0, 0.0); (0.0, 2.0, 0.0); (1.0, 0.0, 0.0); (2.0, 0.0, 0.0)], colorant"dodgerblue")
const d_blue3D = Piece([(0.0, 0.0, 0.0); (0.0, 1.0, 0.0); (0.0, 2.0, 0.0); (1.0, 0.0, 0.0)], colorant"darkblue")
const l_green3D = Piece([(0.0, 0.0, 0.0); (0.0, 1.0, 0.0); (0.0, 2.0, 0.0); (1.0, 0.0, 0.0); (1.0, 1.0, 0.0)], colorant"darkseagreen1")
const m_green3D = Piece([(0.0, 0.0, 0.0); (0.0, 1.0, 0.0); (0.0, 2.0, 0.0); (1.0, 0.0, 0.0); (1.0, 2.0, 0.0)], colorant"olivedrab2")
const d_green3D = Piece([(0.0, 0.0, 0.0); (0.0, 1.0, 0.0); (0.0, 2.0, 0.0); (1.0, 1.0, 0.0)], colorant"teal")
const m_red3D = Piece([(0.0, 0.0, 0.0); (0.0, 1.0, 0.0); (0.0, 2.0, 0.0); (0.0, 3.0, 0.0); (1.0, 0.0, 0.0)], colorant"red")
const d_red3D = Piece([(0.0, 0.0, 0.0); (1.0, 0.0, 0.0); (1.0, 1.0, 0.0); (2.0, 1.0, 0.0)], colorant"red4")
const m_yellow3D = Piece([(0.0, 0.0, 0.0); (0.0, 1.0, 0.0); (0.0, 2.0, 0.0); (0.0, 3.0, 0.0); (1.0, 1.0, 0.0)], colorant"yellow")
const m_purple3D = Piece([(0.0, 0.0, 0.0); (0.0, 1.0, 0.0); (1.0, 1.0, 0.0); (1.0, 2.0, 0.0); (2.0, 2.0, 0.0)], colorant"purple4")
const m_orange3D = Piece([(0.0, 0.0, 0.0); (0.0, 1.0, 0.0); (1.0, 1.0, 0.0); (1.0, 2.0, 0.0); (2.0, 1.0, 0.0)], colorant"orange")
const m_pink3D = Piece([(0.0, 0.0, 0.0); (0.0, 1.0, 0.0); (1.0, 1.0, 0.0); (1.0, 2.0, 0.0); (1.0, 3.0, 0.0)], colorant"lightpink1")

"""
List of all the pieces in the original game.

Their names refer to the color. It always start with 'l_', 'm_', or 'd_', for
light, middle, and dark. To maintain the standard and to not have any conflicts
with any color names, a 'm_' is appended even for colors that appear only once,
like 'm_orange'.

The individual pieces are also exported.
"""
const game_pieces2D = [l_blue,
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

const game_pieces3D = [l_blue3D,
    m_blue3D,
    d_blue3D,
    l_green3D,
    m_green3D,
    d_green3D,
    m_red3D,
    d_red3D,
    m_yellow3D,
    m_purple3D,
    m_orange3D,
    m_pink3D]

game_pieces(T::Type) = T == Cell2D ? game_pieces2D : game_pieces3D

"Creates an empty rectangular board"
function rectangular_board()
    cells = [(x, y) for x in 1:11 for y in 1:5]
    return Board{Cell2D}(cells .=> nothing)
end

function diagonal_board()
    board = Dict{Cell2D,Union{Piece,Nothing}}()
    [board[(i, 1)] = nothing for i in 2:5]
    [board[(i, 2)] = nothing for i in 1:5]
    [board[(i, 3)] = nothing for i in 1:7]
    [board[(i, 4)] = nothing for i in 1:7]
    [board[(i, 5)] = nothing for i in 1:9]
    [board[(i, 6)] = nothing for i in 3:9]
    [board[(i, 7)] = nothing for i in 3:9]
    [board[(i, 8)] = nothing for i in 5:9]
    [board[(i, 9)] = nothing for i in 5:8]
    return board
end

function pyramid_board()
    cells = [(x + ((z - 1) / 2), y + ((z - 1) / 2), 1 + ((z - 1))) for z in 1:5 for x in 1:6-z for y in 1:6-z]
    return Board{Cell3D}(cells .=> nothing)
end

"""
Creates a rectangular board filled with the provided `Piece`s and `Regions`.

`filled` is a `Dict` of `Piece` => `Region`.
"""
function rectangular_board(filled::Dict{Piece{Cell2D},Region{Cell2D}})
    board = rectangular_board()
    fill_board!(board, filled)
    return board
end

"Builds the game's diagonal 2D board filled with the provided `Piece`s."
function diagonal_board(filled::Dict{Piece{Cell2D},Region{Cell2D}})
    board = diagonal_board()
    fill_board!(board, filled)
    return board
end

function pyramid_board(filled::Dict{Piece{Cell3D},Region{Cell3D}})
    board = pyramid_board()
    fill_board!(board, filled)
    return board
end


######################### Stages ##############################################
"Returns the board with the configuration of each stage in the game"
build_stage(stage::Int) = stages[stage][1](stages[stage][2])

"Where all the stages configurations are stored"
const stages = Dict(
    38 => (rectangular_board,
        Dict(d_blue => [(1, 5), (1, 4), (1, 3), (2, 3)],
            m_yellow => [(3, 3), (4, 3), (5, 3), (6, 3), (4, 2)])),
    39 => (rectangular_board,
        Dict(d_blue => [(1, 5), (2, 5), (3, 5), (3, 4)],
            m_red => [(3, 3), (4, 3), (5, 3), (6, 3), (6, 2)])),
    40 => (rectangular_board,
        Dict(l_green => [(1, 5), (1, 4), (1, 3), (2, 4), (2, 3)],
            m_yellow => [(3, 3), (4, 3), (5, 3), (6, 3), (5, 2)])),
    80 => (diagonal_board,
        Dict(m_orange => [(4, 2), (5, 2), (5, 3), (6, 3), (5, 4)],
            m_blue => [(6, 4), (6, 5), (6, 6), (5, 6), (4, 6)])),
    99 => (pyramid_board,
        Dict{Piece{Cell3D},Region{Cell3D}}(
            m_pink3D => [(1.0, 1.0, 1.0), (2.0, 1.0, 1.0), (3.0, 1.0, 1.0), (3.0, 2.0, 1.0), (4.0, 2.0, 1.0)],
            m_green3D => [(4.0, 1.0, 1.0), (5.0, 1.0, 1.0), (5.0, 2.0, 1.0), (5.0, 3.0, 1.0), (4.0, 3.0, 1.0)],
            m_orange3D => [(1.0, 4.0, 1.0), (1.0, 3.0, 1.0), (2.0, 3.0, 1.0), (2.0, 2.0, 1.0), (3.0, 3.0, 1.0)],
            d_red3D => [(1.0, 5.0, 1.0), (2.0, 5.0, 1.0), (2.0, 4.0, 1.0), (3.0, 4.0, 1.0)],
            l_green3D => [(3.0, 5.0, 1.0), (4.0, 5.0, 1.0), (5.0, 5.0, 1.0), (4.0, 4.0, 1.0), (5.0, 4.0, 1.0)],
            m_red3D => [(1.5, 4.5, 2), (1.5, 3.5, 2), (2.5, 4.5, 2), (3.5, 4.5, 2), (4.5, 4.5, 2)],
            m_blue3D => [(2.5, 1.5, 2), (3.5, 1.5, 2), (4.5, 1.5, 2), (4.5, 2.5, 2), (4.5, 3.5, 2)]))
)

