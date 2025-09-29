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
  group_by(country, continent) %>% 
  nest() %>% 
  mutate(model = map(data, ~lm(lifeExp ~ year, .))) %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance) %>% 
  unnest(data) %>% 
  filter(r.squared < 0.25) %>% 
  ggplot(aes(year, lifeExp)) +
  geom_line(aes(color = country))


# List-Columns

#list columns are implicit in the definition of the data frame: a data frame is a named list of equal length vectors.

data.frame(x = list(1:3, 3:5))

data.frame(
  x = I(list(1:3, 3:5)),
  y = c("1, 2", "3, 4, 5")
)

tibble(
  x = list(1:3, 3:5),
  y = c("1, 2", "3, 4, 5")
)

tribble(
   ~x, ~y,
  1:3, "1, 2",
  3:5, "3, 4, 5"
)

#for intermediate use, list columns are great, however, the functions in R are made for atomic vectors or data frames.

#there are 3 parts for an effective list column pipeline:

#1. create the list column using one of the nest(), summarize() + list() or mutate() + map function
#2. create other intermediate list columns by transforming existing list columns with map(), map2() and pmap()
#3. simplify the list column back down to a data frame or atomic vector.


# Creating List-Columns

# we can't create list columns with tibble(), we can do that using:

## 1. tidyr::nest(): this converts a grouped of data frame into a nested data frame.
## 2. mutate() and vectorized function that return a list.
## 3. summarize() and summary functions that return additional results.

# or you can use tibble::enframe()


# With Nesting

# nest creates a nested dataframe ( list column of data frames ) with each row as a meta-observation, the other columns give variables and the list-column gives the individual observation.

#group:
gapminder %>% 
  group_by(country, continent) %>% 
  nest()

#ungroup:
gapminder %>% 
  nest(year:gdpPercap)


# From Vectorized Functions

# using stringr::str_split() inside mutate, we get a list column:

df <- tribble(
  ~x1,
  "a,b,c",
  "d,e,f,g"
)

df %>% 
  mutate(x2 = stringr::str_split(x1, ","))

df %>% 
  mutate(x2 = stringr::str_split(x1, ",")) %>% 
  unnest()

# we could use this pattern with tidyr::separate_rows()

sim <- tribble(
  ~f,         ~params,
  "runif",    list(min = -1, max = -1),
  "rnorm",    list(sd = 5),
  "rpois",    list(lambda = 10)
)

sim %>% 
  mutate(sims = invoke_map(f, params, n = 10))

#here sim is not homogeneous


# From Multivalued Summaries

#summarize works only with summary functions

mtcars %>% 
  group_by(cyl) %>% 
  summarise(q = quantile(mpg))

mtcars %>% 
  group_by(cyl) %>% 
  summarise(q = list(quantile(mpg)))

probs <- c(0.01, 0.25, 0.5, 0.75, 0.99)

mtcars %>% 
  group_by(cyl) %>% 
  summarise(p = list(probs), q = list(quantile(mpg, probs))) %>% 
  unnest()


# From a Named List

#to create a data frame that with one column that contain the elements, and one that contain the list, we can use tibble::enframe():

x <- list(
  a = 1:5,
  b = 3:4,
  c = 5:6
)

df <- enframe(x)
df

#this way is great for metadata

df %>% 
  mutate(
    smry = map2_chr(
      name, 
      value,
      ~ stringr::str_c(.x, ": ", .y[1])
    )
  )


# Exercises:

## 1. List all the functions that you can think of that take an atomic vector and return a list.

## 2. Brainstorm useful summary functions that, like quantile(), return multiple values.

## 3. What's missing in the following data frame? How does quantile() return that missing piece? Why isn't that helpful here?

mtcars %>% 
  group_by(cyl) %>% 
  summarise(q = list(quantile(mpg))) %>% 
  unnest()
