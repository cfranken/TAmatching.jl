
# Struct for each class, list of students, class name and option
struct gps_class
    student_list::Array
    orig_student_list::Array
    name::String
    option::String
    capacity::Int
    original_capacity::Int
    matching::Array
    matchingScore::Array
end

# Struct for each student, list of students, class name and option
struct gps_student
    class_list::Array
    class_preference::Array
    name::String
    option::String
    email::String
    graduate::String
    class_index::Int
end


