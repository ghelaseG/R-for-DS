# CHAPTER 2
# Workflow: Basics

library(tidyverse)

# Coding Basics

1 / 200 * 30

(59 + 73 + 2) / 3

sin(pi / 2)

x <- 3 * 4 #same as object_name <- value ("object name gets value")

x

#more example

this_is_a_really_long_name <- 3.5
this_is_a_really_long_name

r_rocks <- 2 ^ 3
r_rock


# Calling Functions

seq(1, 10)

x <- "hello world"

x <- "hello

y <- seq(1, 10, length.out = 5)

y

(y <- seq(1, 10, length.out = 5))


#Exercises

#1. Why does this code not work?

my_variable <- 10
my_varable

#Look carefully! (This may seem like an exercise in pointlessness, but training your brain to notice even the tiniest difference will pay off when programming.)

#Answer

# "i" from variable "my_variable" is missing.

#2. Tweak each of the following R commands so that they run correctly:

library(tidyverse)

ggplot(dota = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
  
fliter(mpg, cyl = 8)
fliter(diamond, carat > 3)

#Answer

library(tidyverse)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
  
filter(mpg, cyl == 8)

#3. Press Alt-Shift-K. What happens? How can you get to the same place using the menus?

#Answer

#by pressing Alt-Shift-K takes us to the keyboard shortcut quick reference. We can do this by going to Tools-Keyboard SHortcut Helps