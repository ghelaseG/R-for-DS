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



# Select columns with select()

#select columns by name
select(flights, year, month, day)

#select all columns between year and day (inclusive)
select(flights, year:day)

#select all columns except those from year to day (inclusive)
select(flights, -(year:day))

#there are a number of helper functions tou can use within select():

start_with("abc") #matches name that begin with "abc"
ends_with("xyz")
contains("ijk")
matches("(.)\\1") #selects variables that match a regular expression. This one matches any variables that contain repeated characters.
num_range("x", 1:3) #matches x1, x2, x3

#or we can type: ?select

#we can also use rename to change the column name(variable)

rename(flights, tail_num = tailnum)

#if you want to move a handful of variables to the start of the data frame, we can use the helper everything():

select(flights, time_hour, air_time, everything())


#Exercises:

#1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.

#Answer:

select(flights, dep_time)
select(flights, dep_delay)
select(flights, arr_time)
select(flights, arr_delay)
View(flights)

select(flights, dep_time, dep_delay, arr_time, arr_delay)

select(flights, dep_delay:arr_time)
select(flights, dep_time:arr_delay, -(sched_dep_time), -(sched_arr_time))

#2. What happens if you include the name of a variable multiple times in a select() call?

#Answer:

select(flights, dep_time, dep_time, dep_time)
#nothing, it's still printing that

#3. What does the one_of() function do? Why might it be helpful in conjunction with this vector?

vars <- c("year", "month", "day", "dep_delay", "arr_delay")

#Answer:

#let's first find out about one_of() function. I run in the terminal ?one_of, but with not much explanation, after some research, I saw that this belongs to our package dplyr
#then I run in the terminal, ?dplyr::one_of, and found the following:
#"one_of() is superseded in favour of the more precise any_of() and all_of() selectors."

#after reading about all_of() function:

flights %>% select(one_of(vars))
#we can use it to check if our database got those variables.

#4. Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?

select(flights, contains("TIME"))

#Answer:

#it does actually suprise me
#some database engines have case insensitive column names
#to change that default:

select(flights, contains("TIME", ignore.case = FALSE))



#Add New Variables with mutate()

#mutate basically adds more columns at the end of the dataset

#let's create a new column

flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time
                      )
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60)

#we can then refer to columns that we've created:

mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours)

#we can only keep the new variables with transmute():

transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours)



#Useful Creation Functions

#Arithmetic operators +, -, *, /, ^ => x / sum(x), y - mean(y)

#Modular arithmetic ( %/% - integer division and %% - remainder)
# x == y * (x %/% y) + (x %% y)
#this is useful because it allows us to rbeak integers into pieces
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
          )

#Logs: log(), log2(), log10()
#good note, log2() can be used if we want to interpret a scale, let's say a difference of 1 corresponds to doubling, and a difference of -1 corresponds to halving.

#Offsets: lead() and lag()
#this allows you to compute running differences or find when values change (x != lag(x))
(x <- 1:10)
lag(x)
lead(x)

#Cumulative and rolling aggregates
#R provide us with cumsum(), cumprod(), cummin(), cummax()
#dplyr provides cummean()
#RcppRoll helps with rolling aggregates (terminal command: install.packages("RcppRoll"))

x
cumsum(x)
cummean(x)

#Logical comparisons: <, <=, >, >=, !=

#Ranking
#min_rank(), it does the most usual type of ranking for exp: first, second, third, fourth
#desc(x) to get the largest values from the smallest rank
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))
#there are other options, such as: row_number(), dense_rank(), percent_rank(), cume_dist(), ntile()
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)
x <- c(5, 1, 3, 2, 2, NA)
ntile(x, 4)

#Exercises:

#1. Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they're not really continuous numbers. Convert them to a more onvenient representation of number of minutes since midnight.

#Answer:

View(flights)

#we can use the formula from modular arithmetic: x == y * (x %/% y) + (x %% y)

transmute(flights,
          hour_departure = dep_time %/% 100,
          minute_departure = dep_time %% 100,
          hour_sched_dep_time = sched_dep_time %/% 100,
          minute_sched_dep_time = sched_dep_time %% 100)

#2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?

#Answer:

transmute(flights,
          air_time,
          difference = arr_time - dep_time)
