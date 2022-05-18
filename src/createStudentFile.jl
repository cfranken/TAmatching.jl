using YAML

function createStudentFile(yamlFile, df_students)
    
    params_dict     = YAML.load_file(yamlFile)
    global StuClass = params_dict["Classes"]
    
    classFile = params_dict["files"]["folder"] * params_dict["files"]["classFile"] 
    outFile   = params_dict["files"]["folder"] * params_dict["files"]["outFile"]

    # Create empty Excel file
    xf = XLSX.open_empty_template()
    
    # Load original class file (includes dummy entries for student names and rank)
    df_classes  = DataFrame(XLSX.readtable(classFile, 1, header=true)...)

    # Iterate through classes (important, names in Excel file and form have to match!!)
    for class in df_classes."Course"
        println("")
        find_matched_students(df_classes, df_students, class)
    end
    sheet = xf[1]
    # Write new Excel file with matched results per class (rank to be filled in by faculty)
    XLSX.writetable!(sheet, collect(DataFrames.eachcol(df_classes)), DataFrames.names(df_classes))
    XLSX.writexlsx(outFile, xf, overwrite=true)
    close(xf)
end