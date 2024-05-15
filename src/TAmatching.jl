module TAmatching

using YAML
using XLSX
using DataFrames
using Statistics

include("structs.jl")
include("tools.jl")
include("loadStudentPrefs.jl")
include("createStudentFile.jl")
include("loadFacultyClassPrefs.jl")
include("exportResults.jl")

export loadStudentPreferences, createStudentFile, loadFacultyClassPrefs, compute_score, find_next


end # module
