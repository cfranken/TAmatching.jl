for student ∈ student_array
    if student.option == "ESE"
        println("########################")
        println(student.name)
        for j = 1:5
            println(student.class_list[j], " ", student.class_preference[j])
        end
    end
end