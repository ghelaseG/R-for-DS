# EXPLORATORY DATA ANALYSIS



#INTRODUCTION

#here we are going to use visualisation and transofrmation to explore our data in a systematic way, a task that statisticians call EDA

#Few steps to follow:

#1. Generate questions about your data
#2. Search for answers by visualising, transofrimng, and modeling your data
#3. Use what you learn to refine your questions and/or generate new questions

#EDA is not a process with a strict set of rules, is more a state of mind.
#when starting EDA, you should feel free to investigate every idea that occurs to you
#data cleaning is just one applications of EDA, to do data cleaning you'll need to deploy all the tools of EDA: visualisation, transformation and modeling.

#QUESTIONS

# " There are no routine statistical questions, only questionable statistical routines "
#   - Sir David Cox

# " Far better an approximate answer to the right questions, which is often vague, than an exact answer to the wrong question, which can always be made precise. "
#   - John Tukey

# your goal during EDA is to develop an understanding of your data., you can do this using questions as tools to guide your investigation.
#when asking a question, the question focuses your attention on a specific part of your dataset and helps you decide which tools to use

#EDA is fundamentally a creative process, the key to asking 'quality' questions is to generate a large quantity of questions.

#if you start with the right question ( although is hard at the start of your analysis as you don't know any insights about the data )
#on the other hand, each question, will take you to a new aspect of your data and increase your chance of making a discovery, you can quickly drill down into the most intereting parts of your data and develop new interesting questions, dominoes rule I'll say

#there is no rule about which questions you should ask to guide your EDA, but here's an example of two types of questions to help your EDA:
#1. What type of variation occurs within my variables?
#2. What type of covariation occurs between my variables?

#the book will help us define some terms:
# - A 'variable' is a quantity, quality, or property that you can measure.
# - A 'value' is the state of a vairable when you measure it. The value of a variable may change from measurement to measurement.
# - An 'observation', or a 'case', is a set of measurements made under similar conditions ( you usually make all of the measurements in an observation at the same time and on the same object). An observation will contain several values, each assciated with a different variable. I'll sometimes refer to an observation as a data point.
# - Tabular data is a set of values, each assciated with a variable and an observation. Tabular data is tidy if each value is places in its own "cell", each variable in its own column, and each observation in its own row. (in real life most data isn't tidy)
# - Variation is the tendency of values of a variable to change from measurement to measurement. ( you can see variation easily in real life: for exp if you measure any continuous variable twice, you'll get two different results). Categorical variables can aslo vary if you measure across different subjects (the eye colour of different people), or different times (the energy levels of an electron at different moments). Every variable has its own pattern of variation, which can reveal interesting information. The best way to understand that pattern is to visualise the distribution of variables values.

#VISUALISING DISTRIBUTIONS

#visualising the distribution of a variable will depend on whether the variable is categorical or continuous.

## Categorical variable: can only take one of a small set of values. In R, those are usually saved as factors or character vectors.

#To examine the distribution of a categorical variable, use a bar chart:
library(tidyverse)
View(diamonds)
help("diamonds")
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

#you can visualise those values manually with dplyr::count()

diamonds %>%
  count(cut)

## Continuous variable: can take any of an infinite set of ordered values. Numbers and date-times are two examples of continuous variables.

# to examine the distribution of a continuous variable, use a histogram:

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

#you can compute this by hand by combining dplyr::count() and ggplot2::cut_width()

diamonds %>% count(cut_width(carat, 0.5))

#next example uses the size of less than three carats and choose a smaller binwidth:

smaller <- diamonds %>% 
  filter(carat < 3)

View(smaller)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

#we can overlay multiple histograms in the same plot, using geom_freqploy() instead of geom_histogram()
#this uses lines instead, with same calculation as geom_histogram() (tip: it's much easier to understand overlapping lines than bars)

ggplot(data = smaller, mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)


#TYPICAL VALUES

#tall bars show the common values of a variable, and shorter bars show less common values
#to turn this information into useful questions, look for anything unexpected:
# - Which values are the most common? Why?
# - Which values are rare? Why? Does that match your expectations?
# - Can you see any unusual patterns? What might explain them?

# As an example, the following histogram suggests several interesting questions:
# - Why are there more diamonds at whole carats and common fractions of carats?
# - Why are there more diamonds slightly to the right of each peak than there are slightly to the left of each peak?
# - Why are there no diamonds bigger than 3 carats?

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

