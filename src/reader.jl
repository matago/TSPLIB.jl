
type TSP
  name::AbstractString
  dimension::Integer
  weight_type::AbstractString
  weights::Matrix
  nodes::Matrix
  ffx::Function
  pfx::Function
end

const tsplib_path = joinpath(Pkg.dir("TSPLIB"),"data","TSPLIB95","tsp")

const tsp_keys = ["NAME", "TYPE", "COMMENT", "DIMENSION", "EDGE_WEIGHT_TYPE",
                    "EDGE_WEIGHT_FORMAT", "EDGE_DATA_FORMAT", "NODE_COORD_TYPE",
                    "DISPLAY_DATA_TYPE", "NODE_COORD_SECTION", "DEPOT_SECTION",
                    "DEMAND_SECTION", "EDGE_DATA_SECTION", "FIXED_EDGES_SECTION",
                    "DISPLAY_DATA_SECTION", "TOUR_SECTION", "EDGE_WEIGHT_SECTION",
                    "EOF"]


function readTSP(path::AbstractString)
  raw = readstring(path)
  return _generateTSP(raw)
end

function readTSPLIB(path::Symbol)
  raw = readstring(joinpath(tsplib_path,string(path)*".tsp"))
  return _generateTSP(raw)
end


function _generateTSP(raw::AbstractString)
  _dict = keyextract(raw, tsp_keys)
  name = _dict["NAME"]
  dimension = convert(Integer,float(_dict["DIMENSION"]))
  weight_type = _dict["EDGE_WEIGHT_TYPE"]

  if weight_type == "EXPLICIT" && haskey(_dict,"EDGE_WEIGHT_SECTION")
    explicits = float(split(_dict["EDGE_WEIGHT_SECTION"]))
    weights = explicit_weights(_dict["EDGE_WEIGHT_FORMAT"],explicits)
    nodes = zeros(dimension,2)
  elseif haskey(_dict,"NODE_COORD_SECTION")
    coords = float(split(_dict["NODE_COORD_SECTION"]))
    n_r = convert(Integer,length(coords)/dimension)
    nodes = reshape(coords,(n_r,dimension))'[:,2:end]
    weights = calc_weights(_dict["EDGE_WEIGHT_TYPE"],nodes)
  end

  fFX = fullFit(weights)
  pFX = partFit(weights)

  TSP(name,dimension,weight_type,weights,nodes,fFX,pFX)
end

function keyextract{T<:AbstractString}(raw::T,ks::Array{T})
  pq = PriorityQueue{T,Tuple{Integer,Integer},Base.Order.ForwardOrdering}()
  vals = Dict{T,T}()
  for k in ks
    idx = search(raw,k)
    length(idx) > 0 && enqueue!(pq,k,extrema(idx))
  end
  while length(pq) > 1
    s_key, s_pts = peek(pq)
    dequeue!(pq)
    f_key, f_pts = peek(pq)
    rng = (s_pts[2]+1):(f_pts[1]-1)
    vals[s_key] = strip(replace(raw[rng],":",""))
  end
  return vals
end


function explicit_weights(key::AbstractString,data::Vector{AbstractFloat})
  w = @match key begin
    "UPPER_DIAG_ROW" => vec2UTbyRow(data)
    "LOWER_DIAG_ROW" => vec2LTbyRow(data)
    "UPPER_DIAG_COL" => vec2UTbyCol(data)
    "LOWER_DIAG_COL" => vec2LTbyCol(data)
  end
  w.+=w'
  return w
end

function calc_weights(key::AbstractString,data::Matrix)
  w = @match key begin
    "EUC_2D" => euclidian(data[:,1], data[:,2])
    "GEO" => geo(data[:,1], data[:,2])
    "ATT" => att_euclidian(data[:,1], data[:,2])
    "CEIL_2D" => ceil_euclidian(data[:,1], data[:,2])
  end

  return w
end
