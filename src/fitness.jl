#=Generator function for TSP that takes the weight Matrix
and returns a function that evaluates the fitness of a single path=#

function fullFit(costs::AbstractMatrix{Float64})
  N = size(costs,1)
  @eval function fFit(tour::Vector{T}) where T<:Integer
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

function partFit(costs::AbstractMatrix{Float64})
  N = size(costs,1)
  @eval function pFit(tour::Vector{T}) where T<:Integer
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
