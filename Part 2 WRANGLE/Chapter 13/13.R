#Dates and Times with lubridate

#many parts of the world use daylight saving time, so that some days have 23 hours and others have 25
#some minutes have 61 seconds because every now and then leap seconds are added because Earth's rotation is slowing down

#dates and times are hard because they have to reconcile two physical phenomena (the rotation of the Earth and its orbit around the sun)

library(tidyverse)
library(lubridate)
library(nycflights13)

#Creating date/times

#if you need to sore times, use hms package 

today()
now()

#we can create a date-time from:
##string
##individual date-time components
##an existing date-time object

#From Strings

ymd("2017-01-31")

mdy("January 31st, 2017")

dmy("31-Jan-2017")

ymd(20170131)

ymd_hms("2017-01=31 20:11:59")

mdy_hm("01/31/2017 08:01")

ymd(20170131, tz = "UTC")

#From Individual Components

flights %>% 
  select(year, month, day, hour, minute)

#to create date or date-time use make_date() or make_datetime()

flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(
    departure = make_datetime(year, month, day, hour, minute)
  )

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt %>% view()

#using this data we can visualise the distribution of departure times across the year:

flights_dt %>% 
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 86400) #86400 seconds in a day

#or within a single day

flights_dt %>% 
  filter(dep_time < ymd(20130102)) %>% 
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 600) #600 s = 10 minutes

#Note! - when using date-time 1 means 1 second, and for dates, 1 means 1 day

#From Other Types

as_datetime(today())

as_date(now())

#if the offset is in seconds, use as_datetime(), if in days use as_date()

as_datetime(60 * 60 * 10)

as_date(365 * 10 + 2)

#Exercises:

#1. What happens if you parse a string that contains invalid dates?

ymd(c("2010-10-10", "bananas"))

#Answer:

#You'll get a warning message:"1 failed to parse" NA

#2. What does the tzone argument to today() do? Why is it important?

#Answer:

#?today - #a character vector specifying which time zone you would like the current time in. tzone defaults to your computer's system timezone. You can retrieve the current time in the Universal Coordinated Time (UTC) with now("UTC").

#3. Use the appropriate lubridate function to parse each of the following dates:

d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" #Dec 30, 2014

#Answer:

