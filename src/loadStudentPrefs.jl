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
    for student in eachrow(df_students)
        println(student."Your Name", " ", student."First Choice")
        class_list = [student[StuClass[i]]    for i in ["C1","C2","C3","C4","C5"]]
        pref_list  = [student[StuInterest[i]] for i in ["C1","C2","C3","C4","C5"]]
        push!(student_array, gps_student(class_list, pref_list, strip(student."Your Name"), student."Your option",student."Email Address", string(student[4]), 1))
    end
    # return students:
    return student_array, df_students
end
