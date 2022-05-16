include("tools.jl")
include("loadFiles.jl")


df_classes."Matched"   .= ""
df_classes."Unmatched" .= ""
# Testing class matches
#counter = 1
# Iterate over all rows in faculty sheet:
for row in eachrow(df_faculty)
    println("#######################################################################################")
    println(row["Your Name"])
    # Look for possible courses:
    for course in keys(FacTA_class) 
        #filteredClass = dropmissing(df_faculty,FacTA_class[course])
        if ismissing(row[FacTA_class[course]]) == false
            println(row[FacTA_class[course]])
            ind_matched = findall(df_classes."Class Name".==row[FacTA_class[course]])[1]
            println(ind_matched)
            df_classes[ind_matched,3] = "X"
            println("Selectable candidates (chosen by faculty): ", row[FacTA_student[course]])
            students = split(row[FacTA_student[course]],",")
            # @show students
            println("Student Choices (Name, PriorityRank)")
            for a in keys(StuClass)
                matchedStudent = filter(df -> df[StuClass[a]]  == row[FacTA_class[course]], dropmissing(df_students, StuClass[a]))
                for i=1:size(matchedStudent,1)
                    sName = matchedStudent[!,:"Your Name"][i]
                    matches, _ = matchNames(sName,students)
                    @show sName
                    if matches>1
                        df_classes[ind_matched,4] = df_classes[ind_matched,4] *  sName * ", " 
                        println(sName, " ", matchedStudent[!,StuInterest[a]][i], ", NameMatches: ", matches)
                    else
                        df_classes[ind_matched,5] = df_classes[ind_matched,5]  * sName *  ", "
                    end
                end
            end
            println("____________________________________________________________________________________________")
            #counter +=1
        end
    end
end
outFile = "/Users/cfranken/GDrive/work/Caltech/OptionRepWork/TA2021/testMatch.xlsx"
XLSX.writetable(outFile, collect(DataFrames.eachcol(df_classes)), DataFrames.names(df_classes))