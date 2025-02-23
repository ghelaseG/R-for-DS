# CHAPTER 6

# WORKFLOW: PROJECTS

#there is a great pair of shortcuts that will work together to make sure you've captured the important parts of your code in the editor:

#Press Cmd/Ctrl-Shift-F10 to restart R Studio.
#Press Cmd/Ctrl-Shift-S to rerun the current script.


#Where does your analysis live?

#print this out in R by running getwd():

getwd()
#or you can see it at the top of the console.
#you can set the working directory from within R:

setwd("/path/to/my/CoolProject")


#RStudio Projects

#R experts keep all the files associated with a project together - input data, R scripts, analytical results, figures.

# Summary:

# create an RStudio project for each data analysis project
# keep data files there;
# keep scripts there;
# save your outputs (plots and cleaned data) there;
# only ever use relative paths, not absolute paths.
