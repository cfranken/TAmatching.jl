using TAmatching, YAML

# load settings from YAML file
params = YAML.load_file("data/2025/settings.yaml")

# load students
students = loadstudentpreferences(params)

# filter out students who are graduating
filter!(s -> !s.graduate, students)

# create faculty file for their input
createfacultyfile(students, params)

# run the matching algorithm once faculty have specified their preferences
facultyfile = params["files"]["rootfolder"] * params["files"]["inputfolder"] * params["files"]["facultyfile"]
if isfile(facultyfile)
  # load faculty rankings
  classes = loadfacultypreferences(params)
  # run matching
  match!(students, classes)
  # write output
  writematches(students, classes, params)
end
