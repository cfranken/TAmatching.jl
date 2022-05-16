include("structs.jl")
# Load student preferences:
include("loadStudentPrefs.jl")
# Rui is a special case (had TAd twice before)
filter!(x->x.name ≠ "Rui Cheng", student_array)
# Filter graduating students (can move some back in if they want to TA!)
filter!(x->x.graduate == "No", student_array)
# Reload class preferences (makes matching empty)
include("loadFacultyClassPrefs.jl")

# Create array with free students:
free_students = deepcopy(student_array)

# While there are still free students:

while length(free_students) > 0
    println(length(free_students))

    # Remove a student from free list:
    _student = popfirst!(free_students)
    println(_student.name)
    
    # Go through favorite classes:
    assigned = false
    for s_class in skipmissing(_student.class_list)
        indClass = getIndex(s_class,class_array)
        if length(indClass) > 0
            class = class_array[indClass]
            # Provisional match:
            println(class, _student)
            ind = addMatch(class, _student)
            
            # if oversubscribed:
            if length(class.matching) > class.original_capacity
                for i = class.original_capacity+1:length(class.matching)
                    push!(free_students,class.matching[i])
                    removeMatch(class, class.matching[i])
                end
            end
        end
    end
        
end

s = 0
sSum = 0
for i=1:length(class_array)
    println("########################")
    println(class_array[i].name)
    for j = 1:length(class_array[i].matching)
       println(i, " ", class_array[i].matching[j].name, " ", class_array[i].matchingScore[j])
       s+=1
       sSum += class_array[i].matchingScore[j]
    end
end
