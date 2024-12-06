#CHAPTER 3

#DATA TRANSFORMATION WITH DPLYR

library(nycflights13)
library(tidyverse)

#to use the base version of this functions, you can use: stats::filter() and stats::lag()

# nycflights13

#this data comes from the US Bureau of Transportation Statistics
nycflights13::flights

View(flights)

#int stands for integers
#dbl stands for doubles, or real numbers
#chr stands for character vectors, or strings
#dttm stands for date-times (a date + a time)

# other dataset that we can possibly encounter in the future:

#lgl stands for logical, vectors that contain only TRUE or FALSE
#fctr stands for factors, which R uses to represent categorical variables with fixed possible values
#date stands for dates.


#dplyr Basics

#the 5 key functions to solve data-manipulation challenges:

# - filter() : pick observations by their values
# - arrange() : reorder the rows
# - select() : pick variables by their names
# - mutate() : create new variables with functions of existing variables
# - summarize() : collapse many values down to a single summary

#those can be used in conjuction with group_by() : used to work only on a small part(group) of the dataset

