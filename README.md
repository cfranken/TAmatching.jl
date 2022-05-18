# TAmatching.jl
TA matching for Caltech GPS (beta)

This package enables a beta version for TA matching based on available algorithms in other areas (matchmaking, e.g. the National Resident Matching Program). Largely follows the Roth Peranson Match Algorithm now, with inspiration from https://github.com/J-DM/Roth-Peranson

The most important steps are as follows:

## Create an Excel sheet with all classes that require a TA (i.e. filtered), see for instance below:
<img width="1065" alt="Screen Shot 2022-05-16 at 2 06 22 PM" src="https://user-images.githubusercontent.com/10467190/168589090-9a8566ae-aca3-489f-b80e-33de7d0b6975.png">


## Create a Google form for course selection for all students
We first have to create a google form, in which all students have to select their choices of courses to TA, for which they can can also rank priority. At least 3 choices have to be made per student, with up to 5 (optional). It is easy to just copy & paste the class list into the respective fields, see below as example:
<img width="860" alt="Screen Shot 2022-05-16 at 2 09 05 PM" src="https://user-images.githubusercontent.com/10467190/168589371-552445bc-37a4-4cf6-8f8d-bc7e655126c1.png">

### Download student response form as Excel sheet
Right now, we just download the form data as Excel sheet (from the Google Sheet created from the form), can in principle try to access the sheet directly using an API

## Generate Sheet for faculty to provide preference for students who chose their class

## Run matchmaking algorithm


