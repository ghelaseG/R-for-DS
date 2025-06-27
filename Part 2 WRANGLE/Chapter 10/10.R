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
#we can try to make a plot:
flights_edited <- flights %>%
  inner_join(select(airports, origin = faa, origin_lat = lat, origin_lon = lon),
             by = "origin") %>%
  inner_join(select(airports, dest = faa, dest_lat = lat, dest_lon = lon),
             by = "dest")

#we choose the first 100 flights in the next plot
flights_edited %>% slice(1:100) %>% ggplot(aes(
  x = origin_lon, xend = dest_lon,
  y = origin_lat, yend = dest_lat
)) +
  borders("state") +
  geom_segment(arrow = arrow(length = unit(0.1, "cm"))) +
  coord_quickmap() +
  labs(y = "Latitude", x = "Longitude")


?borders
?coord_quickmap
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


## KEYS

#there are 2 types of keys:
#1. primary key: uniquely identifies an observation in its own table.
#2. foreign key: uniquely identifies an observation in another table.

#a variable can be both a primary key and a foreign key, for exp:origin is a primary key in the weather data, and foreign key in the airport table.

planes %>%
  count(tailnum) %>%
  filter(n > 1)
weather %>%
  count(year, month, day, hour, origin) %>%
  filter(n >1)
#in our data there's a many to many relationship between airlines and airports.

#Exercises:

#1. Add a surrogate key to flights.

#Answer:
# "if a table lacks a primary key, it's sometimes useful to add one with mutate() and row_number(). That makes it easier to match observations (surrogate key)" - source book
# "A surrogate key is a unique, system-generated identifier added to a database table to serve as the primary key" - source Google
# "A surrogate key in a database is a unique identifier for either an entity in the modeled world or an object in the database" - source Wikipedia

#?glimpse - we use glimpse to see all the columns
?row_number
flights %>%
  arrange(year, month, day, sched_dep_time, carrier, flight) %>%
  mutate(flight_nr = row_number()) %>%
  glimpse()

#2. Identify the keys in the following datasets:
#a. Lahman::Batting
#b. babynames::babynames
#c. nasaweather::atmos
#d. fueleconomy::vehicles
#e. ggplot2::diamonds
#(you might need to install some packages and read some documentation.)

#Answer:

#a.
view(Lahman::Batting)
#in order to understand the keys, we need to know more about the database, you can find more info here: https://cran.r-project.org/web/packages/Lahman/Lahman.pdf
Lahman::Batting %>%
  count(playerID, yearID, stint) %>%
  filter(n > 1)
#stint - player’s stint (order of appearances within a season)

#b.
babynames::babynames %>%
  count(year, sex, name) %>%
  filter(n > 1) %>%
  nrow()
#install.packages("babynames")

#c.
nasaweather::atmos %>%
  count(lat, long, year, month) %>%
  filter(n > 1)
#install.packages("nasaweather")

#d.
fueleconomy::vehicles %>%
  count(id) %>%
  filter(n > 1)
#install.packages("fueleconomy")

#e.
view(ggplot2::diamonds)
#there's no primary key here, as for example, these diamonds got the same details.
### 129 0.91 Fair H SI2 64.4 57.0 2763 6.11 6.09 3.93 
### 130 0.91 Fair H SI2 65.7 60.0 2763 6.03 5.99 3.95

#3. Draw a diagram illustrating the connections between the Batting, Master, and Salaries tables in the Lahman package. Draw another diagram that shows the relationship between master, Managers, and AwardsManagers.
#How would you characterise the relationship between the Batting, Pitching, and Fielding tables?

#Answer:

#Note: the Master table is now the People table in the Lahman dataset.

Lahman::People
Lahman::Batting
Lahman::Salaries
#install.packages("DiagrammeR")
library("DiagrammeR")
?DiagrammeR

DiagrammeR::grViz(" digraph {
                  graph [overlap = true,pad=0.5, ranksep=0.525, nodesep=1, labelloc='t' , label='Master                         Batting                           Salaries']
                  splines=false;
                  node [shape = box3d, fixedsize = true, fontsize = 9, constraint=false]
                  
                  
                  A [label = 'playerID']
                  B [label = 'playerID']
                  C [label = 'playerID']
                  
                  node [shape = rectangle, fixedsize = true]
                  
                  1 [label = 'yearID']
                  2 [label = 'teamID']
                  3 [label = '...']
                  4 [label = '...']
                  5 [label = 'yearID']
                  6 [label = 'stint']
                  7 [label = '...']
                  
                  edge[style=invis];

                  1 -> 2 -> A -> 3
                  B -> 4
                  C -> 5 -> 6 -> 7
                  
                  edge[style=solid, constraint=false];
                  
                  B -> 4 [arrowhead=none, arrowtail=none] B -> A B-> C
                  
                  1 -> 2 [arrowhead=none, arrowtail=none]; 2 -> A [arrowhead=none, arrowtail=none] A -> 3 [arrowhead=none, arrowtail=none]
                  
                  C -> 5 [arrowhead=none, arrowtail=none] 5 -> 6 [arrowhead=none, arrowtail=none] 6 -> 7 [arrowhead=none, arrowtail=none]

                  }", height = 333)

#reference: https://graphviz.org/docs/graph/
#or we can use: https://cran.r-project.org/web/packages/DiagrammeR/DiagrammeR.pdf
#this is just an example, we can build many more, using mermaid(javascript) diagram etc.



