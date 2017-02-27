
function readTSP(file_path::String)
  _raw = readstring(file_path)
  tsp_keys = ["NAME",
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
  #=initialize PQ for indices of tsp_keys & Dict for associated content
  PriorityQueue{String,Tuple{Integer,Integer},Base.Order.ForwardOrdering}
  =#
  _pq = PriorityQueue{String,Tuple{Integer,Integer},Base.Order.ForwardOrdering}()
  _dict = Dict{String,Any}()
  #Find keys in _raw and store start and stop points in PriorityQueue
  for i in 1:length(tsp_keys)
    idx = search(_raw,tsp_keys[i])
    length(idx) > 0 && enqueue!(_pq,tsp_keys[i],extrema(idx))
  end
  sizehint!(_dict,length(_pq))
  #=Extract information from start and stop intervals from _raw
  mapping s-->f for current content=#
  while length(_pq) > 1
    s_key, s_pts = peek(_pq)
    dequeue!(_pq)
    f_key, f_pts = peek(_pq)
    _rng = (s_pts[2]+1):(f_pts[1]-1)
    _dict[s_key] = strip(replace(_raw[_rng],":",""))
  end
  #convert dimension to Int64 & clean "TYPE"
  n_dim = _dict["DIMENSION"] =  convert(Int64,float(_dict["DIMENSION"]))
  _dict["TYPE"] = split(_dict["TYPE"])[1]
  #=
  Start of analysis section where numeric infromation begins to be extracted
  =#
  #for NODES given that require a distance calculation
  if haskey(_dict,"NODE_COORD_SECTION")
    coords = float(split(_dict["NODE_COORD_SECTION"]))
    n_r = convert(Int64,length(coords)/n_dim)
    _dict["NODE_COORD_SECTION"] = nodes = reshape(coords,(n_r,n_dim))'

    _dict["EDGE_WEIGHT_SECTION"] = @match _dict["EDGE_WEIGHT_TYPE"] begin
      "EUC_2D" => euclidian(nodes[:,2], nodes[:,3])
      "GEO" => haversine(nodes[:,2], nodes[:,3])
      "ATT" => att_euclidian(nodes[:,2], nodes[:,3])
      "CEIL_2D" => ceil_euclidian(nodes[:,2], nodes[:,3])
    end
  #for EXPLICIT distances given
  elseif haskey(_dict,"EDGE_WEIGHT_SECTION") && _dict["EDGE_WEIGHT_TYPE"] == "EXPLICIT"
    weights = float(split(_dict["EDGE_WEIGHT_SECTION"]))
    _dict["EDGE_WEIGHT_SECTION"] = @match _dict["EDGE_WEIGHT_FORMAT"] begin
      "UPPER_DIAG_ROW" => vec2UTbyRow(weights)
      "LOWER_DIAG_ROW" => vec2LTbyRow(weights)
      "UPPER_DIAG_COL" => vec2UTbyCol(weights)
      "LOWER_DIAG_COL" => vec2LTbyCol(weights)
    end
    _dict["EDGE_WEIGHT_SECTION"] .+= _dict["EDGE_WEIGHT_SECTION"]'
  end
  return _dict
end
