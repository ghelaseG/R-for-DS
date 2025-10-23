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
  )

# labs() replace the axis and legend titles

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
mpg %>% view()
?mpg
?fct_reorder

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

view(grid)

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
