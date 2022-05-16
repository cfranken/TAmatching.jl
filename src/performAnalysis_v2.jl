include("tools.jl")
include("loadFiles.jl")


xf = XLSX.open_empty_template()


# Testing class matches
#counter = 1
# Iterate over all classes:
classFile   = "/Users/cfranken/GDrive/work/Caltech/OptionRepWork/TA2021/GPSClassList_2021.xlsx"
tabs =  ["Division", "Geology", "Geophysics", "Geobiology", "Geochemistry", "Planetary Science", "ESE", "Special Courses"]
data_per_option = []
for ii in eachindex(tabs)
    println(tabs[ii])
    df_classes  = DataFrame(XLSX.readtable(classFile, tabs[ii])...)
    df_classes."Matched"   .= ""
    df_classes."Unmatched" .= ""
    for class in df_classes."Class Name"
        foundEntry = false
        for row in eachrow(df_faculty)
            for course in keys(FacTA_class)
                    #filteredClass = dropmissing(df_faculty,FacTA_class[course])
                if ismissing(row[FacTA_class[course]]) == false
                    # Look for match:
                    if class == row[FacTA_class[course]]
                        foundEntry = true
                        #println(row[FacTA_class[course]])
                        find_matched_students(df_classes, df_students, row, course)
                    end
                end
            end
        end
        if !foundEntry
            find_matched_students(df_classes, df_students, class)
            #println(class, " ", !foundEntry)
        end
    end

    # Export to Excel:
    if xf[1].name == "Sheet1"
        # first sheet already exists in template file
        sheet = xf[1]
        XLSX.rename!(sheet, tabs[ii])
        XLSX.writetable!(sheet, collect(DataFrames.eachcol(df_classes)), DataFrames.names(df_classes))
    else
        println("Adding new tab ",tabs[ii] )
        sheet = XLSX.addsheet!(xf, tabs[ii])
        XLSX.writetable!(sheet, collect(DataFrames.eachcol(df_classes)), DataFrames.names(df_classes))
    end
    #push!(data_per_option,df_classes)
end

outFile = "/Users/cfranken/GDrive/work/Caltech/OptionRepWork/TA2021/GPS_TA_2021_matchedList.xlsx"
XLSX.writexlsx(outFile, xf, overwrite=true)