#I expected to see a similar time, whereas the difference between arr_time and dep_time expected to be as near as air_time.
#all I see is, for example:
#air_time difference
#<dbl>      <int>
#  1      227        313
#2      227        317
#3      160        381
#4      183        460
#5      116        258
#6      150        186
#7      158        358
#8       53        152
#9      140        281

#I'll have to create a new column, using mutate:

flights_fixed <- select(flights,
                        arr_time,
                        dep_time,
                        )

mutate(flights_fixed,
       air_time_fixed = arr_time - dep_time
       )

#3. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?

#Answer:

select(flights, dep_time, sched_dep_time, dep_delay)

#it's pretty simple, because dep_delay is dep_time - sched_dep_time

#4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().

#Answer:

View(flights)
#trial
#flights_10 <- select(flights,
#                     arr_delay)
#flights_10
#x <- min_rank(flights_10)
#slice(x, 1:9)

#running in the terminal ?min_rank, or ?row_number or ?dense_rank we get:
#Integer ranking functions
#Description
#Three ranking functions inspired by SQL2003. They differ primarily in how they handle ties:
  
#  row_number() gives every input a unique rank, so that c(10, 20, 20, 30) would get ranks c(1, 2, 3, 4). It's equivalent to rank(ties.method = "first").

#min_rank() gives every tie the same (smallest) value so that c(10, 20, 20, 30) gets ranks c(1, 2, 2, 4). It's the way that ranks are usually computed in sports and is equivalent to rank(ties.method = "min").

#dense_rank() works like min_rank(), but doesn't leave any gaps, so that c(10, 20, 20, 30) gets ranks c(1, 2, 2, 3).

#flights %>% filter(min_rank(dep_delay) == 9)

#y <- flights$dep_delay
#y <- order(y)
#y

#flights_ranked <- select(flights,
#                        dep_delay,
#                        )
#flights_ranked

#x <- dense_rank(flights$dep_delay)
#x <- sort(x)
#x

#dd <- transform(flights_ranked,
#            ranked_delays = x)
#dd
#slice_head(dd)

#dd %>% slice_head(n = 10)

#xyz <- flights %>% group_by(dep_time) %>% filter(min_rank(pick(dep_delay, arr_delay)) == 10)
#View(xyz)

#sort(flights$dep_delay, method = "quick", index.return = TRUE)

#gg <- head(xyz2, 10)
#View(gg)

#everything in comments, were just some of my trials

#I'll handle ties using row_number ranking function.

library(dplyr)
xyz2 <- flights %>% group_by(dep_delay) %>% transmute(rank_id = row_number())
answerrrr <- arrange(xyz2, dep_delay, rank_id, .by_group = TRUE)
View(answerrrr)
gg_answerr <- head(answerrrr, 10)
View(gg_answerr)
#View(answerrrr, 10)
#print(answerrrr, n = 10)
#sort(xyz2, method = "quick", index.return = TRUE)
#View(xyz2)
#order(xyz2,"rank_id", )

#5. What does 1:3 + 1:10 return? Why?

#Answer:

1:3 + 1:10

#Returns:

#4  6  8  7  9 11 10 12
#Warning message:
#  In 1:3 + 3:10 :
#  longer object length is not a multiple of shorter object length

#Because this is equal to:
c(1 + 1, 2 +2, 3+3, 1 +4, 2+5, 3+6, 1+7, 2+8, 3+9, 1+10) #and the error occurs because there's a difference in length

#6. What trigonometric functions does R provide?

#Answer:

#Reference: ?Trig

#These functions give the obvious trigonometric functions. They respectively compute the cosine, sine, tangent, arc-cosine, arc-sine, arc-tangent, and the two-argument arc-tangent.

#cospi(x), sinpi(x), and tanpi(x), compute cos(pi*x), sin(pi*x), and tan(pi*x).


#let's practice a bit using trigonometric functions:

seq(17)
seq(1, 9, by = pi)
seq(1, 7, by = 3)
seq(1.575, 5.125, by = 0.05)

sin(pi)
pi
cos(pi)
tan(pi)

base::pi # we can use this in case the variable 'pi' is changed.

x <- seq(-2, 9, by = 0.5)
x
sin(pi * x)
sinpi(x)

#arc sine, arc cosine and arc tangent

