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

mdy(d1)
ymd(d2)
dmy(d3)
mdy(d4)
mdy(d5)


#Date-Time Components

#Getting Components

datetime <- ymd_hms("2016-07-08 12:34:56")

year(datetime)

month(datetime)

mday(datetime) #day of the month

yday(datetime) # day of the year

wday(datetime) #day of the week

#for month and wday you can set label = TRUE to return abbreviated name of the month or day of the week
#set abbr = FALSE to return the full name

month(datetime, label = TRUE)

wday(datetime, label = TRUE, abbr = FALSE)

#we can use wday to see that more flights depart during the week

flights_dt %>% 
  mutate(wday = wday(dep_time, label = TRUE)) %>% 
  ggplot(aes(x = wday)) +
  geom_bar()


#we can find an interesting pattern if we look at the average departure delay by minute within the hour
##flights leaving in minutes 20-30 and 50-60 have much lower delays than the rest of the hour

flights_dt %>% 
  mutate(minute = minute(dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  ) %>% 
  ggplot(aes(minute, avg_delay)) +
  geom_line()

#if we look at the scheduled departure time we don't see such a strong pattern:

sched_dep <- flights_dt %>% 
  mutate(minute = minute(sched_dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n())

ggplot(sched_dep, aes(minute, avg_delay)) +
  geom_line()

#much data collected by humans have a strong bias toward flights leaving at "nice" departure times
#INFO!! - be careful at this sort of pattern whenever you work with data that involves human judgment

ggplot(sched_dep, aes(minute, n)) +
  geom_line()

#Rounding

#if we want to plot individual components is best to round the date to a nearby unit of time.

flights_dt %>% 
  count(week = floor_date(dep_time, "week")) %>% 
  ggplot(aes(week, n)) +
  geom_line()

#Setting Components

(datetime <- ymd_hms("2016-07-08 12:34:56"))

year(datetime) <- 2025
datetime

month(datetime) <- 01
datetime

hour(datetime) <- hour(datetime) + 1
datetime

#update allows you to use multiple values at once

update(datetime, year = 2020, month = 2, mday = 2, hour = 2)

#if values are too big, they will roll over:

ymd("2015-02-01") %>% 
  update(mday = 30)

ymd("2015-02-01") %>% 
  update(hour = 400)

#we can use update() to show the distribution of flights across the course of the day

flights_dt %>% 
  mutate(dep_hour = update(dep_time, yday = 1)) %>% 
  ggplot(aes(dep_hour)) +
  geom_freqpoly(binwidth = 300)

#Exercises:

#1. How does the distribution of flight times within a day change over the course of the year?

#Answer:

flights_dt %>% 
  mutate(dep_hour = update(dep_time, yday = 365)) %>% 
  mutate(month = factor(month(dep_time))) %>% 
  ggplot(aes(dep_hour, colour = month)) +
  geom_freqpoly(binwidth = 3600)

#2. Compare dep_time, sched_dep_time, and dep_delay. Are they consistent? Explain your findings.

#Answer:

flights_dt %>% view()

flights_dt %>% 
  mutate(dep_time_adj = sched_dep_time + dep_delay * 60) %>% 
  filter(dep_time_adj != dep_time) %>% 
  select(dep_time_adj, dep_time, sched_dep_time, dep_delay) %>% 
  arrange(-dep_delay)
#as we can see, the departure is happening the following day

#3. Compare air_time with the duration between the departure and arrival. Explain your findings. (Hint: consider the location of the airport)

#Answer:

flights_dt %>% mutate(
  flight_time_in_minutes = as.numeric(arr_time - dep_time),
  air_time_in_minutes = air_time,
  diff = flight_time_in_minutes - air_time_in_minutes
) %>% 
  select(origin, dest, flight_time_in_minutes, air_time_in_minutes, diff) %>% 
  arrange(diff)

#we can see that only 10 entries were correct, out of 328053

#4. How does the average delay time change over the course of a day? Should you use dep_time or sched_dep_time? Why?

#Answer:

flights_dt %>% 
  mutate(sched_dep_in_hour = hour(sched_dep_time)) %>% 
  group_by(sched_dep_in_hour) %>% 
  summarise(dep_delay = mean(dep_delay)) %>% 
  ggplot(aes(y = dep_delay, x = sched_dep_in_hour)) +
  geom_point() +
  geom_smooth() +
  coord_flip()

#5. On what day of the week should you leave if you want to minimise the chance of a delay?

#Answer:

flights_dt %>% 
  mutate(day_of_week = wday(sched_dep_time)) %>% 
  group_by(day_of_week) %>% 
  summarise(
    dep_delay = mean(dep_delay, na.rm = TRUE),
    arr_delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  print(n = Inf)

flights_dt %>% 
  mutate(day_of_week = wday(dep_time, label = TRUE, abbr = FALSE)) %>% 
  group_by(day_of_week) %>% 
  summarise(avg_dep_delay = mean(dep_delay)) %>% 
  ggplot(aes(day_of_week, avg_dep_delay)) +
  geom_bar(stat = "identity")

#Saturday is the best day

flights_dt %>% 
  mutate(day_of_week = wday(dep_time, label = TRUE, abbr = FALSE)) %>% 
  group_by(day_of_week) %>% 
  summarise(avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>% 
  ggplot(aes(day_of_week, avg_arr_delay)) +
  geom_bar(stat = "identity")

#6. What makes the distribution of diamonds$carat and flights$sched_dep_time similar?

#Answer:

view(diamonds$carat)
view(flights$sched_dep_time)

ggplot(diamonds, aes(carat)) +
  geom_histogram()

ggplot(diamonds, aes(carat %% 1 * 100)) +
  geom_histogram(binwidth = 1)

#there are "nice" numbers registered by humans

ggplot(flights_dt, aes(minute(sched_dep_time))) +
  geom_histogram(binwidth = 1)

#7. Confirm my hypothesis that the early departures of flights in minutes 20-30 and 50-60 are caused by scheduled flights that leave early. Hint: create a binary variable that tells you whether or not a flight was delayed.

#Answer:

#our binary variable will be 1 for leaving early and 0 if it doesn't.

flights_dt %>% 
  mutate(minute_departure = minute(dep_time),
         early_departures = dep_delay < 0) %>% 
  group_by(minute_departure) %>% 
  summarise(
    early_departures = mean(early_departures, na.rm = TRUE),
    n = n()
  ) %>% 
  ggplot(aes(minute_departure, early_departures)) +
  geom_line()
