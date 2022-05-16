using TAmatching

# "Main" file for the academic year 2022/2023 
yamlFile = "input/TA_AY2022_23.yaml"

# Load all students (YAML file to be specified):
student_array, df_students = loadStudentPreferences(yamlFile)

### 
# Need to filter out students who don't need to TA (and make sure everyone submitted their choices)

# Create student file (matched list of classes and students who chose those)
createStudentFile(yamlFile, df_students)

####
# Now we need to iterate with faculty to add their own ranks to the choices (student ranks have preference)
###

# TBD




