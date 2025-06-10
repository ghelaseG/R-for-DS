# TIDY DATA WITH TIDYR

# this chapter presents a consisten way to organise your data in R.

#this work pays in a long term

#the Tidy Data paper at https://www.jstatsoft.org/article/view/v059i10 will give you more underlying theory

# useful videos: https://www.youtube.com/watch?v=xrrWLKRfZWY&list=PLu6UwBFCnlEc7m2aK-AGfLLM-auJ5K3i5&ab_channel=StatisticsGlobe and https://www.youtube.com/watch?v=pLg-Bf_ppSU&ab_channel=DataWithinReach

library(tidyverse)

#the following shows the same data organised in 4 different ways
table1
table2
table3
table4a
table4b

#there are 3 rules which makes a dataset tidy:
# 1. each variable must have its own column
# 2. each observation must have its own row
# 3. each value must have its own cell

#view: https://ismayc.github.io/moderndiver-book/4-tidy.html

#these three rules are interrelated because it's impossible to only satisfy two of the three.

#in our example, only table1 is tidy.
table1 %>% 
  mutate(rate = cases / population * 10000)

table1 %>%
  count(year, wt = cases)

library(ggplot2)
ggplot(table1, aes(year, cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country))

# Exercises:

#1. Using prose, describe how the variables and observations are organised in each of the sample tables.

#2. Compute the rate for table2, and table 41 + tabl4b. You will need to perform four operations:
  #a. Extract the number of TB cases per country per year.
  #b. Extract the matching population per country per year.
  #c. Divide cases by population, and multiply by 10,000.
  #d. Store back in the appropriate place.

#3. Re-create the plot showing change in cases over time using table2 instead of table1. What do you need to do first?

# SPREADING AND GATHERING

#starting to learn R part 2