#clusters of similar values suggest that subgroups exist in your data. To understand the subgroups, ask:
# - How are the observations within each cluster similar to each other?
# - How are the observations in separate clusters different from each other?
# - How can you explain or describe the clusters?
# - Why might the appearance of clusters be misleading?

# the next histogram explore the length(in minutes) of 272 eruptions of the Old Faithful Geyser in Yellowstone National park.
#eruption times appear to be clustered into two groups:
# -short (around 2 minutes)
# -long(4 - 5 minutes)

ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)

#here we can ask if the value of one variable can explain the behavior of another variable.


#UNUSUAL VALUES

#Outliers are observations that are unusual. Data points that don't seem to fit the pattern.
#sometimes outliers are data entry errors, other time they suggest important new science.
#when you have a lot of data, outliers are sometimes difficult to see in a histogram.

#in the following histogram, the only evidence of outliers is the unusually wide limits on the y-axis:

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

#to make it easy to see the unusual values, we need to zoom in to small values of the y-axis with coord_cartesian():

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

#to see that there are three unusual values: 0, ~30, ~60:
unusual <- diamonds %>%
  filter(y < 3 | y > 20) %>%
  arrange(y)
unusual
#the y variable measures one of the 3D of these diamonds in mm. We know that diamonds can't have a width of 0 mm so these values must be incorrect.
#we also suspect that measurements of 32 mm and 59 mm are implausible, those diamonds are over an inch long, but don't cost hundreds of thousands of dollars.

#it's good practice to do this without the outliers, and if they have minimal effect on the results, can be replaced with missing values.
#if they have a substantial effect, you need to disclose that those have been removed (possibly a data entry error)

#Exercises:

#1. Explore the distribution of each of the x, y, z variables in diamonds. What do you learn? Think about a diamond and how you might decide which dimension is the length, width, and depth.

#Answer:

View(diamonds)
simplified_data_x_axis <- diamonds %>%
  select(x, y, z) %>% arrange(x) %>% view()

simplified_data_y_axis <- diamonds %>%
  select(x, y, z) %>% arrange(y) %>% view()

simplified_data_z_axis <- diamonds %>%
  select(x, y, z) %>% arrange(z) %>% view()


#at first, exploring the distribution of each variable, if we arrange the data in ascending order, starting with x axis, and following through,
#we can see some missing values when x is zero, or y is zero or z is zero.

#according to this website:https://rosellejewelry.com/pages/diamond-size-chart-round , a diamond can have the max size of 16mm, and we also remove the zero values and null if happens to be there.
#we can then use plotly to build a 3d plot:
diamond_3d_plot <- diamonds %>% filter(!is.na(x), x > 0 & x < 16) %>% filter(!is.na(y), y > 0 & y < 16) %>% filter(!is.na(z), z > 0 & z < 16) %>% select(x, y, z)
View(diamond_3d_plot)

library(plotly)

#here's a 3d plot with our data
diamond_3d_plot %>%
  plot_ly(x = ~x,
          y = ~y,
          z = ~z)

#according to this image: https://www.diamonds.pro/wp-content/uploads/2023/04/proportions.jpg, let's see the first rows of our dataset.
View(diamond_3d_plot)

#  x     y     z
# 3.95  3.98  2.43

#doing a quick search on Google we can see that: "In a diamond, the width is generally larger than the depth;"
#we now need to sort the data to see how many rows of y are bigger than x, and vice versa

#trial errors
#diamond_3d_plot[rowSums(y > x)]
#j <- diamond_3d_plot %>% summarise(y = y > x, n = n()) %>% summarise(cnt = count(y = TRUE))
#j
gg <- diamond_3d_plot %>% summarise(y = y > x)
sum(gg) #as Y gave us a total number of 30,496 out of 53,917, that means according to our search on google the width is the Y axis
#and X will have a total number of values of 23,421, will be the Depth.

# x - will be the Depth measure
# y - will be the Width measure
# z - will be the Table measure

#2. Explore the distribution of price. Do you discover anything unusual or surprising? (Hint: carefully think about the bin width and make sure you try a wide range of values.)

#Answer:

price_distr <- diamonds %>% select(price)
View(price_distr)
price_distr # we can see that the type of price column is <int>

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price))
#we first try with the basic bin width

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 0.5)
#wow, look at that

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 0.75)
#even prettier

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 9.99)
#using the last binwidth of 9.99 we can simply see that the cheaper diamonds are the ones that are sold or priced the most, whereas the expensive ones are just few sold at higher price.

