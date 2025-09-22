# Chapter 20

# Many Models with purrr and broom

#here we learn how to use many simple models to better understand complex datasets, use list-columns to store arbitrary data structures in a data frame and use the broom package, to turn models into tidy data.

#this chapter is a bit more complex and requires a good understanding about modeling, data structures and iteration.
#but you can use this youtube channel and video: https://www.youtube.com/watch?v=l8dBfjq6lR4&ab_channel=CradleToGraveR

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

#from the graph, we can see that some countries doesn't follow the same pattern:

nz <- filter(gapminder, country == "New Zealand")
nz %>% 
  ggplot(aes(year, lifeExp)) +
  geom_line() +
  ggtitle("full data =")

nz_mod <- lm(lifeExp ~ year, data = nz)
nz %>% 
  add_predictions(nz_mod) %>% 
  ggplot(aes(year, pred)) +
  geom_line() +
  ggtitle("Linear trend + ")

nz %>% 
  add_residuals(nz_mod) %>% 
  ggplot(aes(year, resid)) +
  geom_hline(yintercept = 0, color = "white", size = 3) +
  geom_line() +
  ggtitle("Remaining pattern")


# Nested Data

#we can use the nested data frame to repeat an action for each country, a subset of rows.

by_country <- gapminder %>% 
  group_by(country, continent) %>% 
  nest()

by_country

#doing this will be easier to see all the details from a data frame

by_country$data[[1]]

#in a grouped data frame, each row is an observation, but in a nested data frame, each row is a group.
#nested dataset is similar to meta data or meta observation.


# List-Columns

#now we are fitting a model:

country_model <- function(df) {
  lm(lifeExp ~ year, data = df)
}

#and then we want to apply it to every data frame (are in a list)

models <- map(by_country$data, country_model)

by_country <- by_country %>% 
  mutate(model = map(data, country_model))

by_country

#doing this will store all the related objects together.

by_country %>% filter(continent == "Europe")
by_country %>% arrange(continent, country)


# Unnesting

by_country <- by_country %>% 
  mutate(
    resids = map2(data, model, add_residuals)
  )

by_country

resids <- unnest(by_country, resids)
resids

resids %>% 
  ggplot(aes(year, resid)) +
  geom_line(aes(group = country), alpha = 1 / 3) +
  geom_smooth(se = FALSE)

# faceting by continent

resids %>% 
  ggplot(aes(year, resid, group = country)) +
  geom_line(alpha = 1 / 3) +
  facet_wrap(~continent)


# Model Quality

#instead of looking at the residuals, we can look at the model quality.

broom::glance(nz_mod)

by_country %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance)

glance <- by_country %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance, .drop = TRUE)
view(glance)

#we can now look at models that don't fit well:

glance %>% 
  arrange(r.squared)

glance %>% 
  ggplot(aes(continent, r.squared)) +
  geom_jitter(width = 0.5)

#we could pull out the countries with bad r squared :

bad_fit <- filter(glance, r.squared < 0.25)

gapminder %>% 
  semi_join(bad_fit, by = "country") %>% 
  ggplot(aes(year, lifeExp, color = country)) +
  geom_line()

# Exercises:

#1. A linear trend seems to be slightly too simple for the overall trend. Can you do better with a quadratic polynomial? How can you interpret the coefficients of the quadratic? (Hint: you might want to transform year so that it has mean zero.)

#2. Explore other methods for visualizing the distrbution of R squared per continent. You might want to try the ggbeeswarm package, which provides similar methods for avoiding overlaps as jitter, but uses deterministic methods.

#3. To create the last plot ( showing the data for the countries with the worst model fits ), we needed two steps: we created a data frame with one row per country and then semi-joined it to the original dataset. It's possible avoid this join if we use unnest() instead of unnest(.drop = TRUE). How?

# Answers:

#1. 
#source Google:
"""
To implement a quadratic polynomial in R for polynomial regression, use the lm() function with either the formula y ~ x + I(x^2) to include the explicit squared term or y ~ poly(x, 2) to use the poly() function to generate orthogonal polynomial terms. The lm() function builds the model, fitting a curve to your data rather than a straight line, and I(x^2) is necessary to prevent R from misinterpreting the ^ operator in the formula. 
"""

mod_Quadratic <- function(df) {
  lm(data = df, lifeExp ~ poly(year, 2))
}

quadraticC <- gapminder %>% 
  mutate(year = year - mean(year)) %>% 
  group_by(country) %>% 
  nest() %>% 
  mutate(model = purrr::map(data, mod_Quadratic))

quadraticC <- quadraticC %>% 
  mutate(resids = map2(data, model, add_residuals))

unnest(quadraticC, resids)

unnest(quadraticC, resids) %>% 
  ggplot(aes(group = country)) +
  geom_line(aes(x = year, y = resid)) +
  facet_wrap(~continent, nrow = 2)

quadraticC %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance, .drop = TRUE) %>% 
  arrange(r.squared)

quadraticC %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance, .drop = TRUE) %>% 
  ggplot(aes(r.squared)) +
  geom_histogram(bins = 100)

#2.

library(ggbeeswarm)

gapminder %>% 
  mutate(year = year - mean(year)) %>% 
  group_by(continent, country) %>% 
  nest() %>% 
  mutate(model = map(data, mod_Quadratic)) %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance) %>% 
  ggplot(aes(x = continent, y = r.squared, color = continent)) +
  geom_beeswarm()

#3.

gapminder %>% 
  mutate(year = year - mean(year)) %>% 
  group_by(country) %>% 
  nest() %>% 
  mutate(model = map(data, mod_Quadratic)) %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance) %>% 
  unnest(data) %>% 
  semi_join(gapminder, by = c("pop", "country")) %>% 
  arrange(r.squared) %>% 
  filter(r.squared %in% unique(r.squared)[1:6]) %>% 
  ggplot(aes(x = year + mean(gapminder$year), y = log(pop))) +
  geom_line(aes(color = country))
