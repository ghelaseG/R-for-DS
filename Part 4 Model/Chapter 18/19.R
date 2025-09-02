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


# What Affects the Number of Daily Flights?

#we are going to check the number of flights that leave NYC per day.

#we first count the number of flights per day.
daily <- flights %>% 
  mutate(date = make_date(year, month, day)) %>% 
  group_by(date) %>% 
  summarise(n = n())
daily

ggplot(daily, aes(date, n)) +
  geom_line()


# Day of Week

daily <-  daily %>% 
  mutate(wday = wday(date, label = TRUE))
ggplot(daily, aes(wday, n)) +
  geom_boxplot()

#there are fewer flights on Saturday and Sunday because most travel is for business.
#to remove this pattern we can use a model:

mod <- lm(n ~ wday, data = daily)

grid <- daily %>% 
  data_grid(wday) %>% 
  add_predictions(mod, "n")

ggplot(daily, aes(wday, n)) +
  geom_boxplot() +
  geom_point(data = grid, colour = "red", size = 4)

#we can check the residuals:

daily <- daily %>% 
  add_residuals(mod)

daily %>% 
  ggplot(aes(date, resid)) +
  geom_ref_line(h = 0) +
  geom_line()

ggplot(daily, aes(date, resid, color = wday)) +
  geom_ref_line(h = 0) +
  geom_line()

#our model fails to predict the flights on Saturday.

#there are days with far fewer flights than expected
daily %>% 
  filter(resid < -100)

#there seems to be soe smoother long-term trend overt the year:

daily %>% 
  ggplot(aes(date, resid)) +
  geom_ref_line(h = 0) +
  geom_line(color = "grey50") +
  geom_smooth(se = FALSE, span = 0.20)

#because our data is small (one year of data), we can only use our domain knowledge to see potential predictions.


# Seasonal Saturday Effect

#we tackle our failure to accurately predict the number of flights on Saturday.

daily %>% 
  filter(wday == "Sat") %>% 
  ggplot(aes(date, n)) +
  geom_point() +
  geom_line() +
  scale_x_date(
    NULL,
    date_breaks = "1 month",
    date_labels = "%b"
  )

# this pattern can be caused by the summer holidays.

#we can create a "term" variable that captures the three school terms, and check our work with a plot:

term <- function(date) {
  cut(date,
      breaks = ymd(20130101, 20130605, 20130825, 20140101),
      labels = c("spring", "summer", "fall"))
}

daily <- daily %>% 
  mutate(term = term(date))

daily

daily %>% 
  filter(wday == "Sat") %>% 
  ggplot(aes(date, n, color = term)) +
  geom_point(alpha = 1/3) +
  geom_line() +
  scale_x_date(
    NULL,
    date_breaks = "1 month",
    date_labels = "%b"
  )

#now, let's see how this new variable affects the other days of the week:

daily %>% 
  ggplot(aes(wday, n, color = term)) +
  geom_boxplot()

mod1 <- lm(n ~ wday, data = daily)
mod2 <- lm(n ~ wday * term, data = daily)

daily %>% 
  gather_residuals(without_term = mod1, with_term = mod2) %>% 
  ggplot(aes(date, resid, color = model)) +
  geom_line(alpha = 0.75)

#we can see the problem by overlaying the predictions from the model into the raw data:

grid <- daily %>% 
  data_grid(wday, term) %>% 
  add_predictions(mod2, "n")

ggplot(daily, aes(wday, n)) +
  geom_boxplot() +
  geom_point(data = grid, color = "red") +
  facet_wrap(~ term)

#because of the outliers, the mean tends to be far away from the typical value.

#using MASS::rlm() reduces the impact of the outliers on our estimates

mod3 <- MASS::rlm(n ~ wday * term, data = daily)

daily %>% 
  add_residuals(mod3, "resid") %>% 
  ggplot(aes(date, resid)) +
  geom_hline(yintercept = 0, size = 2, color = "white") +
  geom_line()

# Computed Variables

#it is a good idea to bundle everything in a function to avoid any mistakes.

compute_vars <- function(data) {
  data %>% 
    mutate(
      term = term(date),
      wday = wday(date, label = TRUE)
    )
}

#or put everything in the model:

wday2 <- function(x) wday(x, label = TRUE)
mod3 <- lm(n ~ wday2(date) * term(date), data = daily)

# including the transformations will make the model self-contained.


# Time Of Year: An Alternative Approach

#we can use a flexible model:

library(splines)

mod <- MASS::rlm(n ~ wday * ns(date, 5), data = daily)

daily %>% 
  data_grid(wday, date = seq_range(date, n = 13)) %>% 
  add_predictions(mod) %>% 
  ggplot(aes(date, pred, color = wday)) +
  geom_line() +
  geom_point()

# we can see a similar pattern in Saturday flights.