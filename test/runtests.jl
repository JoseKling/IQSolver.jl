using IQSolver
using Test
import IQSolver: check_space, one_region!, get_subregions, remove_piece!, place_piece!, rotate, reflect, normalize_symmetry

@testset "rotate/reflect/normalize" begin
    @test normalize_symmetry([(-1, -2)]) == [(0, 0)]
    @test normalize_symmetry([(-1, 2), (0, -1), (-1, 1)]) == [(0, 1), (1, -2), (0, 0)]
    @test normalize_symmetry([(-1.0, 2.0, 1.0), (2.0, -1.0, 2.0), (-1.0, 1.0, 0.0)]) == [(0, 1, 1), (3, -2, 2), (0, 0, 0)]
    @test [(0, 0), (1, 0), (1, 1)] |> rotate |> normalize_symmetry |> sort == sort([(0, 0), (1, 0), (0, 1)])
    @test [(0, 0), (1, 0), (1, 1)] |> reflect |> normalize_symmetry |> sort == sort([(0, 0), (1, 0), (0, 1)])
end

@testset "check_space" begin
    @test check_space([(1, 1), (1, 2), (3, 3), (4, 4)], [(1, 1); (1, 2); (3, 3); (4, 4)]) == true
    @test check_space([(1, 1), (1, 2)], [(1, 1); (1, 2); (3, 3); (4, 4)]) == false
end

@testset "remove/place_piece!" begin
    board = [nothing m_red; m_red m_red]
    symm = [(1, 2); (2, 2); (2, 1)]
    reg = [(1, 1)]
    remove_piece!(board, reg, symm)
    @test board == [nothing nothing; nothing nothing]
    @test sort(reg) == sort([(1, 1), (2, 1), (1, 2), (2, 2)])
    place_piece!(board, reg, symm, m_red)
    @test board == [nothing m_red; m_red m_red]
    @test reg == [(1, 1)]
end

@testset "empty_region" begin
    @test sort(empty_region(make_board(2, 2))) == sort([(1, 1), (1, 2), (2, 1), (2, 2)])
end

@testset "subregions" begin
    length(get_subregions(collect(keys(pyramid_board())))) == 1
    sort(get_subregions(colelct(keys(pyramid_board())))[1]) == sort(collect(keys(pyramid_board())))
end
