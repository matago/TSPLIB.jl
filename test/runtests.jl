using TSPLIB
using Test

@testset "LoadSymbol" begin
    data = readTSPLIB(:a280)
    @test data.name == "a280"
    @test data.dimension == 280
    @test data.weight_type == "EUC_2D"
    @test data.weights[3, 3] == 0.0
    @test data.weights[1, 2] == 20.0
    @test data.nodes[4, 2] == 141.0
    @test data.Dnodes == false
    @test data.optimal == 2579.0
    @test_nowarn println(data)
end

@testset "ErrorSymbol" begin
    data = readTSPLIB(:notaninstance)
    @test data === nothing
end

@testset "LoadString" begin
    data = readTSP(joinpath(pkgdir(TSPLIB), "test/data/dummy.tsp"))
    @test data.name == "dummy"
    @test data.dimension == 5
    @test data.weight_type == "GEO"
    @test data.weights[3, 3] == 0.0
    @test data.weights[1, 2] == 153.0
    @test data.nodes[4, 2] == 93.37
    @test data.Dnodes == false
    @test data.optimal == -1
    @test_nowarn println(data)
end

@testset "ErrorString" begin
    data = readTSP("notaninstance")
    @test data === nothing
end

@testset "LoadATT" begin
    data = readTSPLIB(:att48)
    @test data.name == "att48"
    @test data.dimension == 48
    @test data.weight_type == "ATT"
    @test data.weights[3, 3] == 0.0
    @test data.weights[1, 2] == 1495.0
    @test data.nodes[4, 2] == 841.0
    @test data.Dnodes == false
    @test data.optimal == 10628.0
    @test_nowarn println(data)
end

@testset "LoadCEIL2D" begin
    data = readTSPLIB(:dsj1000)
    @test data.name == "dsj1000"
    @test data.dimension == 1000
    @test data.weight_type == "CEIL_2D"
    @test data.weights[3, 3] == 0.0
    @test data.weights[1, 2] == 709145.0
    @test data.nodes[4, 2] == -96645.0
    @test data.Dnodes == false
    @test data.optimal == 18659688.0
    @test_nowarn println(data)
end

@testset "WrongWeightType" begin
    file_name = joinpath(pkgdir(TSPLIB), "test/data/wrong_weight.tsp")
    expected_error = "Distance function type BLAH is not supported."
    @test_throws ErrorException(expected_error) readTSP(file_name)
end

@testset "NoEOF" begin
    file_name = joinpath(pkgdir(TSPLIB), "test/data/no_eof.tsp")
    expected_error = "EOF not found"
    @test_throws ErrorException(expected_error) readTSP(file_name)
end

@testset "FindTSP" begin
    @test_nowarn findTSP(joinpath(pkgdir(TSPLIB), "test/data"))
    expected_error = "Not a valid directory"
    @test_throws ErrorException(expected_error) findTSP("BLAH")
end

@testset "Explicit" begin
    full_matrix = readTSP(joinpath(pkgdir(TSPLIB), "test/data/full_matrix.tsp"))
    lower_row = readTSP(joinpath(pkgdir(TSPLIB), "test/data/lower_row.tsp"))
    upper_row = readTSP(joinpath(pkgdir(TSPLIB), "test/data/upper_row.tsp"))
    lower_diag_row = readTSP(joinpath(pkgdir(TSPLIB), "test/data/lower_diag_row.tsp"))
    upper_diag_row = readTSP(joinpath(pkgdir(TSPLIB), "test/data/upper_diag_row.tsp"))
    lower_diag_col = readTSP(joinpath(pkgdir(TSPLIB), "test/data/lower_diag_col.tsp"))
    upper_diag_col = readTSP(joinpath(pkgdir(TSPLIB), "test/data/upper_diag_col.tsp"))
    
    @test full_matrix.weights == lower_row.weights
    @test full_matrix.weights == upper_row.weights
    @test full_matrix.weights == lower_diag_row.weights
    @test full_matrix.weights == upper_diag_row.weights
    @test full_matrix.weights == lower_diag_col.weights
    @test full_matrix.weights == upper_diag_col.weights
end