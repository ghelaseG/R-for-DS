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


# Filter Rows with filter()

#filter() allows you to subset observations based on their values
#first argument is the name of the dataframe
#2nd and 3rd are the expressions that filter the data frame

#1st example is to select all flights on January 1st:

filter(flights, month == 1, day == 1)

jan1 <- filter(flights, month == 1, day == 1)


#if you want to save the results and print them, put them between parantheses:

(dec25 <- filter(flights, month == 12, day == 24))


#Comparisons

#using = instead of ==
filter(flights, month = 1)

#another error we can encounter is when using ==: floating-point numbers

sqrt(2) ^ 2 == 2
#False

1/49 * 49 == 1
#False

#this happens because we see an approximation
#instead of == we can use near():
near(sqrt(2) ^ 2, 2)
near(1 / 49 * 49, 1)


#Logical Operators

#finding the flights departed in November or December:

filter(flights, month == 11 | month == 12)

#another way to write this will be x %in% y. This will select every row where x is one of the values in y, for exp:

nov_dec <- filter(flights, month %in% c(11, 12))
nov_dec

#we can simplify complicated subsetting by using De Morgan's law:

# !(x & y) is the same as !x | !y 
# !(x | y) is the same as !x & !y

#for example, to find flights that weren't delayed  ( either on arrival or departure ) by more than 2 hours, we could use:

filter(flights, !(arr_delay > 120 | dep_delay > 120))
  #or
filter(flights, arr_delay <= 120, dep_delay <= 120)


