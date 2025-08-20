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
