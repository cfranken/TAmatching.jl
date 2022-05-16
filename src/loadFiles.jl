using DataFrames, XLSX

# Files:
studentFile = "/Users/cfranken/GDrive/work/Caltech/OptionRepWork/TA2021/TA Preferences 2021-22 (Students).xlsx"

facultyFile = "/Users/cfranken/GDrive/work/Caltech/OptionRepWork/TA2021/TA Preferences 2021-22 (Faculty)_May16.xlsx"

# Read into DataFrames:
df_students = DataFrame(XLSX.readtable(studentFile , "Form Responses 1")...)
df_faculty  = DataFrame(XLSX.readtable(facultyFile , "Form Responses 1")...)


# Dicts that are helpful (and can be changed later)
const global StuClass       = Dict([("C1", "First Choice",), ("C2", "Second Choice"), ("C3", "Third Choice"), ("C4", "Fourth Choice"), ("C5", "Fifth Choice")])
const global StuInterest    = Dict([("C1", :"Relative interest in first choice"), ("C2", :"Relative interest in second choice"),("C3", :"Relative interest in third choice"),("C4", :"Relative interest in fourth choice"),("C5", :"Relative interest in fifth choice")])
const global FacTA_student  = Dict([("Class1", :"Course 1 requested TA's:  please list 3, comma separated, top choice first"), ("Class2", :"Course 2 requested TA's:  please list up to 3, comma separated, top choice first"), ("Class3", :"Course 3 requested TA's:  please list up to 3, comma separated, top choice first"), ("Class4", :"Course 4 requested TA's:  please list up to 3, comma separated, top choice first")])
const global FacTA_class    = Dict([("Class1", :"First course"), ("Class2", :"Second course"), ("Class3", :"Third course"), ("Class4", :"Fourth course")])




