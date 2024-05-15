using TAmatching

# "Main" file for the academic year 2022/2023 
yamlFile = "input/TA_AY2023_24.yaml"

# Load all students (YAML file to be specified):
student_array, df_students = loadStudentPreferences(yamlFile);


### 
# Need to filter out students who don't need to TA (and make sure everyone submitted their choices)
# Filter graduating students (can move some back in if they want to TA!)
filter!(x->x.graduate == "No", student_array);

# Create student file (matched list of classes and students who chose those)
createStudentFile(yamlFile, df_students);

#### Now we need to iterate with faculty to add their own ranks to the choices (student ranks have preference)
###

# TBD

file = "/Users/cfranken/Library/CloudStorage/GoogleDrive-cfranken@caltech.edu/My Drive/TA_AY2023_2024/GPS_TA_2023_2024.xlsx"

class_array = loadFacultyClassPrefs(file);

# This creates best matches for students but could leave some classes unassigned
for _student in student_array
    find_next(_student, class_array, student_array)
end

file2 = "/Users/cfranken/GPS_TA_Matches_20230525.xlsx"
TAmatching.exportResults(file2, class_array, student_array)

#=

# Now we would need to check if classes are all filled...
offset = 0.5
for a in student_array
    iScore_new, iScore_old, iC =  TAmatching.matches_unassigned_class(a, class_array)
    # A hack here:
    if (iScore_new > 0) & (iScore_new + offset > iScore_old) 
        find_next(a,class_array, student_array)
    end
end


for class in class_array
    if (length(class.current_matches) == 0) & (class.capacity>0)
        println("Class ",class.name, " has no TAs assigned" )
        println(class.all_matches, " ", class.all_scores)
    end
end

allScore = 0
allTA = 0
for class in class_array
    if length(class.current_matches) > 0
        println(class.name, "; ", [i.name for i in class.current_matches],  "; ", class.current_scores)
        allScore += sum(class.current_scores)
        allTA += length(class.current_matches)
    else
        println("Class ",class.name, " has no TAs assigned" )
        println(class.all_matches, " ", class.all_scores)
    end
end

# Need to find unassigned students:
for i = 1:length(student_array)
    
    match = false
    for _class in class_array
        for matches in _class.current_matches
            if student_array[i].name == matches.name
                match = true
            end
        end
    end
    if !match
        println(student_array[i].name, " , not assigned,  ",  student_array[i].class_choices,student_array[i].class_choices_all )
        student_array[i].class_choices     = deepcopy(student_array[i].class_choices_all)
        student_array[i].class_preferences = deepcopy(student_array[i].class_preferences_all)
        find_next(student_array[i],class_array, student_array)
    end
end

=#