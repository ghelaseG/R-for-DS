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
