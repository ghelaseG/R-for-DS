## CHAPTER 10

# Relational Data with dplyr

#usually data analysis involves more than just one table of data, typically you have many tables of data, and after you combine them, then you search for the answer, these tables are called relational data.

#to work with relational data, you need:
# - mutating joins;
# - filtering joins
# - set operations

#the most common place to find relational data is in a relational database management system (RDBMS).

#dplyr is much easier than SQL for data analysis, however, if you want to do more things is better to use SQL.

library(tidyverse)
library(nycflights13)

#our package contains 4 tibbles, that are related to the flights table:

airlines
airports
planes
weather
#one way to show the relationship between the tables is with a drawing.

#for nycflights13:
#-flights connects to planes via a single variable, tailnum
#-flights connects to airlines through the carrier variable
#-flights connects to airports in two ways: via the origin and dest variables
#-flights connects to weather via origin (the location), and year, months, day and hour (the time).

#Exercises:

#1. Imagine you wanted to draw (approximately) the route each plane flies from its origin to its destination. What variables would you need? What tables would you need to combine?

#Answer:

#I would combine flights with the airports via the origin and destination variables.

#2. I forgot to draw the relationship between weather and airports. What is the relationship and how should it appear in the diagram?

#Answer:

#weather connects to airports via origin (the location)

#3. weather only contains information for the origin(NYC) airports. If it contained weather records for all airports in the USA, what additional relation would it define with flights?

#Answer:

#it would provide the destination for each flight.

#4. We know that some days of the year are "special", and fewer people than usual fly on them. How might you represent that data as a data frame? What would be the primary keys of that table? How would it connect to the existing tables?

#Answer:

#we can try the following:

special <- tribble(
  ~year,       ~month,       ~day,       ~special_day,
   2025,           01,         01,    "New Years Day",
   2024,           12,         25,    "Christmas Day",
)

#primary key will be year,month,day and we can use the variable special_day to join in other data frames.