x<- seq(-1, 1, by=0.5)
asin(x)
acos(x)
atan(x)

x <- seq(-3, 7, by = 1/8)
tx <- cbind(x, cos(pi * x), cospi(x), sin(pi*x), sinpi(x), tan(pi*x), tanpi(x), deparse.level = 2)
head(tx)
tx[ (x %% 1) %in% c(0, 0.5) ,]
op <- options(digits = 4, width = 90)
options(op)

cbind(1, 1:7)
rbind(1, 1:7)

x <- -1:12
x

x %% -100
x %/% 5

options(digits = 22)
pi

old.o <- options(editor = "nedit")
old.o

getOption("width") == options()$width 






# GROUPED SUMMARIES WITH summarize()


summarize(flights, delay = mean(dep_delay, na.rm = TRUE))

#summarize is useful if we pair it with group_by(), this helps to analyse individual groups from a dataset, as for exp:

by_day <- group_by(flights, year, month, day)
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))




# COMBINING MULTIPLE OPERATIONS WITH THE PIPE

#if we want to explore the relationship between the distance and average delay for each location:

by_dest <- group_by(flights, dest)
delay <- summarize(by_dest, 
                   count = n(), 
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
                   )
delay <- filter(delay, count > 20, dest != "HNL")
View(delay)

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

#we can prepare this data in 3 steps:
#1. group flights by destination
#2. summarize to compute distance, average delay, and number of flights
#3. filter to remove noisy points and Honolulu airport, which is almost twice as far away as the next closest airport

#we can do this another way, using pipe: %>%:

delays <- flights %>% group_by(dest) %>% summarize(count = n(),
                                                   dist = mean(distance, na.rm = TRUE),
                                                   delay = mean(arr_delay, na.rm = TRUE)
                                                   ) %>% filter(count > 20, dest != "HNL")
View(delays)

#a good way to pronounce %>% when reading code is "then".

#for example:
#x %>% f(y) turns into f(x, y)
#x %>% f(y) %>% g(z) turns into g(f(x, y), z)




# MISSING VALUES

#let's see what happens if we don't set na.rm

flights %>% group_by(year, month, day) %>% summarize(mean = mean(dep_delay))

#we get a lot of NA's (missing values) because if we have any missing value in the input the output will be a missing value.

flights %>% group_by(year, month, day) %>% summarize(mean = mean(dep_delay, na.rm = TRUE))

#we can also remove the cancelled flights (the missing values), saving the dataset to reuse it:

library(dplyr)
not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% group_by(year, month, day) %>% summarize(mean = mean(dep_delay))




# COUNTS

#it is always good to include a count (n()) or a count of nonmissing values (sum(!is.na(x))),
#in this way we make sure our conclusions are based on big amounts of data.

#let's see the planes that have the highest average delays
delays <- not_cancelled %>% group_by(tailnum) %>% summarize(delay = mean(arr_delay))
View(delays) #this shows as that there are flights with an average of 3 hours delay, but wait until we check the number of flights

#let's also plot this
ggplot(data = delays, mapping = aes(x = delay)) + geom_freqpoly(binwidth = 10)

#to see more in detail what is happening, we can get more insight if we check the number of flights versus the average delay
delays <- not_cancelled %>% group_by(tailnum) %>% summarize( delay = mean(arr_delay, na.rm = TRUE), n = n())
View(delays)

ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

# we can filter out the groups with the smallest numbers of observations, so you can see more of the pattern and less of the extreme variation in the smallest groups
#we can integrate dplyr with ggplot2

delays %>% filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)


#we can try to see this pattern for a different dataset, average performance of batter (ba) in baseball, related to the number of times they're at bat (ab).
#for example:
#1. the variation in our aggregate decreases as we get more data points
#2. there's a positive correlation between skill (ba) and opportunities to hit the ball (ab), this can possibly be as teams control who gets to play, and obviously they'll pick their best players.

#convert to a tibble so it prints nicely
batting <- as_tibble(Lahman::Batting)

