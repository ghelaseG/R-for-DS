library(tidyverse)

# displ = engine size
# hwy = fuel efficiency
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))


# install.packages("psych")
# install.packages("knitr")
# second example
# load data to a dataframe called fifa teams
library(psych)
library(knitr)


fifa_teams <- read_csv("fifa_teams_cleaned.csv")
View(fifa_teams)
summary(fifa_teams)
# describe(fifa_teams) %>%
#   select("Mean" = "mean", "SD" = "sd", "Median" = "median", "Min" = "min", "Max" = "max")
#   kable(digits = 1)

table(fifa_teams$`Whole team average age`, fifa_teams$date)
ggplot(data = fifa_teams) +
  geom_point(mapping = aes(x = 'Whole team average age', y = date))

# Exercises
#1. Run ggplot(data = mpg). What do you see?
ggplot(data = mpg)
#Answer: empty screen

#2. How many rows are in mtcars? How many columns?
nrow(mtcars)
ncol(mtcars)
#Answer: 32 rows, 11 columns

#3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg
#Answer:drv - the type of drive train, where f = front-wheel drive, r = rear wheel drive, 4 = 4wd

#4. Make a scatterplot of hwy versus cyl.
#Notes: hwy - highway miles per gallon
#       cyl - number of cylinders
  
ggplot(data = mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy))

#5. What happens if you make a scatterplot of class versus drv? Why is the plot not useful?

ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv))
#Answer: scatterplot does not suit our chosen data.
#        important trends hidden.









