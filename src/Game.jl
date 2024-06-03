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

const l_blue3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), l_blue.symmetries[1]), colorant"lightskyblue1")
const m_blue3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), m_blue.symmetries[1]), colorant"dodgerblue")
const d_blue3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), d_blue.symmetries[1]), colorant"darkblue")
const l_green3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), l_green.symmetries[1]), colorant"darkseagreen1")
const m_green3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), m_green.symmetries[1]), colorant"olivedrab2")
const d_green3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), d_green.symmetries[1]), colorant"teal")
const m_red3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), m_red.symmetries[1]), colorant"red")
const d_red3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), d_red.symmetries[1]), colorant"red4")
const m_yellow3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), m_yellow.symmetries[1]), colorant"yellow")
const m_purple3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), m_purple.symmetries[1]), colorant"purple4")
const m_orange3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), m_orange.symmetries[1]), colorant"orange")
const m_pink3D = Piece(map(c -> (2 * c[1], 2 * c[2], 0), m_pink.symmetries[1]), colorant"lightpink1")

"""
List of all the pieces in the original game. This list is for the 2D variants.

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

"""
List of all the pieces of the game, but for the 3D pyramid variant.

The difference between the 3D and 2D `Piece`s is the number of symmetries.
"""
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
    cells = [(x, y) for x in 0:10 for y in 0:4]
    return Board{Cell2D}(cells .=> nothing)
end

"Creates an empty diagonal board (the one on the back of the game)"
function diagonal_board()
    board = Dict{Cell2D,Union{Color,Nothing}}()
    [board[(i, 0)] = nothing for i in 1:4]
    [board[(i, 1)] = nothing for i in 0:4]
    [board[(i, 2)] = nothing for i in 0:6]
    [board[(i, 3)] = nothing for i in 0:6]
    [board[(i, 4)] = nothing for i in 0:8]
    [board[(i, 5)] = nothing for i in 2:8]
    [board[(i, 6)] = nothing for i in 2:8]
    [board[(i, 7)] = nothing for i in 4:8]
    [board[(i, 8)] = nothing for i in 4:7]
    return board
end

"Creates a pyramid board"
function pyramid_board()
    cells = [(x + z, y + z, z) for z in 0:4 for x in 0:2:8-(2*z) for y in 0:2:8-(2*z)]
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

"Builds the game's 3D pyramid board board filled with the provided `Piece`s."
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
    38 => (rectangular_board, Dict{Piece{Cell2D},Region{Cell2D}}(
        d_blue => [(0, 4), (0, 3), (0, 2), (1, 2)],
        m_yellow => [(2, 2), (3, 2), (4, 2), (5, 2), (3, 1)])),
    39 => (rectangular_board, Dict{Piece{Cell2D},Region{Cell2D}}(
        d_blue => [(0, 4), (1, 4), (2, 4), (2, 3)],
        m_red => [(2, 2), (3, 2), (4, 2), (5, 2), (5, 1)])),
    40 => (rectangular_board, Dict{Piece{Cell2D},Region{Cell2D}}(
        l_green => [(0, 4), (0, 3), (0, 2), (1, 3), (1, 2)],
        m_yellow => [(2, 2), (3, 2), (4, 2), (5, 2), (4, 1)])),
    80 => (diagonal_board, Dict{Piece{Cell2D},Region{Cell2D}}(
        m_orange => [(3, 1), (4, 1), (4, 2), (5, 2), (4, 3)],
        m_blue => [(5, 3), (5, 4), (5, 5), (4, 5), (3, 5)])),
    99 => (pyramid_board, Dict{Piece{Cell3D},Region{Cell3D}}(
        m_pink3D => [(0, 0, 0), (2, 0, 0), (4, 0, 0), (4, 2, 0), (6, 2, 0)],
        m_green3D => [(6, 0, 0), (8, 0, 0), (8, 2, 0), (8, 4, 0), (6, 4, 0)],
        m_orange3D => [(0, 6, 0), (0, 4, 0), (2, 4, 0), (2, 2, 0), (4, 4, 0)],
        d_red3D => [(0, 8, 0), (2, 8, 0), (2, 6, 0), (4, 6, 0)],
        l_green3D => [(4, 8, 0), (6, 8, 0), (8, 8, 0), (6, 6, 0), (8, 6, 0)],
        m_red3D => [(1, 7, 1), (1, 5, 1), (3, 7, 1), (5, 7, 1), (7, 7, 1)],
        m_blue3D => [(3, 1, 1), (5, 1, 1), (7, 1, 1), (7, 3, 1), (7, 5, 1)])),
    120 => (pyramid_board, Dict{Piece{Cell3D},Region{Cell3D}}(
        m_yellow3D => [(2, 4, 0), (4, 4, 0), (6, 4, 0), (8, 4, 0), (6, 6, 0)]))
)

