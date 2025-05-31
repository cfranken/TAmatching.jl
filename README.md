# TAmatching.jl
TA matching for Caltech GPS (beta)

This package allows the matching of TAs to classes treating it as a [stable matching problem]{https://en.wikipedia.org/wiki/Stable_matching_problem}. It uses the [Gale–Shapley algorithm]{https://en.wikipedia.org/wiki/Gale%E2%80%93Shapley_algorithm} with students in the role of proposers, ensuring optimal matching for the students.

The most important steps are as follows:

## Create an Excel sheet with all classes and indicate the number of TAs required:
<img width="1065" alt="Screen Shot 2022-05-16 at 2 06 22 PM" src="https://user-images.githubusercontent.com/10467190/168589090-9a8566ae-aca3-489f-b80e-33de7d0b6975.png">


## Create a Google form for course selection for all students
We then create a Google form in which all students select their choices of courses to TA. All student must select five courses and rank them by their preference. It is easy to just copy & paste the class list into the respective fields:
<img width="860" alt="Screen Shot 2022-05-16 at 2 09 05 PM" src="https://user-images.githubusercontent.com/10467190/168589371-552445bc-37a4-4cf6-8f8d-bc7e655126c1.png">

## Download student response form as Excel sheet
Right now, we just download the form data as Excel sheet (from the Google sheet created from the form). This can in principle be done by an API in the future.

## Run script on student input
Once the student input has been collated, we run `src/main.jl` to generate a new sheet that will be used for faculty input. This populates classes with all students who have chosen that class and allows for input fields that will be filled out by the faculty.

## Obtain faculty input
The sheet for faculty input is distributed to the faculty, who will rank all students interested in TAing their class. It is important that nothing is changed in this form other than the ranking. All students must be ranked, with 1 being best and all ranks having to be unique.

## Run matchmaking algorithm
Once the faculty ranking has been collected, we run `src/main.jl` again to run the matching algorithm and generate a final sheet with the TA assignments and an output of the list of students. It is possible that not all classes are assigned a TA and that some students are not assigned a class. This is easy to see in the generated sheet and must be fixed manually.
