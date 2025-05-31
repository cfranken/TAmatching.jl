module TAmatching

using YAML, XLSX, DataFrames

include("io.jl")
include("matching.jl")

export loadstudentpreferences, createfacultyfile, loadfacultypreferences, match!, writematches

end
