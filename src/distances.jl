
function euclidian{T<:Real}(x::Vector{T},y::Vector{T})
  const nsz = length(x)
  dist = zeros(T,nsz,nsz)

  for i in 1:nsz, j in 1:nsz
    if i<=j
      xd = (x[i]-x[j])^2
      yd = (y[i]-y[j])^2
      dist[i,j] = dist[j,i] = round(sqrt(xd+yd),RoundNearestTiesUp)
    end
  end
  return dist
end

function att_euclidian{T<:Real}(x::Vector{T},y::Vector{T})
  const nsz = length(x)
  dist = zeros(T,nsz,nsz)

  for i in 1:nsz, j in 1:nsz
    if i<=j
      xd = (x[i]-x[j])^2
      yd = (y[i]-y[j])^2
      dist[i,j] = dist[j,i] = ceil(sqrt((xd+yd)/10.0))
    end
  end
  return dist
end

function ceil_euclidian{T<:Real}(x::Vector{T},y::Vector{T})
  const nsz = length(x)
  dist = zeros(T,nsz,nsz)

  for i in 1:nsz, j in 1:nsz
    if i<=j
      xd = (x[i]-x[j])^2
      yd = (y[i]-y[j])^2
      dist[i,j] = dist[j,i] = ceil(sqrt(xd+yd))
    end
  end
  return dist
end

function haversine{T<:Real}(x::Vector{T},y::Vector{T})
  const PI = 3.141592
  const RRR = 6378.388
  const nsz = length(x)
  dist = zeros(T,nsz,nsz)
  const degs = trunc(hcat(x,y))
  const mins = hcat(x,y).-degs
  const coords = PI.*(degs.+(5.0.*(mins./3.0)))./180.0
  const lat = coords[:,1]
  const lon = coords[:,2]

  for i in 1:nsz, j in 1:nsz
    if i<=j
      q1 = cos(lon[i]-lon[j])
      q2 = cos(lat[i]-lat[j])
      q3 = cos(lat[i]+lat[j])
      dij = RRR.*acos(0.5.*((1.0.+q1).*q2.-(1.0.-q1).*q3)).+1.0
      dist[i,j] = dist[j,i] = round(dij,RoundNearestTiesUp)
    end
  end
  return dist
end
