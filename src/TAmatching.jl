module TAmatching

using YAML
using XLSX
using DataFrames

include("structs.jl")
include("tools.jl")
include("loadStudentPrefs.jl")
include("createStudentFile.jl")

export loadStudentPreferences, createStudentFile


end # module
