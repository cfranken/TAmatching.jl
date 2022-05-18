# Struct for each class, list of students, class name and option
Base.@kwdef mutable struct class
    name::String
    all_matches
    all_scores::Array{Float64}
    current_matches
    current_scores::Array{Float64}
    capacity::Int
end

# Struct for each student, list of students, class name and option
Base.@kwdef mutable struct student
    name::String
    class_choices::Array{String}
    class_preferences::Array{Float64}
    current_choice #::Array{class}
    current_preference #::Array{Float64}
    option::String
    email::String
    graduate::String
end


