module TSPLIB
  using DataStructures
  using Match

  export TSP, readTSP, readTSPLIB, TSPLIB95_path, findTSP, Optimals

  struct TSP
    name::AbstractString
    dimension::Integer
    weight_type::AbstractString
    weights::Matrix
    nodes::Matrix
    Dnodes::Bool
    ffx::Function
    pfx::Function
    optimal::Float64
  end

  function Base.show(io::IO, data::TSP)
    print(io, "TSP data $(data.name)")
    print(io, " ($(data.dimension) nodes,")
    if data.optimal != -1
        print(io, " opt = $(data.optimal))")
    else
        print(io, " no optimal)")
    end
  end

  const TSPLIB95_path = joinpath(pkgdir(TSPLIB), "data", "TSPLIB95", "tsp")

  const tsp_keys = ["NAME",
                    "TYPE",
                    "COMMENT",
                    "DIMENSION",
                    "EDGE_WEIGHT_TYPE",
                    "EDGE_WEIGHT_FORMAT",
                    "EDGE_DATA_FORMAT",
                    "NODE_COORD_TYPE",
                    "DISPLAY_DATA_TYPE",
                    "NODE_COORD_SECTION",
                    "DEPOT_SECTION",
                    "DEMAND_SECTION",
                    "EDGE_DATA_SECTION",
                    "FIXED_EDGES_SECTION",
                    "DISPLAY_DATA_SECTION",
                    "TOUR_SECTION",
                    "EDGE_WEIGHT_SECTION",
                    "EOF"]

  include("reader.jl")
  include("distances.jl")
  include("utils.jl")
  include("fitness.jl")
  include("optimals.jl")

end # module
