module IQSolver

using Colors
using Plots
import Random: shuffle!

include("Data.jl")
include("Solver.jl")
include("Game.jl")

export Piece, Board, Region
export solve, image, n_symmetries
export rectangular_board, diagonal_board, pyramid_board, build_stage
export l_blue, d_blue, d_red, d_green, m_yellow, m_blue
export m_red, m_green, l_green, m_purple, m_orange, m_pink
export l_blue3D, d_blue3D, d_red3D, d_green3D, m_yellow3D, m_blue3D
export m_red3D, m_green3D, l_green3D, m_purple3D, m_orange3D, m_pink3D
export game_pieces3D, game_pieces2D

end
