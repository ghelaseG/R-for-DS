# Model Building

#> in this chapter we focus on real data, showcasing how we can progressively build up a models to aid our understanding of the data.
#> we can think about a model as partitioning our data into patterns and residuals.
#> we find patterns with visualization, then make them concrete and precise with a model.
#> 
#> we then repeat the process, but replace the old response variable with the residuals from the model.
#> 
#> our goal is to simply transition from implicit knowledge to explicit knowledge.
#> 
#> for very large datasets our machine learning approach is to focus on the predictive ability of the model.
#> 
#> these approaches tend to produce black boxes, good to use the models but if you don't know why then it might affect in the long term, as fundamentals change.
#> 
#> it's a challenge to know when to stop, because you need to figure out when your model is good enough.
#> Quote from the book: " A poor seamstress makes many mistakes. A good seamstress works hard to correct those mistakes. A great seamstress isn't affraid to throw out the garment and start over."

# Tools we use:

library(tidyverse)
library(modelr)
options(na.action = na.warn)

library(nycflights13)
library(lubridate)

# Why are Low-Quality Diamonds more expensive?

ggplot(diamonds, aes(cut, price)) + geom_boxplot()
ggplot(diamonds, aes(color, price)) + geom_boxplot()
ggplot(diamonds, aes(clarity, price)) + geom_boxplot()

# Price and Carat

#it looks like lower-quality diamonds have higher prices because of a confounding variable: the weight (carat) of the diamond.

ggplot(diamonds, aes(carat, price)) +
  geom_hex(bins = 50)

# we can make it easier to see how the other attributes of a diamond affect its relative price by fitting a model to separate out the effect of carat.

# let's model the data: first we are choosing to focus on diamonds smaller than 2.5 carats (99.7% of the data) and second we are going to log transform the carat and price variables:

diamonds2 <- diamonds %>% 
  filter(carat <= 2.5) %>% 
  mutate(lprice = log2(price), lcarat = log2(carat))

diamonds2

#these changes make it easier to see the relationship between carat and price:

ggplot(diamonds2, aes(lcarat, lprice)) +
  geom_hex(bins = 50)

#so basically, log transformation makes the pattern linear.
#our next step is to remove that strong linear pattern.

mod_diamonds <- lm(lprice ~ lcarat, data = diamonds2)

#after this we look at what the model tells us about the data.

grid <- diamonds2 %>% 
  data_grid(carat = seq_range(carat, 20)) %>% 
  mutate(lcarat = log2(carat)) %>% 
  add_predictions(mod_diamonds, "lprice") %>% 
  mutate(price = 2 ^ lprice)

grid

ggplot(diamonds2, aes(carat, price)) +
  geom_hex(bins = 50) +
  geom_line(data = grid, colour = "red", size = 1)

# now we can look at the residuals, which verifies that we've removed the strong linear pattern:

diamonds2 <- diamonds2 %>% 
  add_residuals(mod_diamonds, "lresid")

diamonds2

ggplot(diamonds2, aes(lcarat, lresid)) +
  geom_hex(bins = 50)

ggplot(diamonds2, aes(cut, lresid)) + geom_boxplot()
ggplot(diamonds2, aes(color, lresid)) + geom_boxplot()
ggplot(diamonds2, aes(clarity, lresid)) + geom_boxplot()

#now we see the relationship we expect: as the quality of the diamonds increases, so to does its relative price.

#a residual of -1 indicates that lprice was 1 unit lowert than a prediction bases on its weight, and residuals with value 1 are twice the predicted price.


# A More Complicated Model

#we could include color, cut and clarity into the model so that we make explicit the effect of these three categorical variables:

mod_diamond2 <- lm(
  lprice ~ lcarat + color + cut + clarity,
  data = diamonds2
)

# this model includes four predictors, so it's harder to visualise ( but we can plot them individually in four plots)

grid <- diamonds2 %>% 
  data_grid(cut, .model = mod_diamond2) %>% 
  add_predictions(mod_diamond2)

grid

ggplot(grid, aes(cut, pred)) +
  geom_point()

#data_grid automatically fill in some needed variables for the model.
#for continuous uses the median and for catergorical with the most common value.

diamonds2 <- diamonds2 %>% 
  add_residuals(mod_diamond2, "lresid2")

ggplot(diamonds2, aes(lcarat, lresid2)) +
  geom_hex(bins = 50)

#in the plot we can find some diamonds with residual of 2 (meaning that the price was 4 times higher than the we expected)

diamonds2 %>% 
  filter(abs(lresid2) > 1) %>% 
  add_predictions(mod_diamond2) %>% 
  mutate(pred = round(2 ^ pred)) %>% 
  select(price, pred, carat:table, x:z) %>% 
  arrange(price)

# Exercises:

#1. In the plot of lcarat versus lprice, there are some bright vertical strips. What do they represent?

#Answer:

#1.
ggplot(diamonds2, aes(lcarat, lprice)) +
  geom_hex(bins = 50)

#the bright vertical strips represent the number of distribution on the xy axis - ("count" above 450)

#2. If log(price) = a_0 + a_1 * log(carat), what does that say about the relationship between price and carat?

# Answer:

#2.

#Based on the book:
# the carat of the diamond is the single most important factor for determining the price of the diamond.
## "the log transformation is particularly useful here because it makes the pattern linear."

#3. Extract the diamonds that have very high and very low residuals. Is there anything unusual about these diamonds? Are they particularly bad or good, or do you think these are pricing errors?

# Answer:

#3.

diamonds3 <- diamonds2 %>% 
  add_residuals(mod_diamonds, "lresid") %>% view

view(diamonds3)

diamonds3 %>% 
  select(carat, cut, clarity, depth, price, lresid) %>% 
  filter(lresid > 1.8 | lresid < -1.9)


diamonds3 %>% 
  ggplot(aes(clarity, price)) +
  geom_boxplot() +
  facet_grid(~cut)

# it looks like it can be an error

#>	 0.3  Very Good VVS2     60.6  2366   1.93
#and
#> 5  1.03 Fair      I1       78.2  1262  -1.96

#4. Does the final model, mod_diamond2, do a good job of predicting diamond prices? Would you trust it to tell you how much to spend if you were buying a diamond?

# Answer:

#4.

diamonds2 %>% 
  filter(abs(lresid2) > 1) %>% 
  add_predictions(mod_diamond2) %>% 
  mutate(pred = round(2 ^ pred)) %>% 
  select(price, pred, carat:table, x:z) %>% 
  arrange(price) %>% view()

#it is a significant difference between the 2, therefore it doesn't do a great job in predicting diamond prices.