function loadFacultyClassPrefs(file)

    class_array = []
    df_classes  = DataFrame(XLSX.readtable(file, 1)...);
    for _class in eachrow(df_classes)
        nTA = _class[2]
        if nTA > -1
            #println(_class."Course", " ", nTA )
            names = Array(_class[3:2:end])
            #@show names
            students = strip.(collect(skipmissing(names)))
            #@show students
            _scores  = Array(_class[4:2:end]);
            scores   = Float64.(collect(skipmissing(_scores)));
            sortedIndex = sortperm(scores,rev=true)
            @assert length(students) == length(scores) "Score - Student mismatch"
            push!(class_array, class(_class."Course", students,scores, student[], Float64[],nTA) );
        end
    end
    return class_array
end

function loadFacultyClassPrefs_v2(file)

    class_array = []
    df_classes  = DataFrame(XLSX.readtable(file, 1)...);
    for _class in eachrow(df_classes)
        nTA = _class[2]
        if nTA > -1
            println(_class."Course", " ", nTA )
            names = Array(_class[3:2:end])
            @show names
            students = strip.(collect(skipmissing(names)))
            #@show students
            _scores  = Array(_class[4:2:end]);
            @show _scores
            scores   = Float64.(collect(skipmissing(_scores)));
            sortedIndex = sortperm(scores,rev=true)
            @assert length(students) == length(scores) "Score - Student mismatch"
            push!(class_array, class(_class."Course", students,scores, student[], Float64[],nTA) );
        end
    end
    return class_array
end