batters <- batting %>%
  group_by(playerID) %>%
  summarize(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>%
  filter(ab >100) %>%
  ggplot(mapping = aes(x =ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)

#if we just use desc(ba) we get the people with the best batting average that were lucky, not skilled.
#noun: skill : the ability to do something well.

batters %>%
  arrange(desc(ba))



#Exp:
m <- matrix(rnorm(50), ncol = 5)
colnames(m) <- c("a", "b", "c", "d", "e")
df <- as_tibble(m)
df

#Note!
#if you want to understand more about tibble, check out this video: https://www.youtube.com/watch?v=og-7bG2i9TU&ab_channel=RiffomonasProject




# USEFUL SUMMARY FUNCTIONS

#just using mean, counts and sum can get you a long way, but there are others useful functions:


## Measures of location

#we can use median(x) too
#the mean is the sum divided by the length; whereas median is a value where 50% of x is above it, and the other is below it.

#we can use aggregation with logical subsetting

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    #average delay:
    avg_delay1 = mean(arr_delay),
    #avearage positive delay:
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )


## Measures of spread sd(x), IQR(x), mad(x)

#sd(x) = mean squared deviation, or standard deviation is the standard measure of spread
#IQR(x) = the interquartile range
#mad(x) = robust equivalents - those 2 are useful if you have outliers

#for example, why is distance to some destinations more variable than to others?

not_cancelled %>%
  group_by(dest) %>%
  summarize(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))


## Measures of rank min(x), quantile(x, 0.25), max(x)

#quantiles = are a generalization of the median, for exp: quantile(x, 0.25) will find a value of x that is greater than 25% of the values, and less than the remaining 75%

# when do the first and last flights leave each day?

not_cancelled %>% 
  group_by(year, month, day) %>%
  summarize(
    first = min(dep_time),
    last = max(dep_time)
  )


## Measures of position first(x), nth(x, 2), last(x)

#these work similarly to x[1], x[2], and x[length(x)]

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    first_dep = first(dep_time),
    last_dep = last(dep_time)
  )

#these functions are complementary to filtering on ranks, because filtering gives you all variables, with each observation

not_cancelled %>%
  group_by(year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))


## Counts

#we know already the use of n() and sum(!is.na(x)) - counting the number of non-missing values
#but we can also count the distinct(unique) values, with n_distinct(x)

