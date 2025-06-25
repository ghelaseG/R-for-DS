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
# table2 %>% count(year, wt = type == 'cases')
library(ggplot2)
table2_cases
# ggplot(table2_cases)
table2 %>% filter(type == "cases") %>% ggplot(aes(year, count)) + geom_line(aes(group = country), colour = "grey50") + geom_point(aes(color = country)) + scale_x_continuous(breaks = unique(table2$year)) + ylab("cases")

#two common problems:
##one variable might be spread across multiple columns.
##one observation might be scattered across multiple rows.

#to fix these prolems, you'll need the function gather() and spread()

# GATHERING

#one common problem, is the cikumn name are not names of variables, for exp table4a
table4a

#fixing the table, gathering those columns into a new pair of variables

tidy4a <- table4a %>% gather('1999', '2000', key = "year", value = "cases")

tidy4b <- table4b %>% gather('1999', '2000', key = "year", value = "population")

# to combine those 2 table, we can use dplyr::left_join()

left_join(tidy4a, tidy4b)

# SPREADING  

#spreading is the opposite of gathering, use this when an observation is scattered across multiple rows

# for table2 we can do the following:
spread(table2, key = type, value = count)

table2

# Exercises

#1. Why are gather() and spread() not perfectly symmetrical? Carefully consider the following example:

stocks <- tibble(
  year = c(2015, 2015, 2016, 2016),
  half = c(1,    2,     1,     2),
  return = c(1.88, 0.59, 0.92, 0.17))
stocks %>% 
  spread(year, return) %>%
  gather("year", "return", `2015`:`2016`)

#Hint: look at the variable types and think about column names
##Both spread() and gather() have a convert argument. What does it do?

# Answer:

## are not symmetrical, because the type of key for year becomes character.

## the convert argument will help change the key column type.

## ?gather: "convert - If TRUE will automatically run type.convert() on the key column. This is useful if the column types are actually numeric, integer, or logical."

#2. Why does this code fail?

table4a %>%
  gather(1999, 2000, key = "year", value = "cases")

#Answer:
#we need the quotation marks on the year

table4a %>%
  gather("1999", "2000", key = "year", value = "cases")


#3. Why does spreading this tibble fail? How could you add a new column to fix the problem?

table4a <- tribble(
  ~name,                ~key,           ~value,
  #---------------------/---------------/-----
  "Phillip Woods",       "age",          45,
  "Phillip Woods",       "height",       186,
  "Phillip Woods",       "age",          50,
  "Jessica Cordero",     "age",          37,
  "Jessica Cordero",     "height",       156
)
table4a

#4. Tidy this simple tibble. Do you need to spread or gather it? What are the variables?

preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",      NA,   10,
  "na",       20,   12
)

#Answer:
#need to gather gender

preg %>% gather(male, female, key="gender", value="number")


##Separating and Pull

#here we learn how to tidy table3 using separate() function

#for exp:
table3

#we can use separate for the rate column
table3 %>% separate(rate, into = c("cases", "population"))

#we could also rewrite this:
table3 %>% separate(rate, into = c("cases", "population"), sep = "/")

class(table3$rate)

#separate default column type is character, to convert this we can use:

table3 %>% separate(
  rate,
  into = c("cases", "population"),
  convert = TRUE
)

#another example:
table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

## UNITE

#unite is the inverse of separate(): combines multiple columns into single column

table5 %>% unite(new, century, year)

#to fix this we need to use sep

table5 %>% unite(new, century, year, sep = "")


#Exercises:

#1. What do the extra and fill arguments do in separate()? Experiment with the various options for the following two toy datasets:

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", 'three'))

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"))

#Answer:
#using in the terminal ?separate: we can see that:

##extra	 If sep is a character vector, this controls what happens when there are too many pieces. There are three valid options:
#"warn" (the default): emit a warning and drop extra values.
#"drop": drop any extra values without a warning.
#"merge": only splits at most length(into) times

#fill	
#If sep is a character vector, this controls what happens when there are not enough pieces. There are three valid options:
#"warn" (the default): emit a warning and fill from the right
#"right": fill with missing values on the right
#"left": fill with missing values on the left

#for the first example we use extra:
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", 'three'), extra = "merge")

#second exp, using fill:
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "right")


#2. Both unite() and separate() have a remove argument. What does it do? Why would you set it to FALSE?
#Answer: 
#remove	: If TRUE, remove input column from output data frame, if FALSE creates a new column.
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", 'three'), extra = "merge", remove = FALSE)

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "right",  remove = FALSE)

#3. Compare and contrast separate() and extract(). Why are there three variations of separation (by position, by separator, and with groups), but only one unite?
#Answer:
#extract function: "Extract a character column into multiple columns using regular expression groups"
#separate function: "Separate a character column into multiple columns with a regular expression or numeric locations"

