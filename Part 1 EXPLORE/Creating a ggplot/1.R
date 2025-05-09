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

#3. What does show.legend = FALSE do? What happens if you remove it? Why do you think I used it earlier in the chapter?

#Answer:

#let's first copy the example
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, colour = drv),
  )
#'show.legend = FALSE removes the category description from the right handside
#'if we remove the show.legend we have displayed on the right handside of the graph the category for every colour
#'it's been used because we had 3 subplots displayed

#4. What does the se argument to geom_smooth() do?

#Answer

#let's first get an example to see:

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_boxplot(mapping = aes(colour = class)) +
  geom_line(se = FALSE)

#se shows a shadow around the line chart

#5. Will these two graphs look different? Why/ why not?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  ) +
  geom_smooth(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  )

#Answer

#there are no differences in visualisation, the only difference is the indentation, although they're both correct, the only issue is how other people can understand thos code


#6. Re-create the R code necessary to generate the following graphs:

#Answer

#1st left

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(se = FALSE)

#1st row right

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, group = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)


#2nd row left

ggplot(data = mpg, mapping = aes(x = displ, y =hwy, group = drv, colour = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)

#2nd row right

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = drv)) +
  geom_smooth(se = FALSE)

#3rd row left

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, linetype = drv)) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = drv,)) +
  geom_smooth()

#3rd row right

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = drv)) 






# STATISTICAL TRANSFORMATIONS


#some example from the book

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

# stat = statistical transformation

#same graph using stat_count() instead of geom_bar()

ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))


#other good example where instead of the constant count on the y axis, we can include our own x and y

demo <- tribble(
  ~a,      ~b,
  "bar_1", 20,
  "bar_2", 30,
  "bar_3", 40,
)

ggplot(data = demo) +
  geom_bar(
    mapping = aes(x = a, y = b), stat = "identity"
  )


#other example using aesthetics

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, y = ..prop.., group = 1)
  )


#we can also draw some attention to the statistical transformation in our code

ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun.y = median
  )


#Exercises:

#1. What is the default geom associated with stat_summary()? How could you rewrite the previous plot to use that geom function instead of the stat function?

#Answer

#checking the cheatsheet for ggplot2 at https://posit.co/wp-content/uploads/2022/10/data-visualization-1.pdf, we can see that the matching one is geom_pointrange()

#the reason we use stat = "summary" is because it will be the same if we do stat_summary(geom = "pointrange") similar to geom_pointrange(stat = "summary")
ggplot(data = diamonds) +
  geom_pointrange(mapping = aes(x = cut, y = depth), stat = "summary")


#to replicate the same plot we can do the following:
#fun.min and fun.max manipulate the y axis in our ggplot2

ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth), 
    stat = "summary",
    fun.min = min,
    fun.max = max,
    fun = median
  )

#to see how fun.min and max works, you can run the following: 
ggplot2::layer_data(last_plot())


#2. What does geom_col() do? How is it different to geom_bar()?

#Answer:

#running in the terminal ?geom_col we get the following description:
##There are two types of bar charts: geom_bar() and geom_col(). geom_bar() makes the height of the bar proportional to the number of cases in each group (or if the weight aesthetic is supplied, the sum of the weights). If you want the heights of the bars to represent values in the data, use geom_col() instead. geom_bar() uses stat_count() by default: it counts the number of cases at each x position. geom_col() uses stat_identity(): it leaves the data as is.

#3. Most geoms and stats come in pairs that are almost always used in concert. Read through the documentation and make a list of all the pairs. What do they have in common?

#Answer:

#Checking the reference website of ggplot2 at https://ggplot2.tidyverse.org/reference/ we can see the following (this is not an exhaustive list):

##geom_bar() geom_col() stat_count()
##geom_bin_2d() stat_bin_2d()
##geom_boxplot() stat_boxplot()


#4. What variables does stat_smooth() compute? What parameters control its behavior?

#Answer:

##stat_smooth() calculate the following variables:
# after_stat(y) or after_stat(x)
# Predicted value.
# 
# after_stat(ymin) or after_stat(xmin)
# Lower pointwise confidence interval around the mean.
# 
# after_stat(ymax) or after_stat(xmax)
# Upper pointwise confidence interval around the mean.
# 
# after_stat(se)
# Standard error.

##The parameters that control its behavior are: mapping, data, position, method, formula, se, na.rm, orientation, show.legend, inherit.aes, geom, stat, n, span, fullrange, xseq, level, method.args


#5. In our proportion bar chart, we need to set group = 1. Why? In other words what is the problem witht these two graphs?

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..))

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = colour, y = ..prop..)
  )

#Answer:

#to find our answer we can simply run in the terminal ?geom_bar, scroll down or search internal for group and you get the following:

#Description : "The group aesthetic is by default set to the interaction of all discrete variables in the plot. This choice often partitions the data correctly, but when it does not, or when no discrete variable is used in the plot, you will need to explicitly define the grouping structure by mapping group to a variable that has a different value for each group."
#Details : "For most applications the grouping is set implicitly by mapping one or more discrete variables to x, y, colour, fill, alpha, shape, size, and/or linetype"

