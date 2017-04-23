#=Generator function for TSP that takes the weight Matrix
and returns a function that evaluates the fitness of a single path=#

function fullFit(costs::Matrix{Float64})
  N = size(costs,1)
  function fFit{T <: Integer}(tour::Vector{T})
    @assert length(tour) == N "Tour must be of length $N"
    @assert isperm(tour) "Not a valid tour, not a permutation"
    #distance = weights[from,to] (from,to) in tour
    distance = costs[tour[N],tour[1]]
    for i in 1:N-1
      @inbounds distance += costs[tour[i],tour[i+1]]
    end
    return distance
  end
  return fFit
end

function partFit(costs::Matrix{Float64})
  N = size(costs,1)
  function pFit{T <: Integer}(tour::Vector{T})
    n = length(tour)
    #distance = weights[from,to] (from,to) in tour
    distance = n == N ? costs[tour[N],tour[1]] : zero(Float64)
    for i in 1:n-1
      @inbounds distance += costs[tour[i],tour[i+1]]
    end
    return distance
  end
  return pFit
end

