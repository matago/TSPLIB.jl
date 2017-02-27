module TSPLIB
  using DataStructures
  using Match
  #test


  export readTSP

  include("readTSP.jl")
  include("distances.jl")
  include("utils.jl")

end # module