#3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the difference?

#Answer:
View(diamonds)
carat_0.99 <- diamonds %>% filter(carat == 0.99) %>% view
#there are 23 diamonds with 0.99 carat
carat_1.00 <- diamonds %>% filter(carat == 1) %>% view
#there are 1,558 entries with 1.00 carat

#having a quick search on google, we can see that people tend to want more 1 carat diamond because: "commands a significantly higher price due to the psychological value of reaching the "full carat" mark."

#4. Compare and contrast coord_cartesian() versus xlim() orylim() when zooming in on a histogram. What happens if you leave binwidth unset? What happens if you try and zoom so only half a bar shows?

#Answer:

#let's first take the example from before:

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

#let's try our own examples leaving the binwidth unset (we can see that the bar are a lot wider without binwidth)

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y)) +
  coord_cartesian(ylim = c(0, 50))

#xlim example
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(xlim = c(0, 50))

#if we zoom and only half the bar shows, it's pointless and not helping us explore our data.
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 10.5) +
  coord_cartesian(ylim = c(0, 50))


# MISSING VALUES

#if you've encountered unusual values in your dataset, and want to move on to the rest of your analysis, you can:

#1. drop the entire row with the strange values:

diamonds2 <- diamonds %>%
  filter(between(y, 3, 20)) %>% view()
#this option is vague, because if one value is invalid, doesn't mean all measurements are.
#!Info: if you have low-quality data, by the time you've applied this approach to every variable you might find that you don't have anything left to analyse.

#2, recommended option will be to replace the unusual values with missing values.

#to do this you can use mutate() to replace the variable with a modified copy. You can use the ifelse() function to replace unusual values with NA

diamonds3 <- diamonds %>%
  mutate(y = ifelse(y < 3 | y > 20, NA, y)) %>% view()

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point()

#we can add na.rm = TRUE

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point(na.rm = TRUE)

#other times you want to understand what makes observations with missing values different from observations with recorded values.
#for example, in nycflights13::flights, missing values in dep_time means that the flight was cancelled.
#we can compare the scheduled departure times for cancelled and noncancelled times, using is.na()

nycflights13::flights %>%
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>%
  ggplot(mapping = aes(sched_dep_time)) +
  geom_freqpoly(
    mapping = aes(color = cancelled),
    binwidth = 1/4
  )

# Exercises

#1. What happens to missing values in a histogram? What happens to missing values in a bar chart? Why is there a difference?

# Answer:

ggplot(data = nycflights13::flights, mapping = aes(x = arr_time)) +
  geom_histogram() #?geom_histogram

# in a histogram, we get the following notification: 

## Warning message:
## Removed 8713 rows containing non-finite outside the scale range (`stat_bin()`). 

sum(is.na(nycflights13::flights$arr_time)) #if we count how many missing values we've got in the column arr_time, we can confirm that it is identical.
class(nycflights13::flights$arr_time)
##
ggplot(data = nycflights13::flights, mapping = aes(x = tailnum)) +
  geom_bar()

#in a bar chart, we haven't got any warning messages, although if we count the number of missing values in the tailnum column, we can see that there are 2512 missing values.

sum(is.na(nycflights13::flights$tailnum))
class(nycflights13::flights$tailnum)
#I guess the difference is coming from the type of variable inserted in the column,
#for example, we can see that the type of variable for histogram is integer, while for the barchart is the type of character.

#2. What does na.rm = TRUE do in mean() and sum()?

#Answer:

#let's find out:

mean(nycflights13::flights$arr_time, na.rm = TRUE)
sum(nycflights13::flights$arr_time, na.rm = TRUE)

#running in the terminal "?mean?, we can see that in the documentation: " na.rm	: a logical evaluating to TRUE or FALSE indicating whether NA values should be stripped before the computation proceeds. "
#doing the same thing for sum, running "?sum": " na.rm : logical. Should missing values (including NaN) be removed? "


# COVARIATION

# if variation describes the behavior within a variable, 
# covariation describes the behavior between variables.
#the best way to spot covariation is to visualise the relationship between two or more variables.

# A CATEGORICAL AND CONTINUOUS VARIABLE

# geom_freqpoly is not that useful in exploring the distribuition of a continuous variable broken down by a categorical variable,
#because the height is given by the count.

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500) #using this is hard to see the differences

ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut))

