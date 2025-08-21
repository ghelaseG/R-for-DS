# Model Basics with modelr

#we are going to use models to partition data into patterns and residuals(residuals represent the difference between observed values and predicted values)
#source Google: Example: If a regression model predicts a student's test score to be 85, and the actual score is 90, the residual is 5. This indicates the model underestimated the score by 5 points.

#strong patterns will hide subtler trends.

# there are two parts to a model:

## 1. first rule is to define a group of models that helps you to capture a pattern (a straight line or a quadratic curve)
### expressing this as an equation will be: 
### y = a_1 * x + a_2 or
### y - a_1 * x ^ a_2
#### x and y are variables from data
#### a_1 and a_2 are parameters to capture patterns

## 2. after this, you will fit the right model from a family of models.

## George Box quote " All models are wrong, but some are useful."

"The goal of a model is not to uncover truth, but to discover a simple approximation that is still useful."

library(tidyverse)

library(modelr)
options(na.action = na.warn)

# A simple model

ggplot(sim1, aes(x, y)) +
  geom_point()

#> we can see a strong pattern in the data.
#> the relationship looks linear: y = a_0 + a_1 * x
#> we can start by using geom_abline() which takes a slope and intercept as parameters

models <- tibble(
  a1 = runif( 250, -20, 40),
  a2 = runif(250, -5, 5)
)

ggplot(sim1, aes(x, y)) +
  geom_abline(
    aes(intercept = a1, slope = a2),
    data = models, alpha = 1/4
  ) +
  geom_point()

#there are way too many models on this plot, we need to find one that is closer to the data.
#to do that, we need to find the distance between each point and the model.

#creating a function, will help us compute the distance.

model1 <- function(a, data) {
  a[1] + data$x * a[2]
}
model1(c(7, 1.5), sim1)

#next, we need to compute an overall distance betweem the predicted and actual values (for exp, we can use root-mean-squared deviation)

measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}

measure_distance(c(7, 1.5), sim1)

#we need a helper function.

sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

models <- models %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
models

#next, we can overlay the 10 best models (the way it is shown to us in the graph - brightest colour is the best(smallest distance)).

ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist),
    data = filter(models, rank(dist) <= 10)
  )

#in the next scatterplot, the red circles are the best models.

ggplot(models, aes(a1, a2)) +
  geom_point(
    data = filter(models, rank(dist) <= 10),
    size = 6, colour = "red"
  ) +
  geom_point(aes(colour = -dist))
