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

#having a quick search on google, we can see that people tend to want more a 1 carat diamond because: "commands a significantly higher price due to the psychological value of reaching the "full carat" mark."