not_cancelled %>%
  group_by(dest) %>%
  summarize(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

#you can also use count
not_cancelled %>%
  count(dest)

#you can provide a weight variable to see the total number of miles a plane flew
not_cancelled %>%
  count(tailnum, wt = distance)


## Counts and proportions of logical values sum(x > 10), mean(y == 0)

#when used with numeric functions, TRUE is converted to 1 and FALSE is converted to 0
#sum(x) gives the number of TRUEs in x and mean(x) gives to proportion:

#How many flights left before 5am? (these usually indicate delayed flights from the previous day)
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(n_early = sum(dep_time < 500))

#What proportion of fligths are delayed by more than an hour?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(hour_perc = mean(arr_delay > 60))



# GROUPING BY MULTIPLE VARIABLES

daily <- group_by(flights, year, month, day)
(per_day <- summarize(daily, flights = n()))

(per_month <- summarize(per_day, flights = sum(flights)))

(per_year <- summarize(per_month, flights = sum(flights)))




#UNGROUPING

#if you need to remove grouping, do the following:

daily %>%
  ungroup() %>%
  summarize(flights = n())



#Exercises:

#1. Brainstorm at least five different ways to assess the typical delay characteristics of a group of flights. Consider the following scenarios:

# - a flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
# - a flight is always 10 minutes late
# - a flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
# - 99% of the time a flight is on time. 1% of the time it's 2 hours late

#Which is more important: arrival delay or departure delay?

#Answer:

# let's first transform our data, removing any cancelled flights
not_cancelled <- flights %>% filter(!is.na(arr_delay))
View(not_cancelled)

#a.
x <- not_cancelled %>%
  group_by(flight, tailnum) %>%
  summarize(
    #15 minutes early 50% of the time
    early_15min = mean(arr_delay == -15, na.rm = TRUE),
    #15 minutes late 50% of the time
    late_15min = mean(arr_delay == 15, na.rm = TRUE), n()) %>% filter(early_15min == .5, late_15min == .5)

View(x)

#b.
#not_cancelled <- flights %>% filter(!is.na(arr_delay))
#late_10Min <- not_cancelled$arr_delay == 10
#transform(not_cancelled, late_10Min)

#view(late_10Min)

not_cancelled <- select(flights, tailnum, arr_delay) %>% group_by(tailnum) %>% filter(!is.na(arr_delay), all(arr_delay == 10))
View(not_cancelled)

#y <- mutate(not_cancelled, )
#View(y)

#the only flight, is N801AW


#y <- not_cancelled %>% 
#  group_by(flight, tailnum) %>%
#  mutate(
#    #always 10 minutes late
#    late_10min = arr_delay == 10) %>% as_tibble() %>% filter(late_10min == 1)
View(flights)
#View(y)

#c.
not_cancelled <- flights %>% filter(!is.na(arr_delay))

#let's check if we got the value 30 in our dataframe
flights[flights$arr_delay %in% c(30, -30), ]

z <- flights %>%
  group_by(flight) %>%
  summarize(
    #30 minutes early 50% of the time
    early_30min = mean(arr_delay == -30, na.rm = TRUE),
    #30 minutes late 50% of the time
    late_30min = mean(arr_delay == 30, na.rm = TRUE)
  ) %>% 
  filter(early_30min == .5 | late_30min == .5)

View(z)

#d. 99% of the time a flight is on time. 1% of the time it's 2 hours late
# not_cancelled <- flights %>% filter(!is.na(arr_delay))
# xyz <- not_cancelled %>%
#   group_by(tailnum, arr_delay) %>%
#   summarise(
#     #99% of the time a flight is on time
#     on_time_99 = mean(arr_delay == 0),
#     
#   ) %>% filter(on_time_99 == 0.99)
# View(xyz)

#let's try and transform the data

library(dplyr)
library(tidyr)

not_cancelled <- flights %>% filter(!is.na(arr_delay))

xyz1 <- not_cancelled %>%
  group_by(tailnum) %>%
  mutate(rn = row_number()) %>%
  pivot_wider(id_cols = rn, names_from = tailnum, values_from = arr_delay) %>%
  select(-rn)

View(xyz1)

dim(xyz1) #2512 rows and 4044 columns
#after deleting all the N/A values, we get to 544 rows and 4037 columns
#as.integer(xyz1)

numdata <- xyz1[sapply(xyz1, is.numeric)]
View(numdata)
list123 <- lapply(numdata, mean, na.rm = TRUE) #view it as a list
View(list123)

typeof(list123)

zzz <- data.frame(t(sapply(list123,c)))
View(zzz)

#99% of the time a flight is on time

#Here's how it works:
## I first transformed the data and get rid of the empty values. keeping only the tailnum of the flight with the arr_delay
##simply because if the flight has the value -x (something) it means that has arrived earlier etc...
## Following I transformed the data into a list to get the mean of each column (tailnum), I then tranformed it back to a dataframe to check which airplane has got a value between -1 and 1,
##I chose those values (1-, 1) because if the average is 0 (that means the airplane is on time), but it can not be very accurate so I decided to go for 0.xxxxx or -0.yyyyyy.

answer99 <- colnames(zzz)[apply(zzz, 2, function(x) any(x >= -1 & x <= 1))]
print(answer99)



#do.call(rbind.data.frame, list123)
# 
# return_cols <- function(zzz, i) {
#   zzz %>%
#     slice(i) %>%
#     select(where(~. <= 1)) %>%
#     names
# }

#  filter(!is.na(arr_delay), all(arr_delay == 0))    

#1% of the time a flight is delayed by 2 hours

answer1 <- colnames(zzz)[apply(zzz, 2, function(x) any(x >= 119 & x <= 121))]
View(answer1)
View(zzz$N670US)

#Which is more important, arrival delay or departure delay?
#I believe the most important is arrival delay to use in our exercise.

#2. Come up with another approach that will give you the same output as not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) (without using count())
View(not_cancelled)
not_cancelled %>% count(dest)

not_cancelled %>% count(tailnum, wt = distance)

#Answer:
#writing in terminal ?dplyr we get the following answer using the documentation:
not_cancelled %>% group_by(dest) %>% summarize(n = n())
#and
not_cancelled %>% group_by(tailnum) %>% summarize(n = sum(wt = distance))

#3. Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay)) is slightly suboptimal. Why? Whohc is the most important column?

cancelled_flights <- flights %>% filter(is.na(dep_delay) | is.na(arr_delay))
View(cancelled_flights)

#Answer:

#the most important one is dep_delay in terms of cancelled flights.
#even if we have values for arrival delay, if departure delay is not registered, then definetely that flight is been cancelled.

#4. Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?

#Answer:
#the number of cancelled flights per day
cancelled_flights <- flights %>% filter(is.na(dep_delay))
xyzzz <- cancelled_flights %>% group_by(month, day) %>%
  summarize(flights_cancelled = sum(is.na(dep_delay)))
View(xyzzz)
xyzzz1 <- not_cancelled %>% group_by(month, day) %>% summarize(average_delay = mean(dep_delay)) %>% as.integer(xyzzz1$average_delay)
View(xyzzz1)

typeof(xyzzz1)

#we can see a pattern by checking the graph
ggplot(xyzzz, mapping = aes(x = day, y = flights_cancelled)) +
  geom_point(mapping = aes(color = flights_cancelled)) +
  geom_smooth(se = FALSE)

ggplot(xyzzz1, mapping = aes(x = day, y = average_delay)) +
  geom_point(mapping = aes(color = average_delay)) +
  geom_smooth(se = FALSE)

# although the average delay max value is 80 and the number of cancellation in a day is 400, using geom smooth we can kind of see a similar pattern

#5. Which carrier has the worst delays? Challenge: can you disentangle the effect of bad airports versus bad carriers? Why/why not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarize(n())).

#Answer:

View(flights)
xcv <- flights %>% count(carrier, wt = dep_delay)
View(xcv)
filter(airlines, carrier == "EV")

#the carrier with the worst delays is EV (the IATA designator for Expressjet Airlines)



#Challenge:

flights %>% group_by(carrier, dest) %>% summarize(n())

View(flights)

challenge_data <- flights %>% filter(!is.na(arr_delay)) %>% select(carrier, dep_delay, air_time, distance, hour, minute, dest, arr_delay) %>% view

#let's say that we name a bad airport as when there are too many delays. Delays can be made because of the airplane, but also because of the airport
#I'll first group the destination (airport)
challenge_data %>% group_by(dest) %>% 
  summarize(
    'Average total delays' = mean(arr_delay)
    ) %>% view 
filter(airports, faa == 'CAE')
#here we get CAE - Columbia Metropolitan aiport as the one with the highest delays in average

#In the second group I'll check the speed for each airplane in average
challenge_data_2 <- challenge_data %>% 
  mutate(speed_m_per_h = (distance / air_time) * 60) %>% group_by(carrier) %>%
  summarize(
    avg_spd = mean(speed_m_per_h),
    "Average mach" = avg_spd * 0.00130332
  ) %>% view
filter(airlines, carrier == 'HA')
#the fastest airplanes are from the company Hawaiian Airlines Inc.


#trial
challenge_data %>% mutate(spd_avg = distance/air_time)
challenge_data %>% group_by(carrier) %>%
  summarize(
    'Speed average' = mean(distance/time)
  ) %>% view
View(challenge_data)  
#i converted from miles per minute to miles per hour
challenge_data %>% mutate(speed_m_per_h = (distance / air_time) * 60) %>% view  

#Answer:
#at first I said that I can not disentangle the effect of bad airports versus bad carriers,
#but after doing some calculations (and more can be done for sure, but I'll pass for the moment),
#you can definetely disentangle using some calculations.

library(nycflights13)
data()
airports
filter(airports, faa == "CAE")
data("flights")
View(flights)
View(airports)
#View(airlines)


#6. For each plane, count the number of f,ights before the first delay of greater than 1 hour.
not_cancelled$flight
View(not_cancelled)

#Answer
not_cancelled %>% group_by(tailnum) %>% tally(arr_delay < 60) %>% view


#7. What does the sort argument to count() do? When might you use it?

#Answer:
##"the sort argument: If TRUE, will show the largest groups at the top."

#here's an example:

not_cancelled %>% group_by(tailnum) %>% count(arr_delay < 60, sort = TRUE) %>% view





#GROUPED MUTATES ( AND FILTERS )
#grouping can be useful with mutate and filter(known as window functions), having similar power using summarize

View(flights_sml)
#find the worst members of each group
flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10) %>% view