#let's try and make the comparison easier, where we can swap what is displayed on the y axis.

ggplot( data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

# we can also use a boxplot, popular among statisticians, each of those consists:
# - a box that stretches from the 25% of the distribution to the 75%, a distance known as the interquartile range (IQR). In the middle of the box is a line that displays the median, 50 percentile of the distribution. These 3 lines give you a sense of the spread of the distribution and whether or not the distribution is symmetric about the median or skewed to one side.
# - visual points that display observations that fall more than 1.5 times the IQR from either edge of the box. These outlying points are unusual, so they are plotted individually.
# - a line ( or whisker ) that extends from each end of the box and goes to the farthest nonoutlier point in the distribution. 

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

#for more info see this image: https://miro.medium.com/max/9000/1*2c21SkzJMf3frPXPAR_gZA.png

#this plot supports the counterintuitive finding that better quality diamonds are cheaper on average.
#cut is an ordered factor: fair is worse than good, which is worse than very good and so on.
#we can use the reorder function to make a more informative display.

#we can see this for the class variable in the mpg dataset

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

#to make this more interesting, we can reorder class based on the median value of hwy:

ggplot(data = mpg) +
  geom_boxplot(
    mapping = aes(
      x = reorder(class, hwy, FUN = median),
      y = hwy
    )
  )

#if you have long names, you can flip it to 90° with coord_flip()
ggplot(data = mpg) +
  geom_boxplot(
    mapping = aes(
      x = reorder(class, hwy, FUN = median),
      y = hwy
    )
  ) +
  coord_flip()

# Exercises:

#1. Use what you've learned to improve the visualisation of the departure times of cancelled versus noncancelled flights.

# Answer:

test <- nycflights13::flights %>%
  mutate(
    cancelled = is.na(dep_time),
    non_cancelled = is.na(dep_time) == FALSE,
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% view()

summary(test$dep_time)

#trials, fail :)

# #ggplot(data = test, mapping = aes(x = dep_time, y = cancelled)) +
#   geom_boxplot() +
#   coord_flip()
# 
# # or
# 
# ggplot(data = test) +
#   geom_boxplot(
#     mapping = aes(
#       x = reorder(cancelled, dep_time, FUN = median),
#       y = non_cancelled
#     )
#   )

ggplot(
  data = test,
  mapping = aes(x = sched_dep_time)
  ) +
  geom_boxplot(mapping = aes(color = non_cancelled)) + coord_flip()

#2. What variable in the diamonds dataset is most important for predicting the price of a diamond? How is that variable correlated with cut? Why does the combination of those two relationships lead to lower quality diamonds being more expensive?

# Answer:
library(dplyr)
library(ggplot2)

View(diamonds)
#the most important variable for predicting the price of a diamond is the variable with the same name.
#the price is correlated with cut based on the quality of the diamond every diamond has got a price.
# let's see why this correlation leads to the lower quality being more expensive:

#first let's count the number of of each quality of the cut:
summary(diamonds$cut)
summary(diamonds$price)
sum(is.na(diamonds$cut))
sum(is.na(diamonds$price))
rowMeans(diamonds$price, diamonds$cut)

diamonds22 <- diamonds %>%
  group_by(cut) %>%
  summarise(count = sum(price),
    mean = mean(price))
View(diamonds22)

#from this calculation we can simply see that the number of lower quality items are far less than the most expensive ones, therefore the mean will be different, in our case in favour of the good quality products.

#3. Install the ggstance package, and create a horizontal boxplot. How does this compare to using coord_flip()?

# Answer:
install.packages("ggstance")
#??ggstance

#for better understanding of the package, use this link for the github repo: https://github.com/lionel-/ggstance
library("ggstance")

ggplot(mpg, mapping = aes(cty, class, fill = factor(year))) +
  geom_boxploth()

#4. One problem with boxplots is that they were developed in an era of much smaller datasets and tend to display a prohibitively large number of "outlying values". One approach to remedy this problem is the letter value plot. Install the lvplot package, and try using geom_lv() to display the distribution of price versus cut. What do you learn? How do you interpret the pltos?

# Answer:
install.packages("lvplot")
library("lvplot")
diamonds

ggplot(diamonds, aes(cut, price)) + 
  geom_lv(aes(fill = after_stat(LV))) + scale_fill_brewer()

# this tool is great to interpret large datasets, it's much easier to interpret the plot

#5. Compare and contrast geom_violin() with a faceted geom_histogram(), or a colored geom_freqpoly(). What are the pros and cons of each method?

# Answer:

ggplot(data = diamonds, aes(carat, price)) +
  geom_violin()

ggplot(data = diamonds, aes(carat)) +
  geom_histogram()

ggplot(diamonds, aes(carat, colour = cut)) +
  geom_freqpoly(binwidth = 500)

#Pros: histograms display the counts with bars.
#Cons: you can not compare x and y axis.

#Pros: frequency polygons are better when you want to compare two categorical variable.
#Cons: they use lines to display the visualisation.

#Pros: violin plot can plot continuous distribution.
#Cons: alternative to boxplot

#6. If you have a small dataset, it;s sometimes useful to use geom_jitter() to see the relationship between a continuous and categorical variable. The ggbeeswarm package provides a number of methods similar to geom_jitter(). List them and briefly describe what each one does.

#Answer:

?geom_jitter #alternative to geom_point
#example from the documentation
ggplot(diamonds, aes(price, cut)) +
  geom_jitter() #this looks more like the boxplot

install.packages("ggbeeswarm")
library("ggbeeswarm")
?ggbeeswarm #https://github.com/eclarke/ggbeeswarm

#first method is geom_quasirandom ( alternative to geom_jitter )
#The quasirandom geom is a convenient means to offset points within categories to reduce overplotting


ggplot(diamonds, aes(cut, price)) +
  geom_quasirandom(method = "tukey") + coord_flip() #if we use the tukey method, then it looks similar to geom_jitter


# second methid is geom_beeswarm
# The beeswarm geom is a convenient means to offset points within categories to reduce overplotting

ggplot(diamonds, aes(cut, price)) +
  geom_beeswarm() #this looks more like the violin plot


# TWO CATEGORICAL VARIABLES

#to visualise the covariation between categorical variables, you'll need to count the number of observations for each combination
#we can do that by using geom_count()

ggplot(diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

#the size of each circle in the plot displays how many observations occurred at each combination of values.

#we can also compute the count with dplyr

diamonds %>%
  count(color, cut)

#then visualise with geom_title()

diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

# we can use the "seriation" package if the variables are unordered
# for large plots, we can try using d3heatmap, or heatmaply
install.packages("seriation")

# Exercises:

#1. How could you rescale the count dataset to more clearly show the distribution of cut within color, or color within cut?

#some trials with d3heatmap ( ignore :D )
# install.packages("devtools")
# devtools::install_github("rstudio/d3heatmap")
# library(d3heatmap)
# 
# #Type citation('d3heatmap') for how to cite the package.
# #Type ?d3heatmap for the main documentation.
# library(tidyverse)
# 
# ggg <- diamonds %>%
#   count(cut, color) %>% view()
# 
# d3heatmap(ggg, colors = "Blues",key = TRUE, scale = "column", dendrogram = "row", colors = "Spectral", notecol = 'white', key.title = "Legend", print.values = T)

# Answer:

library(tidyverse)

ggg <- diamonds %>%
  count(cut, color) %>% view()
library(scales)
rescale(ggg$n)
resc_data <- ggg %>% mutate(resc_dta = rescale(ggg$n)) %>% view

#we can do that by using rescale function

#let's have a look now at our data.
resc_data %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = resc_dta))

#2. Use geom_tile() together with dplyr to explore how average flight delays vary by destination and month of year. What makes the plot difficult to read? How could you improve it?

#Answer:
library(dplyr)
library(nycflights13)

#this plot is hard to read because the x axis has got all the destinations tighten up together.
flights %>% count(dest) %>% view() #with this we know that we got 105 destinations, where we have to show on our heat maop

flights %>% filter(!is.na(dep_delay)) %>%
  group_by(dest, month) %>%
  summarise(average_delay = mean(dep_delay)) %>% 
  ggplot(aes(x = dest, y = month)) +
  geom_tile(aes(fill = average_delay))

#trials
#flights$month_year <- paste(flights&month, flights$year) 
#unite(month_year, c(n, s), sep = " ", remove = FALSE)
#rounded_delays = ceiling(average_delay)

converted_data <- flights %>% filter(!is.na(dep_delay)) %>% mutate(Date = with(., sprintf("%d-%02d", year, month))) %>% view()


converted_data %>% group_by(dest, Date) %>%
  summarise(average_delay = mean(dep_delay)) %>% 
  ggplot(aes(x = dest, y = Date, fill = average_delay)) +
  geom_tile() +
  scale_x_discrete(guide = guide_axis(n.dodge=3))

#+ coord_flip()

#to fix this problems I merged the month and year into one column using mutate, and then I used 
#scale_x_discrete, which helps us see our 105 destinations

#if you want a simpler version, you can simply flip x and y axis using coord_flip, see here:

converted_data %>% group_by(dest, Date) %>%
  summarise(average_delay = mean(dep_delay)) %>% 
  ggplot(aes(x = dest, y = Date, fill = average_delay)) +
  geom_tile() + coord_flip()

#3. Why is it slightly better to use aes(x = color, y = cut) rather than aes(x = cut, y = color) in the previous example?

#Answer:

#let's have a look:
resc_data %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = resc_dta))

