# Chapter 7 - Tibbles with tibble

# Tibbles are data frames, but they tweak some older behaviors to make life a little easier.

vignette("tibble") #use this if you want to learn more about tibbles

library(tidyverse)

# Creating tibbles

#tibbles are one of the unifying features of the tidyverse

# to change a data frame to a tibble you can use as_tibble()

as_tibble(iris)

#you can create a new tibble, this will automatically recycle inputs of length 1.

tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y
)

#tibble() does not change the type of the inputs (e.g. it never converts strings to factors!), it never changes the names of variables, and it never creates row names.

# you can use nonsyntactic names for the columns, and you can do this by using backticks `; for example:

tb <- tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"
)
tb

# you'll need the backticks when working with these variables in packages such as ggplot2, dpllyr and tidyr

# another way to create a tibble is with tribble() - or better names transposed tibble.
#tribble() is customized for data entry in code: column headings are defined by formulas (i.e. they start with ~), and entries are separated by commas, for exp:

tribble(
  ~x, ~y, ~z,
  #--/--/--- this helps to make it clear where the header is
  "a", 2, 3.6,
  "b", 1, 8.5
)


# Tibbles versus data.frame

#there are two main differences in the usage of a tibble versus a classic data.frame: printing and subsetting.

# Printing

#tibbles have a refined print method that shows only the first 10 rows, and all the columns that fit on screen.
#this makes it much easier to work with large data.
#in addition, each column reports its type.

tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

#you can print all the columns using width = Inf, and n for the rows
nycflights13::flights %>%
  print(n = 10, width = Inf)

#you can also control the default print behavior by setting options:

# options(tibble.print_max = n, tibble.print_min = m)
# options(dplyr.print_min = Inf) to show all rows.
# options(tibble.width = Inf) to always print all columns.

package?tibble # use this to see a complete list of options

# another option is to use view()
nycflights13::flights %>% view()


# Subsetting

#if you want to pull out a single variable, you need some new tools, $ and [[.

#[[ can extract by name or position
#$ only extracts by name

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

#extract by name
df$x
df[["x"]]

#extract by position
df[[1]]

#to use these in a pipe, you'll need to use the special placeholder . (dot):

df %>% .$x
#or
df %>% .[["x"]]

#tibble will generate a warning if the column you are trying to access does not exist

# interacting with older code

class(as.data.frame(tb))

# Exercises:

#1. How can you tell if an object is a tibble? (Hint: try printing mtcars, which is a regular data frame).

#Answer:

print(mtcars)
# we can easily see the difference by checking the way it prints the data frame
#tibble report each column type and only the first 10 rows.

#2. Compare and contrast the following operations on a data.frame and equivalent tibble. What is different? Why might the default data frame behaviors cause you frustration?

# Answer:

#the difference are in comments, and some of the behaviors are different between the 2.

df <- data.frame(abc = 1, xyz = "a")
df$x # [1] "a"
df[, "xyz"] # [1] "a"
df[, c("abc", "xyz")] #   abc xyz
                      #1   1   a

tbl <- tibble(abc = 1, xyz = "a")

tbl$x
#we get the following: 
##NULL
##Warning message:
##  Unknown or uninitialised column: `x`.

tbl[, 'xyz']
## A tibble: 1 × 1
#  xyz  
# <chr>
#1  a 

tbl[, c("abc", "xyz")]
## A tibble: 1 × 2
#    abc   xyz  
#   <dbl> <chr>
#1    1     a

#3. If you have the name of a variable stored in an object, e.g., var <- "mpg", how can you extract the reference variable from a tibble?

#Answer:

#we can use as_tibble()
as_tibble(mpg)

#4. Practice referring to nonsyntactic names in the following data frame by:
    #a. Extracting the variable called 1.
    #b. Plotting a scatterplot of 1 versus 2.
    #c. Creating a new column called 3, which is 2 divided by 1.
    #d. Renaming the columns to one, two, and three:
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

annoying
#Answer:
#a.
annoying$`1`
class(annoying[[1]])
#b.
ggplot(data = annoying, aes(x = `1`, y = `2`)) +
  geom_point()
#c.
annoying <- annoying %>% mutate(`3` = `2` / `1`)
annoying
#d.
annoying %>% rename(one = `1`, two = `2`, three = `3`)

#5. What does tibble::enframe() do? When might you use it?

#Answer:

tibble::enframe()
?tibble::enframe()
# Converting vectors to data frames, and vice versa
# enframe() converts named atomic vectors or lists to one- or two-column data frames. For a list, the result will be a nested tibble with a column of type list. For unnamed vectors, the natural sequence is used as name column.

#6. What option controls how many additional column names are printed at the footer of a tibble?

#Answer:

#you can print all the columns using width = Inf or use options(tibble.width = Inf) to always print all columns.