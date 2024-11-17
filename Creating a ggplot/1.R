library(tidyverse)

# displ = engine size
# hwy = fuel efficiency
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))


# install.packages("psych")
# install.packages("knitr")
# second example
# load data to a dataframe called fifa teams
library(psych)
library(knitr)


fifa_teams <- read_csv("fifa_teams_cleaned.csv")
View(fifa_teams)
summary(fifa_teams)
# describe(fifa_teams) %>%
#   select("Mean" = "mean", "SD" = "sd", "Median" = "median", "Min" = "min", "Max" = "max")
#   kable(digits = 1)

table(fifa_teams$`Whole team average age`, fifa_teams$date)
ggplot(data = fifa_teams) +
  geom_point(mapping = aes(x = 'Whole team average age', y = date))

# Exercises
#1. Run ggplot(data = mpg). What do you see?
ggplot(data = mpg)
#Answer: empty screen

#2. How many rows are in mtcars? How many columns?
nrow(mtcars)
ncol(mtcars)
#Answer: 32 rows, 11 columns

#3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg
#Answer:drv - the type of drive train, where f = front-wheel drive, r = rear wheel drive, 4 = 4wd

#4. Make a scatterplot of hwy versus cyl.
#Notes: hwy - highway miles per gallon
#       cyl - number of cylinders
  
ggplot(data = mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy))

#5. What happens if you make a scatterplot of class versus drv? Why is the plot not useful?

ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv))
#Answer: scatterplot does not suit our chosen data.
#        important trends hidden.



#map the colors of your points to the class variable to reveal the class of each car
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = class))

#using size for a discrete variable is not advised
ggplot(data = mpg) + 
  geom_point((mapping = aes(x = displ, y = hwy, size = class)))

#map the class to the alpha aesthetic, which controls the transparency of the points, or the shape of the points
# Top
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# Bottom
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))


#we can set the aesthetic properties of the geom manually
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), colour = "blue")

#Info: R has 25 built-in shapes that are identified by numbers
## the hollow shapes (0 - 14) have a border determined by colour
## the solid shapes (15 - 18) are filled with colour
## the filled shapes (21 - 24) have a border of colour and are filled with fill


#Exercises:

#1. What's gone wrong with this code? Why are the points not blue?
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy, colour = "blue")
  )

#Answer: the parenthesis should close before colour = "blue"


#2. Which variables in mpg are categorical? Which variables are continuous? (Hint: type ?mpg to read the documentation for the dataset). How can you see this information when you run mpg?
?mpg
mpg
#library(psych)
#describe(mpg)
#let's first check the rows and cols
dim(mpg)
#we can use tibble
#mpg_tb <- mpg %>% as_tibble_col()
print(mpg, max_extra_cols = 11)

#Answer: Categorical variables: manufacturer, model, trans, drv, fl, class
#        Continuous variables : displ, year, cyl, cty, hwy
#        To see this information, you can run ?mpg and it will show you the type of column we have, for example model is just the name but in much safer way, to make sure our dataframe stored correctly character, or integer, we can run print(mpg, max_extra_cols = 11) and we can simply see under each column the type, for exp: <chr>, or <dbl>, or <int>
#        Categorical: <char>, Continuous: <dbl> and <int> (dbl <- float)


#3. Map a continuous variable to colour, size, and shape. How do these aesthetics behave differently for categorical versus continuous variables?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cty, y = hwy, color = year))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = cty, y = hwy, size = year))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = cty, y = hwy, shape = year))
#Error occurred |^|
# OR
#ggplot(mpg, aes(x = cty, y = hwy, color = year)) +
#  geom_point()

# Answer: 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = fl, color = drv))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = fl, size = drv))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = fl, shape = drv))

#Answer: to find out how continuous variables behave differently than categorical, we can map some of the categorical columns too
#        We get an error for continuous variables when we try to use shape, and error for categorical when we use size


#4. What happens if you map the same variable to multiple aesthetics?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cty, y = hwy, color = year, size = displ))

#Answer: it's not practical

#5. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)

?geom_point(shape)

#Answer: Use the stroke aesthetic to modify the width of the border, the shapes that works with stroke are 21-25
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)


