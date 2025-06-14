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

library(tidyverse)

#sample table 1
table1
##in table 1, every observation is presented in rows, and the variables has it's own name in the column
###EXP: if measuring height, the height of an individual is an observation, and "height" is the variable. 

#sample table 2
table2
##in table 2, each observation has it's own row, including the country name, the year, the type (cases or population) and the count value, whereas the variable has it's own name in column (country, year, type, count)

#sample table 3
table3
##in table 3, we got a new variable name (column name) - rate. this is merged from the type of cases and population

#sample table 4
table4a
table4b
##in table 4, cases and population are represented in separate tables


#2. Compute the rate for table2, and table 4a + table4b. You will need to perform four operations:
  #a. Extract the number of TB cases per country per year.
table2_cases <- filter(table2, type == "cases") %>% rename(cases = count) %>% arrange(country, year)
table2_cases
  #b. Extract the matching population per country per year
table2_population <- filter(table2, type == "population") %>% rename(population = count) %>% arrange(country, year)
table2_population
  #c. Divide cases by population, and multiply by 10,000.
tb_division <- tibble(year = table2_cases$country,
                      country = table2_cases$year,
                      cases = table2_cases$cases,
                      population = table2_population$population) %>% mutate(cases_part2 = (cases / population) * 10000) %>% select(country, year, cases_part2)
tb_division
  #d. Store back in the appropriate place.
tb_division <- tb_division %>% mutate(type = "cases_part2") %>% rename(count = cases_part2)
tb_division

#for table 4:

table4N <- tibble(country = table4a$country,
                  `1999` = table4a[["1999"]] / table4b[["1999"]] * 10000,
                  `2000` = table4a[["2000"]] / table4b[["2000"]] * 10000)
table4N
#3. Re-create the plot showing change in cases over time using table2 instead of table1. What do you need to do first?

# SPREADING AND GATHERING
#starting to learn R part 2
