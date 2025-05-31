function match!(students, classes)

  # insert column for TA list
  classes[!,:tas] = [String[] for i = 1:size(classes, 1)]

  # insert column for matched flag
  students[!,:matched] = falses(size(students, 1))

  # iterate until all students are matched or out of choices
  while any(.!students.matched .&& length.(students.classes) .> 0)
    # loop over students
    for s in eachrow(students)
      # attempt match if not matched yet and has selected classes left
      if !s.matched && length(s.classes) > 0
        # get highest priority class and remove it from list
        propclass = pop!(s.classes)
        # find associated class
        c = classes[findfirst(propclass .== classes[:,:class]),:]
        # make sure class needs TAs
        if c.num > 0
          if length(c.tas) < c.num # free slot?
            # add student to class
            push!(c.tas, s.name)
            # flag student as matched
            s.matched = true
          else # no free slot
            # get ranks of currently matched students
            ranks = [findrank(p, c) for p in c.tas]
            # check if current student is ranked more highly
            if findrank(s.name, c) < maximum(ranks)
              # find assigned student with worst ranking in current TA list
              i = argmax(ranks)
              # find that student in full student list
              j = findfirst(c.tas[i] .== students.name)
              # overwrite with current student
              c.tas[i] = s.name
              # tag current student as matched
              s.matched = true
              # tag bumped student as unmatched
              students[j,:matched] = false
            end
          end
        end
      end
    end
  end

  return nothing

end

function findrank(studentname, class)
  i = findfirst(studentname .== [s[1] for s in class.students])
  return class.students[i][2]
end
