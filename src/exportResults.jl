function exportResults(file, classes, students)
    # Create empty Excel file
    xf = XLSX.open_empty_template()
    
    # Classes first
    sheet = xf[1]
    XLSX.rename!(sheet, "Matched Classes")
    sheet[1,1] = "Course Name"
    sheet[1,2] = "Course nTA"
    sheet[1,3] = "Student #"


    # Loop through classes:
    for iC = 1:length(classes)
        class = classes[iC]
        sheet[iC+1,1] = class.name
        sheet[iC+1,2] = class.capacity
        if length(class.current_matches) > 0
            for j=1:length(class.current_matches)
                sheet[iC+1,2+j] = class.current_matches[j].name * " , OverallScore= " * string(class.current_scores[j]) * " StudentScore= " * string(class.current_matches[j].current_preference)
            end
        end
    end

    # Unassigned Students
    sheet = XLSX.addsheet!(xf, "Unassigned Students")
    #XLSX.rename!(sheet, "Unassigned Students")
    sheet[1,1] = "Student Name"
    sheet[1,2] = "Option"
    sheet[1,3] = "Courses chosen ..."

    counter = 1
    for i = 1:length(students)
        match = false
        for _class in classes
            for matches in _class.current_matches
                if students[i].name == matches.name
                    match = true
                end
            end
        end
        if !match
            sheet[counter+1,1] = students[i].name
            sheet[counter+1,2] = students[i].option
            for j = 1:length(students[i].class_choices_all)
                choice = students[i].class_choices_all[j]
                pref   = students[i].class_preferences_all[j]
                sheet[counter+1,2+j] = choice * " , " *  string(pref)
            end
            counter +=1
        end
    end
    
    # Save file:
    XLSX.writexlsx(file, xf, overwrite=true)
    close(xf)
end