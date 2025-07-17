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
