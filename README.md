# TSPLIB.jl

[![Build Status](https://github.com/matago/TSPLIB.jl/workflows/CI/badge.svg?branch=master)](https://github.com/matago/TSPLIB.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/matago/TSPLIB.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/matago/TSPLIB.jl)

This reads `.tsp` data files in the [TSPLIB format](http://webhotel4.ruc.dk/~keld/research/LKH/LKH-2.0/DOC/TSPLIB_DOC.pdf) for Traveling Salesman Problem (TSP) instances and returns `TSP` type.

```julia
struct TSP
    name        ::AbstractString
    dimension   ::Integer
    weight_type ::AbstractString
    weights     ::Matrix
    nodes       ::Matrix
    Dnodes      ::Bool
    ffx         ::Function
    pfx         ::Function
    optimal     ::Float64
end
```

Some TSP instances in the [TSPLIB](http://elib.zib.de/pub/mp-testdata/tsp/tsplib/tsplib.html) library are preloaded. See the [list](https://github.com/matago/TSPLIB.jl/tree/master/data/TSPLIB95/tsp).

For example, to load `a280.tsp`, you can do:
```julia
tsp = readTSPLIB(:a280)
```

For custom TSP files, you can load:
```julia
tsp = readTSP(path_to_tsp_file)
```

