using Statistics
using Random
using DataFrames, XLSX

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
shuffle!(free_students)
# While there are still free students

while length(free_students) > 0
    
    # pop random student out of first place:
    #if length(free_students) <20
    #push!(free_student, popfirst!)

    println(length(free_students))
    shuffle!(free_students)
    # Remove a student from free list:
    _student = popfirst!(free_students)
    #println(_student.name)
    
    # Go through favorite classes:
    assigned = false
    for s_class in skipmissing(_student.class_list[_student.class_index:end])
        indClass = getIndex(s_class,class_array)
        _student.class_index += 1
        if length(indClass) > 0
            class = class_array[indClass]
            # if free slots available
            if length(class.matching) < class.original_capacity
                if student_match(class, _student)
                    addMatch(class, _student)
                    assigned = true
                    break
                end
            else
                if student_match(class, _student)
                    # Compute score
                    score = match_score(class,_student)
                    #println(score, " ", class.matchingScore[end])
                    # If better than worst student, add to the list:
                    #if score ≥ (class.matchingScore[end])-8
                    if score>2
                        push!(free_students,removeLast(class))
                        ind = addMatch(class, _student)
                        assigned = true
                        # Remove all below that score:
                        #if length(class.matching) ≥ class.original_capacity
                        #    println(ind)
                        #    for i = ind+1:length(class.matching)
                        #        class.matching[i].class_index = 1
                        #        push!(free_students,class.matching[i])
                        #        removeMatch(class, class.matching[i])
                        #    end
                        #end                    
                        break
                    end
                end    
            end
        end
        
    end
    if !assigned
        _student.class_index = 1
        push!(free_students,_student)
    end
    if length(free_students)<6
        break
    end
end

global s = 0
for i=1:length(class_array)
    println("########################")
    println(class_array[i].name)
    for j = 1:length(class_array[i].matching)
       println(i, " ", class_array[i].matching[j].name, " ", class_array[i].matchingScore[j])
       global s+=1
    end
end
