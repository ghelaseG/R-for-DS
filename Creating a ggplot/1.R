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
#        Categorical: <char>, Continuous: <dbl> and <int>


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
