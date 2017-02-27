module TSPLIB
  using DataStructures
  using Match


  export readTSP

  include("distances.jl")
  include("readTSP.jl")

end # module
