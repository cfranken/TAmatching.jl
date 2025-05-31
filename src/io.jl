function loadstudentpreferences(params)

  # name of xlsx file containing student input
  file = params["files"]["rootfolder"] * params["files"]["inputfolder"] * params["files"]["studentsfile"]

  # column labels
  collabels = params["studentscollabels"]

  # multiples choice labels
  mclabels = params["studentsmclabels"]

  # read student preferences into a DataFrame
  dfin = DataFrame(XLSX.readtable(file, 1))

  # create clean DataFrame with known labels, classes are in reverse order of preference
  dfout = DataFrame(name=String[], option=String[], graduate=Bool[], classes=Array{String}[])
  for s in eachrow(dfin)
    name = s[collabels["name"]]
    option = s[collabels["option"]]
    graduate = s[collabels["graduate"]] == mclabels["graduateyes"]
    classes = [s[collabels["classes"][i]] for i = 1:length(collabels["classes"])]
    push!(dfout, [name, option, graduate, reverse(collect(skipmissing(classes)))])
  end

  println("Student input read from $file.")

  return dfout

end

function createfacultyfile(students, params)

  # file names
  classesfile = params["files"]["rootfolder"] * params["files"]["inputfolder"] * params["files"]["classesfile"]
  facultyfile = params["files"]["rootfolder"] * params["files"]["outputfolder"] * params["files"]["facultyfile"]

  # read classes files (students not populated)
  classes = DataFrame(XLSX.readtable(classesfile, 1, header=true))

  # label of class column
  classlabel = params["classescollabels"]["class"]

  # add students to classes
  for c in eachrow(classes)
    for s in eachrow(students)
      if c[classlabel] in s.classes
        i = findfirst([ismissing(c[j]) for j = 3:2:72])
        c[1+2i] = s.name
      end
    end
  end
    
  # write to xlsx file
  XLSX.writetable(facultyfile, "ranking"=>classes; overwrite=true)

  println("Faculty file created at $facultyfile.")

  return nothing

end

function loadfacultypreferences(params)

  # name of xlsx file containing student input
  file = params["files"]["rootfolder"] * params["files"]["inputfolder"] * params["files"]["facultyfile"]

  # column labels
  collabels = params["classescollabels"]

  # read faculty preferences into a DataFrame
  dfin = DataFrame(XLSX.readtable(file, 1))

  # create clean table with known labels
  dfout = DataFrame(class=String[], num=Int[], students=Array{Tuple{String, Int}}[])
  for s in eachrow(dfin)
    class = s[collabels["class"]]
    num = s[collabels["num"]]
    students = Tuple{String, Int}[]
    i = 1
    while !ismissing(s[1+2i])
      push!(students, (s[1+2i], s[2+2i]))
      i += 1
    end
    push!(dfout, [class, num, students])
  end

  println("Faculty input read from $file.")

  return dfout

end

function writematches(students, classes, params)

  # create table for classes output
  dfc = DataFrame()
  dfc[!,"class"] = classes.class
  dfc[!,"TAs requested"] = classes.num
  dfc[!,"TAs assigned"] = length.(classes.tas)
  for i = 1:maximum(classes.num)
    dfc[!,"TA $i"] = ["" for i = 1:size(dfc, 1)]
  end
  for i = 1:size(dfc, 1)
    for j = 1:length(classes[i,:tas])
      dfc[i,3+j] = classes[i,:tas][j]
    end
  end

  # create table for student output
  dfs = DataFrame()
  dfs[!,"name"] = students.name
  dfs[!,"class"] = ["" for i = 1:size(dfs, 1)]
  for i = 1:size(dfs, 1)
    if students[i,:matched]
      for c in eachrow(classes)
        if dfs[i,:name] in [c.tas[j] for j = 1:length(c.tas)]
          dfs[i,:class] = c.class
        end
      end
    end
  end

  # file name
  file = params["files"]["rootfolder"] * params["files"]["outputfolder"] * params["files"]["matchesfile"]

  # write to xlsx file
  XLSX.writetable(file, "classes"=>dfc, "students"=>dfs; overwrite=true)

  println("Matches file created at $file.")

  return nothing

end
