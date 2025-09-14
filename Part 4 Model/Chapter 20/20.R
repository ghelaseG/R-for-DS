# Chapter 20

# Many Models with purrr and broom

#here we learn how to use many simple models to better understand complex datasets, use list-columns to store arbitrary data structures in a data frame and use the broom package, to turn models into tidy data.

#this chapter is a bit more complex and requires a good understanding about modeling, data structures and iteration.

library(modelr)
library(tidyverse)

#gapminder

#this data was made by a Swedish doctor and statistician - Hans Rosling.

library(gapminder)
gapminder %>% view()

# "How does life expectancy (lifeExp) change over time (year) for each country (country)?"

gapminder %>% 
  ggplot(aes(year, lifeExp, group = country)) +
  geom_line(alpha = 1/3)
