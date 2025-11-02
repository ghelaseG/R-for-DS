# Graphics for Communication with ggplot2

library(tidyverse)
library(ggplot2)

# Label

# with good labels we can transition from exploratory to expository graphic.
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = paste(
      "Fuel efficiency generally decreases with engine size"
    )
  )
#we are using title to explain in short the result
#we can also use subtitle and caption (text at the bottom right)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = paste(
      "Fuel efficiency generally decreases with engine size"
    ),
    subtitle = paste(
      "Two seaters (sports cars) are an exception because of their light weight"
    ),
    caption = "Data from fueleconomy.gov"
  )# labs() replace the axis and legend titles

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  )
?plotmath

#we can also use mathematical equations
df <- tibble(
  x = runif(10),
  y = runif(10)
)
ggplot(df, aes(x, y)) +
  geom_point() +
  labs(
    x = quote(sum(x[i] ^ 2, i == 1, n)),
    y = quote(alpha + beta + frac(delta, theta))
  )
# Exercises:
#1. Create one plot on the fuel economy data with customized title, subtitle, caption, x, y and colour labels.
#2. The geom_smooth() is somewhat misleading because the hwy for large engines is skewed upwards due to the inclusion of light-weight sports cars with big engines. Use your modeling tools to fit and display a better model.
#3. Take an exploratory graphic that you've created in the last month, and add informative titles to make it easier tfor others to understand.

# Answers:
#1.
mpg %>% summarize(x = fct_reorder(class, hwy),
                  y = hwy)
mpg %>% summarise(x = unique(manufacturer))

ggplot(mpg, aes(x = fct_reorder(manufacturer, cty), y = cty, colour = class, group = class)) +
  geom_point() +
  coord_flip() +
  labs(
    x = "15 x Car Manufacturer Names",
    y = "City Miles Per Gallon",
    colour = "Class Of Car",
    title = paste("Subcompact / Compact Cars tend to have Higher Fuel Consumption in the City"),
    subtitle = paste("Honda, Volkswagen and Toyota are the top 3"),
    caption = "Data from fueleconomy.gov"
  ) +
  theme_minimal()

#2.
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE)

