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
