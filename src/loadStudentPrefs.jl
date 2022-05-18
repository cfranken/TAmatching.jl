function loadStudentPreferences(YamlFile)

    # Load YAML file
    
    params_dict = YAML.load_file(YamlFile)
    # "input/TA_AY2022_23.yaml"
    tabName = params_dict["files"]["tab"]

    # Derive name for student Excel file
    studentFile = params_dict["files"]["folder"] * params_dict["files"]["studentFile"]

    # Extract Dictionaries for Class choices and preferences
    StuInterest = params_dict["Interests"]
    StuClass    = params_dict["Classes"]

    # Read into DataFrames:
    df_students = DataFrame(XLSX.readtable(studentFile , tabName)...)

    # Empty Array (speed not important)
    student_array = []

    # This still has some hard-coded strings in there, could move those into the YAML file later:
    for _student in eachrow(df_students)
        println(_student."Your Name", " ", _student."First Choice")
        class_list = reverse(collect(skipmissing([_student[StuClass[i]]    for i in ["C1","C2","C3","C4","C5"]])))
        pref_list  = reverse(collect(skipmissing([_student[StuInterest[i]] for i in ["C1","C2","C3","C4","C5"]])))

        idx = unique(z -> class_list[z], 1:length(class_list))
        # @assert length(idx)>3 "Student chose too few unique classes"
        # Fill in with 1s if students forgot:
        if length(pref_list) < length(class_list)
            while length(pref_list) < length(class_list)
                push!(pref_list,1)
            end
        end

        class_list = class_list[idx]
        pref_list  = pref_list[idx]
        # normalize preference list:
        pref_list  = pref_list./mean(pref_list)

        # Fill in with 1s if students forgot:
        if length(pref_list) < length(class_list)
            while length(pref_list) < length(class_list)
                push!(pref_list,1)
            end
        end
        
        graduating = string(_student[4])
        #@show strip(student."Your Name"), class_list, pref_list, [],[], student."Your option",student."Email Address", "test"
        push!(student_array, student(_student."Your Name", class_list, pref_list, nothing, nothing, _student."Your option",_student."Email Address", graduating))
    end
    # return students:
    return student_array, df_students
end
