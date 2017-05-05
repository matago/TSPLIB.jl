function vec2LDTbyRow{T}(v::AbstractVector{T}, z::T=zero(T))
    n = length(v)
    s = round(Integer,(sqrt(8n+1)-1)/2)
    s*(s+1)/2 == n || error("vec2LTbyRow: length of vector is not triangular")
    k=0
    [i<=j ? (k+=1; v[k]) : z for i=1:s, j=1:s]'
end

function vec2UDTbyRow{T}(v::AbstractVector{T}, z::T=zero(T))
    n = length(v)
    s = round(Integer,(sqrt(8n+1)-1)/2)
    s*(s+1)/2 == n || error("vec2UTbyRow: length of vector is not triangular")
    k=0
    [i>=j ? (k+=1; v[k]) : z for i=1:s, j=1:s]'
end

function vec2LDTbyCol{T}(v::AbstractVector{T}, z::T=zero(T))
    n = length(v)
    s = round(Integer,(sqrt(8n+1)-1)/2)
    s*(s+1)/2 == n || error("vec2LTbyCol: length of vector is not triangular")
    k=0
    [i>=j ? (k+=1; v[k]) : z for i=1:s, j=1:s]
end

function vec2UDTbyCol{T}(v::AbstractVector{T}, z::T=zero(T))
    n = length(v)
    s = round(Integer,(sqrt(8n+1)-1)/2)
    s*(s+1)/2 == n || error("vec2UTbyCol: length of vector is not triangular")
    k=0
    [i<=j ? (k+=1; v[k]) : z for i=1:s, j=1:s]
end

function vec2UTbyRow{T}(v::AbstractVector{T}, z::T=zero(T))
    n = length(v)
    s = round(Integer,((sqrt(8n+1)-1)/2)+1)
    (s*(s+1)/2)-s == n || error("vec2UTbyRow: length of vector is not triangular")
    k=0
    [i>j ? (k+=1; v[k]) : z for i=1:s, j=1:s]'
end

function vec2FMbyRow{T}(v::AbstractVector{T}, z::T=zero(T))
    n = length(v)
    s = round(Int,sqrt(n))
    s^2 == n || error("vec2FMbyRow: length of vector is not square")
    k=0
    [(k+=1; v[k]) for i=1:s, j=1:s]
end

function findTSP(path::AbstractString)
  if isdir(path)
    syms = [Symbol(split(file,".")[1]) for file in readdir(path) if (split(file,".")[end] == "tsp")]
  else
    error("Not a valid directory")
  end
  return syms
end

