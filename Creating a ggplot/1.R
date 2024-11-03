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


