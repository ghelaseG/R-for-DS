### FACTORS with forcats

#factors are used to work with categorical variables
#useful when you want to display character vectors in a non-alphabetical order

#historically, factors were much easier to work with than characters

#good websites:

## https://simplystatistics.org/posts/2015-07-24-stringsasfactors-an-unauthorized-biography/
## https://notstatschat.tumblr.com/post/124987394001/stringsasfactors-sigh


library(tidyverse)
library(forcats)

x1 <- c("Dec", "Apr", "Jan", "Mar")

x2 <- c("Dec", "Apr", "Jam", "Mar")

sort(x1)

#we can fix this with a factor

month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

#now we can create a factor
y1 <- factor(x1, levels = month_levels)
y1
sort(y1)

y2 <- factor(x2, levels = month_levels)
y2
#with an error:

y2 <- parse_factor(x2, levels = month_levels)
y2
factor(x1)

f1 <- factor(x1, levels = unique(x1))
f1

f2 <- x1 %>% factor() %>% fct_inorder()
f2

levels(f2)


#General Social Survey

#gss cat - is a sample of data from the General Social Survey, a long running US survey conducted by the independent research organization NORC at the University of Chicago

gss_cat

gss_cat %>% 
  count(race)

ggplot(gss_cat, aes(race)) +
  geom_bar()

ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

#Exercises:

#1. Explore the distribution of rincome (reported income). What makes the default bar chart hard to understand? How could you improve the plot?

#Answer:

gss_cat %>% 
  ggplot(aes(rincome)) +
  geom_bar()

gss_cat %>% 
  mutate(rincome = fct_relevel(rincome, c("No answer", "Don't know", "Refused", "Not applicable"))) %>% 
  ggplot(aes(rincome)) +
  geom_bar() +
  coord_flip()

?fct_relevel

#2. What is the most common relig in this survey? What's the most common partyid?

#Answer:

gss_cat %>% 
  count(relig) %>% 
  arrange(-n)

#protestant

gss_cat %>% 
  count(partyid) %>% 
  arrange(-n)

#Independent

#3. Which relig does denom (denomination) apply to? How can you find out with a table? How can you find out with a visualization?

#Answer:

gss_cat %>% 
  count(relig, denom) %>% 
  filter(denom == "No denomination")

levels(gss_cat$denom)

view(gss_cat)

gss_cat %>% 
  filter(!denom %in% c("No answer", "Other", "Don't know", "Not applicable", "No denomination")) %>% 
  count(relig)

gss_cat %>% 
  count(relig, denom) %>% 
  ggplot(aes(x = relig, y = denom, size = n)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90))

#Modifying factor order

#it's often useful to change the order of the factor levels in a visualisation.
#let's examine the average nr of hours spent watching TV per day across religions:

relig <- gss_cat %>% 
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig, aes(tvhours, relig)) + geom_point()

#we can use fct_reorder() to reorder the levels of relig

ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

#we could rewrite this:

relig %>% 
  mutate(relig = fct_reorder(relig, tvhours)) %>% 
  ggplot(aes(tvhours, relig)) +
  geom_point()

#we can create a similar plot looking at how average age varies across reported income level:

rincome <- gss_cat %>% 
  group_by(rincome) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(
  rincome,
  aes(age, fct_reorder(rincome, age)) 
) + geom_point()

# we can use fct_relevel() - it takes a factor f and then any number of levels that you want to move to the front of the line:

ggplot(
  rincome,
  aes(age, fct_relevel(rincome, "Not applicable")) 
) +
  geom_point()

#another type of reordering is useful when you are coloring the lines on a plot - fct_reorder2(), reorders by the y value with the largest x values

by_age <- gss_cat %>% 
  filter(!is.na(age)) %>% 
  group_by(age, marital) %>% 
  count() %>% 
  mutate(prop = n / sum(n))

by_age
ggplot(by_age, aes(age, prop, color = marital)) +
  geom_line(na.rm = TRUE)

ggplot(
  by_age,
  aes(age, prop, color = fct_reorder2(marital, age, prop))
) +
  geom_line() +
  labs(color = "marital")

gss_cat %>% 
  mutate(marital = marital %>%  fct_infreq() %>%  fct_rev()) %>% 
  ggplot(aes(marital)) +
  geom_bar()


#Exercises:

#1. There are some suspiciously high numbers in tvhours. Is the mean a good summary?

#Answer:

view(gss_cat$tvhours)
view(mean(gss_cat$tvhours, na.rm = TRUE))
#considering that someone left their tv on for 24 hours, it is not a good summary.
summary(gss_cat$tvhours)

#2. For each factor in gss_cat identify whether the order of the levels is arbitrary or principled.

#Answer:

?sapply
fct_gss <- gss_cat[sapply(gss_cat, is.factor)]
lapply(fct_gss, levels)
#rincome is the only one with principled order

#3. Why did moving "Not applicable" to the front of the levels move it to the bottom of the plot?

#Answer:

#it is just an illusion as the plot is flipped.