#6. What happens if you map an aesthetic to something other than a variable name, like aes(color = displ < 5)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = cty, y = hwy, color = displ < 5))

#Answer: it becomes a boolean


##to find out about a function, you can run ?function_name in the console

#FACETS

#to add additional variables is with aesthetics
#another way is to split your plot into 'facets', subplots that each display one subset of the data

#example
#the first argument should be a data structure, created with ~
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

#to facet on the combination of 2 variables, those have to be separated by ~
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

#or
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

#Exercises


#1. What happens if you facet on a continuous variable?

#Answer:

#let's first see what happens on a categorical variable
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ model)
#then on a continuous variable
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cty)

##the continuous variable converts to a categorical variable, the plot contains a facets for each value.
##also multiple panels are created based on the distinct values of that value.


#2. What do the empty cells in a plot with facet_grid(drv ~ cyl) mean? How do they relate to this plot?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = manufacturer))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

#Answer:

#in order to understand this let's compare the 2 plots
##as we're trying to plot a categorical (drv = <chr>) and a continuous (cyl = <int>), we have no observations (no data to display) as we need numerical data 
##we can identify it in the bigger plot, where we have no points.


#3. What plots does the following code make? What does . do?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

#Answer:

#the '.' helps facet in row(1st plot) or column(2nd plot)


#4. Take the first faceted plot in this section:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

#let's first see the colored plot
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = 'blue')

#' What are the advantages to using faceting instead of the color aesthetic? 
#' What are the disadvantages? 
#' How might the balance change if you had a larger dataset?

#Answer:

#The advantages to using faceting instead of the color aesthetic are as follows:
#'you have many subplots and can compare individually in a simple way, instead of checking the color for each variable
#'also you can be using facet_wrap and get rid of the empty subplots (empty grid elements) as they're not shown

#The disadvantages are:
#'in case we have a large dataset, we can not observe much as the subplots(facets) will be too small
#'or another disadvantage will be if we try to compare the values

#If we have a larger dataset:
#'it is difficult to check overlapping points with colour, so will need to use facets
#'but with facets, we can not compare easily as will have multiple smaller subplots


#5. Read ?facet_wrap. What does nrow do? What does ncol do? What other options control the layout of the individual panels? Why doesn't facet_grid() have nrow and ncol variables?

#Answer:

#'nrow and ncol shows the number of rows and columns
#'Other options include: scales, shrink, labeller, as.table, drop, dir, strip.position, axes, axis.labels
#'facet_grid() does not need nrow and ncol as you already mention them in the "formula"


#6. When using facet_grid() you should usually put the variable with more unique levels in the columns. Why?

#Answer:

#'there will be more space for columns if the plot is horizontally
#'we can see this by taking the example from exercise 3
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)




# GEOMETRIC OBJECTS

#left
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

#right
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

#you cannot change the shape of a line, but you could set the linetype
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

#?mpg
#we can make it more clear by overlaying the lines on top of the raw data and then colouring everything
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv, colour = drv))

#there are many others extensions that you can find at: https://exts.ggplot2.tidyverse.org/

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, colour = drv),
    show.legend = FALSE
  )

#to display multiple geoms in the same plot, add multiple geom functions 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))


#to avoid repetition you can write the code in this way:
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

#it's better to use mapping in geom function as it will treat them as local mappings for the layer
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = class)) +
  geom_smooth()

#we can use filter() to specify different data for each layer
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = class)) +
  geom_smooth(
    data = filter(mpg, class == "subcompact"),
    se = FALSE
  )

#Exercises

#1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?

#Answer:

#let's first see all of them
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_boxplot(mapping = aes(colour = class)) +
  geom_line(se = FALSE)

ggplot(data = mpg, aes(x = cty)) +
  geom_histogram(aes(y = ..density..), bins = 30, fill = "skyblue", color = "black") +
  geom_density(color = "red", size = 1) + # Add a density curve
  geom_line(stat = "density", color = "blue", size = 1)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_area(mapping = aes(colour = class)) +
  geom_line(colour = "blue", size = 1)

# the one that I'll use the most will is the histogram, as it is more relevant and easy to understand.

#2. Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions:

ggplot(
  data = mpg, mapping = aes(x = displ, y = hwy, colour = drv)
) + geom_point() +
  geom_smooth()




