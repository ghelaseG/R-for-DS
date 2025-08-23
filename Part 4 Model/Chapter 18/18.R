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

#another option is to generate an evenly spaced grid of points (grid search)

grid <- expand.grid(
  a1 = seq(-5, 20, length = 25),
  a2 = seq(1, 3, length = 25)
) %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

grid %>% 
  ggplot(aes(a1, a2)) +
  geom_point(
    data = filter(grid, rank(dist) <= 10),
    size = 4, colour = "red"
  ) +
  geom_point(aes(colour = -dist))

#now let's try and overlay the 10 models:

ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, colour = "grey30") +
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist),
    data = filter(grid, rank(dist) <= 10)
  )

#we can do this until we get a finer grid (best model), or we can use a tool named Newton-Raphson search.
#the way this works, is by choosing a starting point and look around for the steepest slope, until you can not go any lower.
#we can use optim() for this modeling:

best <- optim(c(0, 0), measure_distance, data = sim1)
best$par
best

ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, colour = "grey30") +
  geom_abline(intercept = best$par[1], slope = best$par[2])

# you can find the best model if you can minimize the distance by modifying the parameters of the model and having a function that defines the distance between a model and a dataset.

#we can also use linear models, in a form of: y = a_1 + a_2 * x_1 + a_3 * x_2 + ... + a_n * x_(n - 1)

#this simple model is the same to a general linear model where n = 2 and x_1 = x

#lm() formulas look like y ~ x, which lm will translate to a function like y = a_1 + a_2 * x

sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod)
#similar results with optim()

#lm finds the closest model in a single step

# Exercises:

#1. One downside of the linear model is that it is sensitive to unusual values because the distance incorporates a squared term. Fit a linear model to the following simulated data, and visualize the results. Rerun a few times to generate different simulated datasets. What do you notice about the model?

sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)

#2. One way to make linear odels more robust is to use a different distance measure. For example, instead of root-mean-squared distance, you could use mean-absolute distance:

measure_distance <- function(mod, data) {
  diff <- data$y - make_prediction(mod, data)
  mean(abs(diff))
}

#Use optim() to fit this model to the pervious simulated data and compare it to the linear model.

#3. One challenge with performing numerical optimization is that it's only guaranteeed to find one local optima. What's the problem with optimizing a three-parameter model like this?

model1 <- function(a, data) {
  a[1] + data$x * a[2] + a[3]
}

#Answers:

#1. 

sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)

sim1a_modeling <- lm(y ~ x, data = sim1a)
summary(sim1a_modeling)

ggplot(sim1a, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_abline(intercept = sim1a_modeling$coefficients[1], slope = sim1a_modeling$coefficients[2])

# We can notice that everytime we're generating different simulated datasets, by running the summary we can see a big difference at the distance between the fitted line and the data.
# These figures, for example min and max should be equally distributed around the line (or better said, to be approximately same distance to 0)
# The first quantile and the third quantile to be equal distance from zero. (the same goes for the median)

#Extras:
view(sim1a)

ggplot(sim1a, aes(x, y)) +
  geom_point()

ggplot(sim1a, aes(x, y)) +
  geom_point(size = 2, colour = "grey30") +
  geom_abline(
    aes(intercept = a1, slope = a2, color = -dist),
    data = filter(models, rank(dist) <= 10)
  )

coef(sim1a_modeling)

hist(resid(sim1a_modeling), nclass = 2)
boxplot(y ~ x, data = sim1a)

sum <- summary(sim1a_modeling)
sum$coefficients

#2.


