const global options = ["Geology", "Geophysics", "Geobiology", "Geochemistry", "Planetary Science", "ESE"] 

# Order in list must be reversed (best in the last)
function find_next_preference(student)
    class = pop!(student.class_choices)
    class_preference = pop!(student.class_preferences)
    return class, class_preference
end

# Find next student choice
function find_next(student, class_array)
    if length(student.class_choices) == 0
        student.current_choice     = []
        #student.current_preference = []
        return false
    else
        class_choice, class_preference = find_next_preference(student)
        @show student.name, class_choice
        if apply_to(class_array, class_choice, student, class_preference)
            #student.current_choice = class_array[i]
            return true
        end
    end
    find_next(student, class_array)
end

function apply_to(class_array, class_name, _student, class_preference)
    i = findall(x -> x.name==class_name,class_array)[1]
    
    # First make sure the name is in the list:
    if _student.name in class_array[i].all_matches
        iScore = compute_score(class_array[i],_student, class_preference)
        @show _student.name, iScore, class_name
        # Still space? then add to the list...
        if length(class_array[i].current_matches) < class_array[i].capacity
            push!(class_array[i].current_matches, _student)
            push!(class_array[i].current_scores, iScore)
            # Sort now!
            sort!(class_array[i])
            _student.current_choice = class_array[i]
            return true
        end

        # If class is full, check if match is better than the last in the list
        if iScore > class_array[i].current_scores[end]
            replaced = pop!(class_array[i].current_matches)
            pop!(class_array[i].current_scores)

            push!(class_array[i].current_matches, _student)
            push!(class_array[i].current_scores, iScore)
            sort!(class_array[i])
            _student.current_choice = class_array[i]
            find_next(replaced,class_array)
            return true
        end
    end
    return false
end

# Sort scores and matches:
function sort!(_class::class)
    sortedIndex = sortperm(_class.current_scores,rev=true)
    @show _class.current_scores, _class.current_matches
    _class.current_scores  = _class.current_scores[sortedIndex]
    _class.current_matches = _class.current_matches[sortedIndex]
end

# Compute matching score (faculty input counts 0.5 times as much)
function compute_score(_class::class, _student::student, class_preference)
    # iClass   = findall(x -> x==_class.name   , _student.class_choices)
    iStudent = findall(x -> x==_student.name , _class.all_matches)
    
    # Need a match
    if length(iStudent) == 0
        #@show _student.name, _class.name, length(iClass) , length(iStudent), _student.class_choices , _class.all_matches
        #@show _student.class_choices
        #println("##########")
        return 0.0
    else
        # iClass   = iClass[1]
        iStudent = iStudent[1]
        norm_class   = mean(_class.all_scores)

        # This can be adapted in the future:
        score =  class_preference + (_class.all_scores[iStudent]/norm_class)/2
        @show score
        return score
    end
end

"find matches for students (for a class, with faculty input missing)"
function find_matched_students(df_classes, df_students, class)
    ind_matched = findall(df_classes."Course".==class)[1]
    println(class, " ",  ind_matched)
    local j = 0
    for a in keys(StuClass)
        matchedStudent = filter(df -> occursin(lowercase(class), lowercase(df[StuClass[a]])), dropmissing(df_students, StuClass[a]))
        for i=1:size(matchedStudent,1)
            j += 1
            sName = matchedStudent[!,:"Your Name"][i]
            println(sName)
            # This index is still a bit hardcoded, #1 is course name, #2 is number of TAs, then student name and faculty rankings
            iName = 3 + (j-1)*2
            #@show iName, j
            df_classes[ind_matched,iName] = sName
            # Add a dummy score here:
            df_classes[ind_matched,iName+1] = 1
        end
    end
    println("########################")
end

function getIndex(name, list)
    ind = findall(x->x.name==name, list)
    if length(ind) > 1
        @info "Multiple indices", ind
    end
    if length(ind)<1
        return []
    else
        return ind[1]
    end
end

