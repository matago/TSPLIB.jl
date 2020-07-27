
function euclidian(x::Vector{T},y::Vector{T}) where T<:Real
  nsz = length(x)
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

function att_euclidian(x::Vector{T},y::Vector{T}) where T<:Real
  nsz = length(x)
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

function ceil_euclidian(x::Vector{T},y::Vector{T}) where T<:Real
  nsz = length(x)
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

function geo(x::Vector{T},y::Vector{T}) where T<:Real
  PI = 3.141592
  RRR = 6378.388
  nsz = length(x)
  dist = zeros(T,nsz,nsz)
  degs = trunc.(hcat(x,y))
  mins = hcat(x,y).-degs
  coords = PI.*(degs.+(5.0.*(mins./3.0)))./180.0
  lat = coords[:,1]
  lon = coords[:,2]

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