# and

resc_data %>%
  ggplot(mapping = aes(x = cut, y = color)) +
  geom_tile(mapping = aes(fill = resc_dta))

#because it will be harder to read the cut variable and to understand the legend (rescaled data)


# TWO CONTINUOUS VARIABLES

# exponential relationship between the carat size and price of a diamond:

ggplot( data = diamonds ) +
  geom_point(mapping = aes(x = carat, y = price))

#scatterplots are less useful when the size of the dataset grows. We can solve this issue with alpha aesthetic, to add transparency:

ggplot(data = diamonds) +
  geom_point(
    mapping = aes(x = carat, y = price),
    alpha = 1 / 100
  )

# another solution is to use bin.
#we previously bin in one dimension using geom_histogram and geom_freqpoly
#now we'll use geom_bin2d and geom_hex

#geom_bin2d creates rectangular bins
#geom_hex creates hexagonal bins

#we have to install hexbin package to use this
#install.packages("hexbin")
library(hexbin)
library(tidyverse)

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))

#we can bin one continuous variable so it acts like a categorical variable
#then we can use one of the techniques for visualising the combination of a categorical and a continuous variable
#for example, we can bin carat and display a boxplot for each group

ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

#cut_width(x, width) divides x into bins of width.
#by default, all boxplots look almost identical, so its difficult to read what they represent
#to solve this issue, we can make the width of the boxplot proportional to the number of points using varwidth = TRUE

