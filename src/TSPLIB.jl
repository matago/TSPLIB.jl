module TSPLIB
  using DataStructures
  using Match
  #test


  export TSP, readTSP, readTSPLIB, TSPLIB95_path, findTSP

  type TSP
    name::AbstractString
    dimension::Integer
    weight_type::AbstractString
    weights::Matrix
    nodes::Matrix
    Dnodes::Bool
    ffx::Function
    pfx::Function
  end

  const TSPLIB95_path = joinpath(Pkg.dir("TSPLIB"),"data","TSPLIB95","tsp")

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

end # module