#groups bigger than a threshold
popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n() > 365) %>% view

#standardize to compute per group metrics
popular_dests %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay) %>% view

#Exercises

#1. Refer back to the table of useful mutate and filtering functions. Describe how each operation changes when you combine it with grouping.

#Answer:

#let's take the first example, we cut the group_by, and we run the code
#we can see that the code is not so complex, giving us some random values
flights_sml %>%
  filter(rank(desc(arr_delay)) < 10) %>% view

#in the second example, if we don't use the group by, our table looks exactly the same, and the same goes for the last example.
View(flights)
popular_dests <- flights %>%
  filter(n() > 365) %>% view

gg <- flights %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay) 
View(gg)


#2. Which plane (tailnum) has the worst on-time record?

#Answer:
not_cancelled <- flights %>% filter(!is.na(arr_delay)) %>% view

not_cancelled %>%
  group_by(tailnum) %>%
  tally(arr_delay) %>% arrange(desc(n)) %>% view

#those 2 are giving the same output
not_cancelled %>% filter(tailnum == "N15910") %>% view
not_cancelled[not_cancelled$tailnum %in% c("N15910"), ] 

#the answer is tailnum N15910

#3. What time of day should you fly if you want to avoid delays as much as possible?

#Answer:

View(not_cancelled)
not_cancelled %>% filter(dep_delay <= 0) %>% select(year:dep_delay) %>% view
not_cancelled %>% group_by(dep_time, sched_dep_time) %>% tally(dep_delay <= 0) %>% arrange(desc(n)) %>% view

