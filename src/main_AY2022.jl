using TAmatching

# "Main" file for the academic year 2022/2023 
yamlFile = "input/TA_AY2022_23.yaml"

# Load all students (YAML file to be specified):
student_array, df_students = loadStudentPreferences(yamlFile)


### 
# Need to filter out students who don't need to TA (and make sure everyone submitted their choices)
# Filter graduating students (can move some back in if they want to TA!)
filter!(x->x.graduate == "No", student_array)

# Create student file (matched list of classes and students who chose those)
createStudentFile(yamlFile, df_students)

#### Now we need to iterate with faculty to add their own ranks to the choices (student ranks have preference)
###

# TBD

file = "/Users/cfranken/Library/CloudStorage/GoogleDrive-cfranken@caltech.edu/My Drive/TA_AY2022_2023/ExtractedStudent_TA_Preferences_2022-23.xlsx"

class_array = loadFacultyClassPrefs(file)

for _student in student_array
    find_next(_student, class_array)
end

allScore = 0
for class in class_array
    if length(class.current_matches) > 0
        println(class.name, "; ", class.current_matches[end].name,  "; ", class.current_scores)
        allScore += sum(class.current_scores)
    else
        println("Class ",class.name, " has no TAs assigned" )
    end
end

