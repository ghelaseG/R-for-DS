# CHAPTER 4 :

# Workflow: Scripts


#RUNNING CODE

#Shortcuts:

# Ctrl /Cmd - Shift - N -> create a new tab
# Ctrl /Cmd - Enter     -> executes the current R expression in the console where the cursor is located at

#for example:
library(dplyr)
library(nycflights13)

not_cancelled <- flights %>%
  filter(!is.na(dep_delay) , !is.na(arr_delay))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay))

# Ctrl /Cmd - Shift - S -> executes the complete script in one step

#!Tip:
#start the script with the packages that you need. If sharing the code, they can see what packages they need to install
#!Note:
#never include install.packages() or setwd() - (set working directory) - it is antisocial


# RSTUDIO DIAGNOSTICS

x y <- 10 #hover over the cross and the red squiggly line

3 == NA



