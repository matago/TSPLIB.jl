module TSPLIB
  using DataStructures
  using Match
  #test


  export TSP, readTSP, readTSPLIB

  include("reader.jl")
  include("distances.jl")
  include("utils.jl")
  include("fitness.jl")

end # module
