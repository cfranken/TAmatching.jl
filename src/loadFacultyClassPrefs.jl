class_file_final = "/Users/cfranken/GDrive/work/Caltech/OptionRepWork/TA2021/GPS_TA_List_2020_2021.xlsx"


tabs =  ["Division", "Geology", "Geophysics", "Geobiology", "Geochemistry", "Planetary Science", "ESE", "Special Courses"]

class_array = []
for ii in eachindex(tabs)
    println(tabs[ii])
    df_classes  = DataFrame(XLSX.readtable(class_file_final, tabs[ii])...)
    for class in eachrow(df_classes)
        if class[2] > 0
            println(class."Class Name", " ", class[2] , " " , tabs[ii])
            names = split(class."Matched",",")
            students = strip.(names)
            push!(class_array, gps_class(students,students,class."Class Name",tabs[ii], class[2], class[2], [],[]) )
        end
    end
end