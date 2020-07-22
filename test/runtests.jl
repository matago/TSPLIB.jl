using TSPLIB
using Test

@testset "TSPLIB.jl" begin
    exclude_list = [
        :rl11849
        :usa13509
        :brd14051
        :d15112
        :d18512
        :pla33810
        :pla85900
        ]
    for instance in keys(Optimals)
        if !(instance in exclude_list)
            @test readTSPLIB(instance).optimal == Optimals[instance]
        end
    end
end