#we can also use cut_number() to display approx the same nr of points in each bin

ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))

# Exercises:

#1. Instead of summarising the conditional distribution with a boxplot, you could use a frequency polygon. What do you need to consider when using cut_width() versus cut_number()? How does that impact a visualisation of the 2D distribution of carat and price?

# Answer:

# using the documentation, ?cut_width:
## cut_width() makes groups of width width.
## cut_number() makes n groups with (approximately) equal numbers of observations

##let's first visualise using a frequency polygon without cut_width and cut_number
ggplot(data = smaller, mapping = aes(x = price, color = carat)) +
  geom_freqpoly(binwidth = 0.1)

#this is hard to understand, we could of done the same using geom_histogram, 

#instead let's transform our column using cut_width:
#we can play with the numbers for cut_width, for me the best is 0.5, but this can be changed at anytime
ggplot(smaller, aes(x = price, color = cut_width(carat, 0.5))) +
  geom_freqpoly()

#now let's use cut_number(), (I prefer this visualisation)
ggplot(smaller, aes(x = price, color = cut_number(carat, 5))) +
  geom_freqpoly()

#you need to consider the number of intervals you choose as well as the width if applied (for example if your dataset has a large number, you have to consider this too) (if the dataset is too small, you can get this error: Insufficient data values to produce 5 bins)
#this choice will impact the visualisation in the way that if you choose a small nr of intervals to create then it's not enough to understand your dataset, as well as if it is too big.

#2. Visualise the distribution of carat, partitioned by price.

#Answer:

ggplot(smaller, aes(x = carat, color = cut_width(price, 10000))) +
  geom_freqpoly()

#3. How does the price distribution of very large diamonds compare to small diamonds. Is it as you expect, or does it surprise you?

#Answer:

large <- diamonds %>%
  filter(carat >= 3)
View(large)

#let's see for the smaller diamonds, less than 3
ggplot(smaller, aes(x = price, color = cut_number(carat, 5))) +
  geom_freqpoly()

#now for the larger diamonds,
#if we use a bin number greater than 3 we get this error: Insufficient data values to produce 4 bins

ggplot(data = large, aes(x = price, color = cut_number(carat, 3))) +
  geom_freqpoly()

#I did not expect that, and yes, it does suprise me :)