#example:
tibble(x = c("G1", "G2", "G3", "G4")) %>%
  separate(x, c("variable", "into"), sep = c(1))

tibble(x = c("G_1", "G_2", "BB_1", "BB_2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z])_([0-9])")

tibble(variable = c("X", "X", "Y", "Y"), id = c(1,2,1,2)) %>%
  unite(x, variable, id, sep = "_")

## Missing values

#there are 2 types of missing values: explicit and implicit, these differ from one another, as the first one is represented by NA and the other as missing data.

#for example:

stocks <- tibble(
  year    = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr     = c(   1,    2,    3,    4,    2,    3,    4),
  return  = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks

stocks %>% spread(year, return)

stocks %>% spread(year, return) %>%
  gather(year, return, '2015':'2016', na.rm = TRUE)

#using complete
stocks %>% complete(year, qtr)

#if you want the missing value to be carried forward:
treatment <- tribble(
  ~ person,            ~ treatment,  ~ response,
  "Derrick Whitmore",  1,            7,
  NA,                  2,            10,
  NA,                  3,            9,
  "Katherine Burke",   1,            4
)

#we can use fill() - this operation carry forward the last observation.

treatment %>%
  fill(person)

#Exercises:

#1. Compare and contrast the fill arguments to spread() and complete().

#Answer:

?spread
# fill argument: If set, missing values will be replaced with this value. Note that there are two types of missingness in the input: explicit missing values (i.e. NA), and implicit missings, rows that simply aren't present. Both types of missing value will be replaced by fill.
?complete
# fill argument: A named list that for each variable supplies a single value to use instead of NA for missing combinations.
df <- tibble(
  group = c(1:2, 1, 2),
  item_id = c(1:2, 2, 3),
  item_name = c("a", "a", "b", "b"),
  value1 = c(1, NA, 3, 4),
  value2 = 4:7
)
df %>%
  complete(
    group,
    nesting(item_id, item_name),
    fill = list(value1 = 0, value2 = 99)
  )

#2. What does the direction argument to fill() do?

#Answer:

?fill
#.direction: Direction in which to fill missing values. Currently either "down" (the default), "up", "downup" (i.e. first down and then up) or "updown" (first up and then down).

tidy_pets <- tibble::tribble(
  ~rank, ~pet_type, ~breed,
  1L,        NA,    "Boston Terrier",
  2L,        NA,    "Retrievers (Labrador)",
  3L,        NA,    "Retrievers (Golden)",
  4L,        NA,    "French Bulldogs",
  5L,        NA,    "Bulldogs",
  6L,     "Dog",    "Beagles",
  1L,        NA,    "Persian",
  2L,        NA,    "Maine Coon",
  3L,        NA,    "Ragdoll",
  4L,        NA,    "Exotic",
  5L,        NA,    "Siamese",
  6L,     "Cat",    "American Short"
)

tidy_pets %>%
  fill(pet_type, .direction = "up")

#CASE STUDY

tidyr::who

view(who)
#our dataset contains redundant columns, odd variable codes, and many missing values.

#the best place to start is almost always to gather together the columns that are not variables.

#country, iso2 and 3 specify the country
#year is a variable too
#as we got 60 variables(columns) starting at new_sp_m014 all the way to newrel_f65, it is most likely introduced as values

#we're going to gather together all the columns that we think are values, this includes the count of cases
#with the missing values, we use na.rm for now.

who1 <- who %>% 
  gather(
    new_sp_m014:newrel_f65, key = "key",
    value = "cases",
    na.rm = TRUE
  )
who1

#we can count the new columns that we think there are values

who1 %>% count(key)

#using the data dictionary, we understand that the first 3 letters, means the type of TB, new / old
#the next 2 letters: rel stands for cases of relapse, ep = extrapulmonary, etc...
#the 3rd letter gives the sex of the patients
#the remaining, is the age group

#the names of the variables are inconsistent, instead of new_rel we got newrel
who2 <- who1 %>% mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
view(who2)

#we can separate the values in each code with two passes of separate()
who3 <- who2 %>%
  separate(key, c("new", "type", "sexage"), sep = "_")
who3

#we can alos remove the column "new", iso2 and 3

who3 %>%
  count(new)

who4 <- who3 %>%
  select(-new, -iso2, -iso3)
who4

who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who5
?separate

#now the dataset is tidy

#to integrate this into a complex pipe, we could of:
?stringr
who %>%
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>%
  mutate(
    code = stringr::str_replace(code, "newrel", "new_rel")) %>%
      separate(code, c("new", "var", "sexage")) %>%
      select(-new, -iso2, -iso3) %>%
      separate(sexage, c("sex", "age"), sep = 1)
  