#the best time to fly if you want to avoid delays, based on the number of flights that have not been delayed at all, is at 6 am.

#4. For each destination, compute the total minutes of delay. For each flight, compute the proportion of the total delay for its destination.

#Answer:

#total mintes of delay

View(not_cancelled)
#not_cancelled %>% group_by(dest) %>% count(arr_delay) %>% view #here we can see how many times it's been delayed or arrived earlier
#those 2 following block of code are doing the same thing
not_cancelled %>% group_by(dest) %>% tally(arr_delay) %>% view
not_cancelled %>% count(dest, wt = arr_delay) %>% arrange(desc(n))%>%view
#ATL or Hartsfield Jackson Atlanta Intl - is got the most delays in total, and SNA or John Wayne Arpt Orange Co got the earliest arrivals in total.
View(airports)
filter(airports, faa == "ATL")
filter(airports, faa == "SNA")

#proportion of total delay for each flight

not_cancelled %>% group_by(flight) %>% tally(arr_delay + dep_delay) %>% view
#flight 415 got a total delay of 26675 minutes.
#flight 183 got a total of early arrival of -7052 minutes.

#5. Delays are typically temporally correlated: even once the problem that caused the initial delay has been resolved, later flights are delayed to allow earlier flights to leave. Using lag() explores how the delay of a flight is related to the delay of the immediately preceding flight.

#Answer:

# #using ?lag in the terminal, we get: "Find the "previous" (lag()) or "next" (lead()) values in a vector. Useful for comparing values behind of or ahead of the current values."

#failed trial:
# #let's use only the flight number 415, the one with the highest delays.
# 
# flight_415 <- not_cancelled %>% group_by() filter(flight == 415)
# View(flight_415)

not_cancelled %>%
  mutate(lagged_delay = lag(dep_delay))%>%
  select(sched_dep_time, dep_delay, dep_time, lagged_delay) %>% view

#6. Look at each destination. Can you find flights that are suspiciously fast? (That is, flights that represent a potential data entry error.) Compute the air time of a flight relative to the shortest flight to that destination. Which flights were most delayed in the air?

#Answer:

not_cancelled %>% group_by(dest) %>% view
#let's first chech the speed

not_cancelled %>% 
  group_by(dest) %>%
  mutate(speed = 60 * (distance / air_time)) %>%
  filter(air_time > 70, distance < 100) %>%
  select(flight, origin, dest,air_time, distance, speed) %>% arrange(distance) %>% view

#one of the flight is 1860, having a speed of 76 mph, for a distance of 96 miles, having an average speed of 136mph

not_cancelled %>% group_by(flight == 1860) %>%
  filter(flight == 1860) %>%
  mutate(average_speed = mean(60 * (distance / air_time))) %>% view