ggplot(mpg2, aes(displ, lhwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE)

# the winner/best fitted model is the following code:
mpg2 <- mpg %>% 
  filter(hwy <= 40) %>% 
  mutate(lhwy = log2(hwy), ldispl = log2(displ))

mod2 <- lm(ldispl ~ lhwy, data = mpg2)

grid2 <- mpg2 %>% 
  add_residuals(mod2) %>% 
  add_predictions(mod2, "lhwy")

ggplot(grid2, aes(ldispl, lhwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE, method = "lm")

#trial part1
library(modelr)

mod1 <- lm(displ ~ hwy, data = mpg)

grid <- mpg %>% 
  add_residuals(mod1) %>% 
  add_predictions(mod1, "hwy")

ggplot(grid, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_line(data = grid, colour = "red")

# or
ggplot(grid, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE, method = "lm")

# trial part 2
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE, span = 1.8)

# trial part 3 - using linear model
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE, method = "lm")

# trial part 4 - making some adjustments to the linear model
mod2 <- lm(ldispl ~ lhwy, data = mpg2)

grid2 <- mpg2 %>% 
  add_residuals(mod2) %>% 
  add_predictions(mod2, "lhwy")

ggplot(grid2, aes(ldispl, lhwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE, method = "lm")

#3.
#we are using the last graph as an example:
mpg2 <- mpg %>% 
  filter(hwy <= 40) %>% 
  mutate(lhwy = log2(hwy), ldispl = log2(displ))

mod2 <- lm(ldispl ~ lhwy, data = mpg2)

grid2 <- mpg2 %>% 
  add_residuals(mod2) %>% 
  add_predictions(mod2, "lhwy")
view(mpg)
ggplot(grid2, aes(ldispl, lhwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE, method = "lm") +
  labs(
    x = "Engine Displacement",
    y = "Highway Miles Per Gallon",
    colour = "Car Type",
    title = paste(
      "Having A Bigger Engine Results In Higher Consumption"),
    subtitle = paste(
      "2 Seater and SUV's are Leading the Chart"),
    caption = "Data from fueleconomy.gov"
    ) +
  theme_linedraw()

# Annotations

#it is good to label groups / individual observations.
#we can do this using geom_text() (this is useful for labeling)

# example:
best_in_class <- mpg %>% 
  group_by(class) %>% 
  filter(row_number(desc(hwy)) == 1)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_text(aes(label = model), data = best_in_class)

#we can also use geom_label:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_label(
    aes(label = model),
    data = best_in_class,
    nudge_y = 2,
    alpha = 0.5
  )

#to avoid overlapping we can use ggrepel:
install.packages("ggrepel")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_label_repel(
    aes(label = model),
    data = best_in_class
  )

class_avg <- mpg %>% 
  group_by(class) %>% 
  summarise(
    displ = median(displ),
    hwy = median(hwy)
  )

ggplot(mpg, aes(displ, hwy, colour = class)) +
  ggrepel::geom_label_repel(aes(label = class),
    data = class_avg,
    size = 0,
    label.size = 0,
    segment.color = NA
  ) +
  geom_point() +
  theme(legend.position = "none")

label <- mpg %>% 
  summarise(
    displ, max(displ),
    hwy = max(hwy),
    label = paste(
      "Increasing engine size is \nrelated to decreasing fuel economy."
    )
  )

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(
    aes(label = label),
    data = label,
    vjust = "top",
    hjust = "right"
  )

label <- tibble(
  displ = Inf,
  hwy = Inf,
  label = paste(
    "Increasing engine size is \nrelated to decreasing fuel economy."
  )
)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(
    aes(label = label),
    data = label,
    vjust = "top",
    hjust = "right"
  )

#instead of \n we can use stringr::str_wrap()
"Increasing engine size related to decreasing fuel economy." %>% 
  stringr::str_wrap(width = 40) %>% 
  writeLines()

#other useful geom in ggplot2:
## geom_hline() and geom_vline() to add reference lines
## geom_rect() to draw a rectangle
## geom_segment() to draw attention with an arrow.

# Exercises:
#1. Use geom_text() with infinite positions to place text at the four corners of the plot.
#2. Read the documentation for annotate(). How can you use it to add a text label to a plot without having to create a tibble?
#3. How do labels with geom_text() interact with faceting? How can you add a label to a single facet? How can you put a different label in each facet? (Hint: think about the underlying data.)
#4. What arguments to geom_label() control the appearance of the background box?
#5. What are the four arguments to arrow()? How do they work? Create a series of plots that demonstrate the most important options.

# Answers:
?tibble
#example:
a <- 1:5
tibble(a, a * 2)

label_exercise1 <- tibble(
  displ = c(-Inf, -Inf, Inf, Inf),
  hwy = c(Inf, -Inf, Inf, -Inf),
  hjust = c('left', 'left', 'right', 'right'),
  vjust = c('top', 'bottom', 'top', 'bottom'),
  text = c("Top left", "Bottom left", "Top right", "Bottom right")
)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_text(aes(
    label = text,
    hjust = hjust,
    vjust = vjust
  ), data = label_exercise1)

#2.
?annotate
p <- ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point()
p + annotate("text", x = 4, y = 25, label = "Some text")

#3.
library(gapminder)
view(gapminder)
gapminder %>% 
  ggplot(aes(year, pop, group = country)) +
  geom_point(aes(colour = country), show.legend = FALSE) +
  facet_wrap(~continent) +
  geom_text(aes(label = country)) #interaction not looking good

#adding a label to a single faceting:
label123 <- tibble(
  year = Inf,
  pop = Inf,
  label = paste(
    "A massive change in life expectancy for the last 60 years."
  )
)

gapminder %>% 
  ggplot(aes(year, pop)) +
  geom_point(aes(colour = country), show.legend = FALSE) +
  geom_text(
    aes(label = label),
    data = label123,
    vjust = 'top',
    hjust = 'right'
  ) +
  facet_wrap(~continent)

# put different label in each facet
label321 <- tibble(
  year = Inf,
  pop = Inf,
  continent = unique(gapminder$continent),
  text = str_c("Increase in life expectancy in ", continent)
)

gapminder %>% 
  ggplot(aes(year, pop)) +
  geom_point(aes(colour = country), show.legend = FALSE) +
  geom_text(
    aes(label = text),
    data = label321,
    vjust = 'top',
    hjust = 'right'
  ) +
  facet_wrap(~continent)

#we can try using ggrepel, and I think this will be the best option:
best_in_life_expectancy <- gapminder %>% 
  group_by(country) %>% 
  filter(row_number(desc(lifeExp)) == 1)

ggplot(gapminder, aes(year, lifeExp)) +
  geom_point(aes(colour = country), show.legend = FALSE) +
  geom_point(size = 3, shape = 3, data = best_in_life_expectancy) +
  facet_wrap(~continent) +
  ggrepel::geom_label_repel(
    aes(label = country), max.overlaps = 33,
    data = best_in_life_expectancy
  )

#4.
?geom_label

#> label.padding: Amount of padding around label. Defaults to 0.25 lines.
#> label.r: Radius of rounded corners. Defaults to 0.15 lines.
#> label.size: Size of label border, in mm.

#5.
?arrow
arrow(angle = 30, length = unit(0.25, "inches"),
      ends = "last", type = "open")
arrow()
str(arrow(type = "closed"), give.attr=FALSE)

"""
angle: The angle of the arrow head in degrees (smaller numbers produce narrower, pointier arrows). Essentially describes the width of the arrow head.

length: A unit specifying the length of the arrow head (from tip to base).

ends: One of 'last', 'first', or 'both', indicating which ends of the line to draw arrow heads.

type: One of 'open' or 'closed' indicating whether the arrow head should be a closed triangle.
"""
mtcars %>% 
  ggplot(aes(hp, cyl)) +
  geom_point() +
  geom_segment(x = 203, xend = 304, y = 6, yend = 8, arrow = arrow())

mtcars %>% 
  ggplot(aes(hp, cyl)) +
  geom_point() +
  geom_segment(x = 203, xend = 304, y = 6, yend = 8, arrow = arrow(angle = 12, type = "closed", ends = "both"))

# Scales

# with scales you can manage your plots data values and many another things.
# for example, the next 2 graphs are the same:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()

# Axis Ticks and Legend Keys

#labels controls the text label and breaks controls the position of the ticks.
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5))

