module IQSolver

using Colors
using Plots
import Random: shuffle!

include("Data.jl")
include("Solver.jl")
include("Game.jl")

export Piece, Board, Region
export make_board, solve, image
export game_pieces, standard_board, diagonal_board, build_stage
export l_blue, d_blue, d_red, d_green, m_yellow, m_blue
export m_red, m_green, l_green, m_purple, m_orange, m_pink

end