#also we can simply see that the graph has got no sense, all the bars being the same but with different data.
ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, y = ..prop.., group = 1)
  )

#and

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, y = ..prop..)
  )





# POSITION ADJUSTMENTS

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, colour = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))

#trying to use fill with other variable

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))


#we can use "identity", "dodge", "fill"

#for example, position = "identity", this is not helpful for bars, but it is good for 2D geoms, like points

ggplot(data = diamonds,
       mapping = aes(x = cut, fill = clarity)
       ) +
  geom_bar(alpha = 1/5, position = "identity")

ggplot(
  data = diamonds,
  mapping = aes(x = cut, colour = clarity)
) +
  geom_bar(fill = NA, position = "identity")


#next example, position = "fill", this works like stacking, but makes each set of stacked bars the same height

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity),
           position = "fill"
)

#3rd example, position = "dodge", places overlapping objects directly beside one another

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = clarity),
    position = "dodge"
)

#4th example, position = "jitter", going back to our first example, we can see that we had 234 observations and only 126 of them were displayed in our graph. This position helps adding a small random noise to each point, spreading them.

ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy),
    position = "jitter"
  )

#Exercises:

#1. What is the problem with this plot? How could you improve it?

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() 

#Answer:
#we can add some color and position to understand better our plot

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point(data = mpg,mapping = aes(colour = hwy), position = "jitter") 

#2. What parameters to geom_jitter() control the amount of jittering?

# Answer:

ggplot(mpg, aes(cty, hwy)) +
  geom_jitter(width = 0.9, height = 0.9)
#by playing with the numbers of width and height, we can see that amount of jittering is changing

#3. Compare and contrast geom_jitter() with geom_count().

# Answer:

# geom_jitter: The jitter geom is a convenient shortcut for geom_point(position = "jitter"). It adds a small amount of random variation to the location of each point, and is a useful way of handling overplotting caused by discreteness in smaller datasets.

# geom_count: This is a variant geom_point() that counts the number of observations at each location, then maps the count to point area. It useful when you have discrete data and overplotting.

#example with geom_jitter
ggplot(mpg, aes(cty, hwy)) +
  geom_jitter(width = 0.5, height = 0.3)

#example with geom_count
ggplot(mpg, aes(cty, hwy)) +
  geom_count() +
  scale_size_area()

#4. What's the default position adjustment for geom_boxplot()? Create a visualization of the mpg dataset that demonstrates it.

ggplot(data = mpg, aes(x = cty, y = hwy, group = 1)) +
  geom_boxplot()



# COORDINATE SYSTEMS

#coord_flip()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

#coord_quickmap()

nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

#coord_polar()

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = FALSE,
    width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()


# Exercises:

#1. Turn a stacked bar chart into a pie chart using coord_polar().

bar <- ggplot(data = mpg) +
  geom_bar(mapping = aes(x = manufacturer, fill = manufacturer),
           show.legend = FALSE)

bar + coord_polar()

#2. What does labs() do? Read the documentation.

# Answer:

# Running in the terminal ?labs(): Good labels are critical for making your plots accessible to a wider audience. Always ensure the axis and legend labels display the full variable name. Use the plot title and subtitle to explain the main findings. It's common to use the caption to provide information about the data source. tag can be used for adding identification tags to differentiate between multiple plots.

#for example:

p <- ggplot(mtcars, aes(mpg, wt, colour = cyl)) + geom_point()
p + labs(colour = "Cylinders")
p + labs(x = "New x label")

#3. What's the difference between coord_quickmap() and coord_map()?

#Answer:

#coord_map() projects a portion of the earth, which is approximately spherical, onto a flat 2D plane using any projection defined by the mapproj package. Map projections do not, in general, preserve straight lines, so this requires considerable computation. coord_quickmap() is a quick approximation that does preserve straight lines. It works best for smaller areas closer to the equator.

#Both coord_map() and coord_quickmap() are superseded by coord_sf(), and should no longer be used in new code. All regular (non-sf) geoms can be used with coord_sf() by setting the default coordinate system via the default_crs argument. See also the examples for annotation_map() and geom_map().

#4. What does the following plot tell you about the relationship between city and highway mpg? Why is coord_fixed() important? What does geom_abline() do?

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()

#Answer:

#There is no relationship between city and highway mpg.
#coord_fixed() helps with the aspect ration of the graph, to better understand the output
#geom_abline() add reference lines (sometimes called rules) to a plot, either horizontal, vertical, or diagonal (specified by slope and intercept). These are useful for annotating plots.




# THE LAYERED GRAMMAR OF GRAPHICS

ggplot(data = <DATA>) +
  <GEOM_FUNCTION>(
    mapping = aes(<MAPPING>),
    stat = <STAT>,
    position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>

