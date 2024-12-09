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



#Missing Values

#one of the feature of R that can make comparision tricky is missing values or NAs('not available')

NA > 5

10 == NA

NA + 10

NA / 2

#the most confusing result is:

NA == NA


#for exp, x is someones age (NA) and y is someone elses age (NA)

x <- NA
y <- NA
x == y #we don't know

#checking if a value is missing
is.na(x)

#filter() includes rows where the condition is TRUE, it excludes both FALSE and NA values. If you want to preserve missing values, ask for them explicitly:

df <- tibble(x = c(1, NA, 3))

filter(df, x >= 1)

filter(df, is.na(x) | x > 1)


# Exercises:

#1. Find all flights that:
  #a. Had an arrival delay of two or more hours
  #b. Flew to Houston(IAH or HOU)
  #c. Were operated by United, American, or Delta
  #d. Departed in summer (July, August, and September)
  #e. Arrived more than two hours late, but didn't leave late
  #f. Were delayed by at least an hour, but made up over 30 minutes in flight
  #g. Departed between midnight and 6 a.m. (inclusive)

#Answer

#a:
filter(flights, !(arr_delay < 120)) 
  #or
filter(flights, arr_delay >= 120)

#b:
#let's first see our data frame, to find our column called dest (IAH or HOU)
print.data.frame(flights)
View(flights)

flights[,"dest", drop = FALSE]
gg <- filter(flights, dest == "IAH" | dest == "HOU")
View(gg)

#c:
View(flights)
#let's identify the IATA column, which is under the name "carrier"
#we then need to identify the IATA for United (UA), American (AA) and Delta (DL)
#now we can filter the flights
gg <- filter(flights, carrier == "UA" | carrier == "AA" | carrier == "DL")
View(gg)

#d:
View(flights)
library(dplyr)
gg <- filter(flights, month %in% c(7, 8, 9))
View(gg)

#e:
View(flights)
gg <- filter(flights, arr_delay >= 120 & dep_delay <= 0)
View(gg)

#f:
View(flights)
gg <- filter(flights, dep_delay >= 60 & arr_delay >= 30)
View(gg)

#g:
#wrong:
gg <- filter(flights, dep_time < 2400 & dep_time <= 600)
View(gg) #wrong

#let's try something different, google print all the rows without duplicates in r, we find that "dplyr" library has got a distinct method, let's use it:
#Reference: https://dplyr.tidyverse.org/reference/distinct.html
all_rows <- distinct(flights, dep_time)
View(all_rows) #we get all the unique rows, but we can easily find a mistake, we find dep time 25, 26, ....etc

#so we can run to see the unique rows for other column that is related to this, which is sched_dep_time
all_rows_2 <- distinct(flights, sched_dep_time)
View(all_rows_2)
#by doing this, we can easily see that there is no written time such as 25, 48 etc (NA)
#this lead us to do the following, because of the messy data:
gg <- filter(flights, sched_dep_time <= 600 & dep_delay <= 0)
View(gg) #what we did here, we check for the unique rows from our table, and we can only see one departure at 01:06

#but there's so much more we can do with this exercise as our data is wrong, or misleading, probably after cleaning the data we can get an easier and straight result

#2. Another useful dplyr filtering helper is between(). What does it do? can you use it to simplify the code needed to answer the previous challenges?

#Answer:

#let's first find out about the function between, writing in the command line ?dplyr::between

#What does it do?: "This is a shortcut for x >= left & x <= right, implemented for local vectors and translated to the appropriate SQL for remote tables."

#we can use it for example, at our point (d) for exercise 1.

gg <- filter(flights, between(month, 7, 9))
View(gg)


#3. How many flights have a missing dep_time? What other variables are missing? What might these rows represent?

#Answer:

filter(flights, is.na(dep_time))
#we can see that we got 8245 NA rows

summary(flights)
#other variables having the same missing values are: dep_delay, arr_time, arr_delay, air_time

#this can mean cancelled flight or possibly not registered.


#4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? Can you figure out the general rule? (NA * 0 is a tricky counterexample!)

#Answer:

NA ^ 0 #that is because anything to the power of 0 is 1

NA | TRUE
#what if we do:
FALSE | TRUE
#or
TRUE | TRUE
#same answer

FALSE & NA
#let's try doing:
FALSE & TRUE
#or
FALSE & FALSE
#same answer

#the general rule:

NA | FALSE #NA
#let's see why:

FALSE | FALSE # FALSE
TRUE | FALSE # TRUE
#that's why is NA

TRUE & NA #NA

#let's try some examples:
TRUE & TRUE #TRUE
TRUE & FALSE #FALSE

#now let's try the counterexample (NA * 0)

NA * 0
#anything multiplied with 0 should be zero, but if we try
Inf * 0
#or minus infinite
-Inf * 0
#r represent undefined results with NA



#Arrange Rows with arrange()

gg <- arrange(flights, year, month, day)
View(gg)

#use desc to reorder by a column in descending order:

gg <- arrange(flights, desc(arr_delay))
View(gg)

#missing values are always sorted at the end:

df <- tibble(x = c(5, 2, NA))
arrange(df, x)

#or 

df <- tibble(x = c(5, 2, NA))
arrange(df, desc(x))


#Exercises:

#1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na())

#Answer:

arrange(flights, desc(is.na(dep_time)))

#2. Sort flights to find the most delayed flights. Find the flights that left earliest.

#Answer:

View(flights)
arrange(flights, desc(dep_delay))

#to find the flights that left earliest:

arrange(flights, dep_delay) #the ones with minus

#3. Sort flights to find the fastest flights.

#Answer:

gg <- arrange(flights, hour, minute)
View(gg)

#4. Which flights traveled the longest? Which traveled the shortest?

#Answer:

gg <- arrange(flights, distance)
View(gg)

#EWR traveled the shortest

gg <- arrange(flights, desc(distance))
View(gg)

#JFK traveled the longest