#we can also set the labels to NULL - useful for maps
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)

#we can use breaks to highlight observations
presidential %>% 
  mutate(id = 33 + row_number()) %>% 
  ggplot(aes(start, id)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_x_date(
    NULL,
    breaks = presidential$start,
    date_labels = "'%y"
  )# we can also use date_breaks() - this takes a string "2days" etc.

# Legend Layout

#we can use a theme for our legend:
base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class))
base + theme(legend.position = "left")
base + theme(legend.position = "top")
base + theme(legend.position = "right") #default
base + theme(legend.position = "bottom")             
base + theme(legend.position = "none")

#we can also control the legends display using guides()
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "bottom") +
  guides(
    color = guide_legend(
      nrow = 1,
      override.aes = list(size = 4)
    )
  )

# Replacing a Scale

#continuous position and colour scales are the ones that we are replacing.
#after log-transforming the data, we can easily rescale everything so we can have on both axes the main values.
#previous examples:
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d()

#now the new example will be:
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d() +
  scale_x_log10() +
  scale_y_log10()

#ColorBrewer: (http://colorbrewer2.org/ documentation website)
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_color_brewer(palette = "Set1")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_color_brewer(palette = "Set1")

#another good example, using this in presidential parties:
presidential %>% 
  mutate(id = 33 + row_number()) %>% 
  ggplot(aes(start, id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(
    values = c(Republican = "red", Democratic = "blue")
  )

#another usage is of scale_color_viridis()
df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)
ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed()

ggplot(df, aes(x, y)) +
  geom_hex() +
  viridis::scale_fill_viridis() +
  coord_fixed()

#Exercises:
#1. Why doesn't the following code override the default scale?
ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_fill_gradient(low = "white", high = "red") +
  coord_fixed()
#because we should of used scale_fill_gradient instead of "scale_color_gradient".

#2. What is the first argument to every scale? How does it compare to labs()?
#for the majority of scale, the argument can be "Additional parameters passed on to the scale type"
#and for the labs: A list of new name-value pairs. The name should be an aesthetic.

#3. Change the display of the presidential terms by:
#a. Combining the two variants shown above.
#b. Improving the display of the y-axis.
#c. Labeling each term with the name of the president.
#d. Adding informative plot labels.
#e. Placing breaks every four years (this is trickier than it seems!).
presidential %>% 
  mutate(id = 33 + row_number(),
         name_president = fct_inorder(str_c(name, "(", id,")"))) %>% 
  ggplot(aes(start, name_president, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = name_president)) +
  labs(
    title = "Presidential Terms In the United States of America",
    subtitle = "Terms period: 1953 to 2021",
    colour = "Type of Party",
    x = "Presidency Period",
    y = "US Presidents"
  ) +
  scale_x_date(date_breaks = "4 years",
               date_labels = "%y'") +
  scale_color_manual(
    values = c(Republican = "red", Democratic = "blue")
  ) +
  theme(
    panel.grid.minor = element_blank(),
    axis.ticks.y = element_blank()
  ) +
  theme_minimal()

#4. Use override.aes to make the legend on the following plot easier to see:
ggplot(diamonds, aes(carat, price)) +
  geom_point(aes(color = cut), alpha = 1/20) +
  guides(colour = guide_legend(override.aes = list(alpha = 1)))

# Zooming
#We can control the plot limits in different ways, either by adjusting what data is plotted, setting the limits in each scale, or setting xlim and ylim in coord_cartesian().
ggplot(mpg, mapping =aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 7), ylim = c(10, 30))

mpg %>% 
  filter(displ >= 5, displ <= 7, hwy >= 10, hwy <= 30) %>% 
  ggplot(aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()

suv <- mpg %>% filter(class == "suv")
compact <- mpg %>% filter(class == "compact")

ggplot(suv, aes(displ, hwy, color = drv)) +
  geom_point()

ggplot(compact, aes(displ, hwy, color = drv)) +
  geom_point()

#sharing the scales over the plots
x_scale <- scale_x_continuous(limits = range(mpg$displ))
y_scale <- scale_y_continuous(limits = range(mpg$hwy))
col_scale <- scale_color_discrete(limits = unique(mpg$drv))

ggplot(suv, aes(displ, hwy, color = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale

ggplot(compact, aes(displ, hwy, color = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale
#or we could of used faceting.

#Themes
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_bw() #linedrew, classic, dark, gray, light, minimal or void

#Saving Your plots
#we can save the most recent plots with ggsave() or knitr.

#Figure Sizing
#figure size in R Markdown is one of the hardest part.
#the main options are fig.width, fig.height, fig.asp, out.width and out.height(check book to see the right set-up by the author)

#great idea to name code chunks with figures.

