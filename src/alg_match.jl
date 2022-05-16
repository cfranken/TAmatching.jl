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
free_students = student_array[:]
while length(free_students) > 0
    println(length(free_students))

    # Remove a student from free list:
    _student = popfirst!(free_students)
    #println(_student.name, " ", _student.class_index)
    # Go through favorite classes:
    
    i =  _student.class_index
    indClass = []
    while i<6  && !ismissing(_student.class_list[i]) && length(indClass) == 0
        indClass = getIndex(_student.class_list[i],class_array)
        i +=1
    end
    if length(indClass) == 0
        _student.class_index = 1
        push!(free_students,_student)
    else
        class = class_array[indClass]
        #println(class)
        #println(_student.class_list[1], " Capacity=", class.capacity)
        # If capacity is exceeded, remove worst match
        if length(class.matching) == class.capacity
            push!(free_students, removeLast(class))
        end
        ind = addMatch(class, _student)
        if ind==-1
            push!(free_students,_student)
        end
        if length(class.matching) == class.capacity
            for i = ind+1:length(class.matching)
                class.matching[i].class_index = 1
                push!(free_students,class.matching[i])
                removeMatch(class, class.matching[i])
            end
        end
        _student.class_index += 1
    end
end

for i=1:length(class_array)
    println("########################")
    println(class_array[i].name)
    for j = 1:length(class_array[i].matching)
       println(i, " ", class_array[i].matching[j].name, " ", class_array[i].matchingScore[j])
    end
end
