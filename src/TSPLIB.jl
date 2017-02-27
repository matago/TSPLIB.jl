module TSPLIB
  using DataStructures
  using Match
  #test


  export readTSP

  include("distances.jl")
  include("readTSP.jl")

end # module
