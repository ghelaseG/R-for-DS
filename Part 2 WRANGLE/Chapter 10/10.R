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

#trial
DiagrammeR::mermaid("
  graph LR
  A-->B
  A-->C
  C-->E
  B-->D
  C-->D
  D-->F
  E-->F
")

DiagrammeR::mermaid("graph LR;
A(Rounded)-->B[Squared];B-->C{A Decision};
 C-->D[Square One];C-->E[Square Two];
 style A fill:#E5E25F;  style B fill:#87AB51; style C fill:#3C8937;
 style D fill:#23772C;  style E fill:#B6E6E6;")

#for the Lahman: Master, Managers and AwardsManagers, another way of building this diagram:
Lahman::People
Lahman::Managers
Lahman::AwardsManagers

#install.packages("remotes")
#remotes::install_github("bergant/datamodelr")

library(datamodelr)
install.packages(datamodelr)
??datamodelr

dm2 <- dm_from_data_frames(list(
  Master = Lahman::People,
  Managers = Lahman::Managers,
  AwardsManagers = Lahman::AwardsManagers
)) %>%
  dm_set_key("Master", "playerID") %>%
  dm_set_key("Managers", c("yearID", "teamID", "inseason")) %>%
  dm_set_key("AwardsManagers", c("playerID", "awardID", "yearID")) %>%
  dm_add_references(
    Managers$playerID == Master$playerID,
    AwardsManagers$playerID == Master$playerID
  )

dm_create_graph(dm2, rankdir = "LR", columnArrows = TRUE) %>%
  dm_render_graph()

library("nycflights13")
dm_f <- dm_from_data_frames(flights, airlines, weather, airports, planes)

graph <- dm_create_graph(dm_f, rankdir = "BT", col_attr = c("column", "type"))
dm_render_graph(graph)


##MUTATING JOINS

#combine variables from 2 tables

flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

view(airlines)
#using left join
flights2 %>%
  select(-origin, -dest) %>%
  left_join(airlines, by = "carrier")

#same result using mutate

flights2 %>%
  select(-origin, -dest) %>%
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

#using mutating joins is better for bigger datasets

#UNDERSTANDING JOINS

#for exp:

x <- tribble(
  ~key,  ~val_x,
     1,    "x1",
     2,    "x2",
     3,    "x3"
)

y <- tribble(
  ~key,  ~val_x,
  1,    "y1",
  2,    "y2",
  3,    "y3"
)

#a join is a way of connecting each row in x to zero, one, or more rows in y.

#INNER JOIN

#simplest type of join is the inner join.
#the output of an inner join is a new data frame that contains the key, the x values, and the y values.

x %>%
  inner_join(y, by = "key")

#unmatched rows are not included in the result

#OUTER JOINS

#an outer join keeps observations that appear in at least one of the tables.

#3 types:
##a left join keeps all observations in x
##a right join keeps all observations in y
##a full join keeps all observations in x and y.

#the most commonly used is left join, you use this whenever you look up additional data from another table.

#DUPLICATE KEYS

#this section explains what happens when the keys are not unique:
#one table has duplicate keys (one-to=many relationships):

x <- tribble(
  ~key,   ~val_x,
     1,     "x1",
     2,     "x2",
     2,     "x3",
     1,     "x4",
)

y <- tribble(
  ~key,   ~val_y,
  1,     "y1",
  2,     "y2"
)

left_join(x, y, by = "key")

x <- tribble(
  ~key,   ~val_x,
  1,     "x1",
  2,     "x2",
  2,     "x3",
  3,     "x4",
)

y <- tribble(
  ~key,   ~val_y,
  1,     "y1",
  2,     "y2",
  2,     "y3",
  3,     "y4"
)

left_join(x, y, by = "key")


#DEFINING THE KEY COLUMNS

#natural join
flights2 %>%
  left_join(weather)

#character vector, by = "x"
flights2 %>%
  left_join(planes, by = "tailnum")

#names character vector, by = c("a" = "b")

flights2 %>%
  left_join(airports, c("dest" = "faa"))

flights2 %>%
  left_join(airports, c("origin" = "faa"))

#Exercises:

#1. Compute the average delay by destination, then join on the airports data frame so you can show the spatial distribution of delays. Here's an easy way to draw a map of the United States:
view(airports)
airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()
#You might want to use the size or color of the points to display the average delay for each airport.

#Answer:

avg_delays <-
  flights %>%
  group_by(dest) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c(dest = "faa"))
avg_delays %>%
  ggplot(aes(lon, lat, colour = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

#2. Add the location of the origin and destination (i.e., the lat and lon) to flights.

#Answer:

view(flights)
airport_edited <- airports %>% select(faa, lat, lon)
view(airport_edited)

#left join keeps all observations in x
flights %>%
  select(year:day, hour, origin, dest) %>%
  left_join(
    airport_edited, by = c("origin" = "faa")
  ) %>%
  left_join(
    airport_edited,
    by = c("dest" = "faa"),
    suffix = c("_origin", "_dest")
  )

#3. Is there a relationship between the age of a plane and its delays?

#Answer:

view(planes)
view(flights)
#we can calculate the mean for arrival and departure delay for each age of a flight, to do this, we can use inner join because it matches pairs of observations whenever their keys are equal:

planes_delays_by_year <- 
  inner_join(flights,
             select(planes, tailnum, plane_year = year),
             by = "tailnum") %>% 
  mutate(age = year - plane_year) %>%
  filter(!is.na(age)) %>%
  group_by(age) %>%
  summarise(
    dep_delay_mean = mean(dep_delay, na.rm = TRUE),
    dep_delay_sd = sd(dep_delay, na.rm = TRUE),
    arr_delay_mean = mean(arr_delay, na.rm = TRUE),
    arr_delay_sd = sd(arr_delay, na.rm = TRUE),
    n_arr_delay = sum(!is.na(arr_delay)),
    n_dep_delay = sum(!is.na(dep_delay))
  )

#let's have a look at the departure delay plot:

ggplot(planes_delays_by_year, aes(age, dep_delay_mean)) +
  geom_point() +
  scale_x_continuous("Age of plane (years)", breaks = seq(0, 60, by = 10)) +
  scale_y_continuous("Mean departure delay (minutes)")

#now let's look at the arrival delayed plot:

ggplot(planes_delays_by_year, aes(age, arr_delay_mean)) +
  geom_point() +
  scale_x_continuous("Age of plane(years)", breaks = seq(0, 60, by = 10)) +
  scale_y_continuous("Mean departure delay (minutes)")

view(planes_delays_by_year)

#4. What weather conditions make it more likely to see a delay?

#Answer:

view(weather)
flight_weather_delays <- flights %>% inner_join(weather, 
                                    by = c("origin" = "origin",
                                           "year" = "year",
                                           "month" = "month",
                                           "day" = "day",
                                           "hour" = "hour",
                                           "time_hour" = "time_hour")
                                    )

#checking the precipitation for the departure delay
flight_weather_delays %>%
  group_by(precip) %>%
  summarise(delay = mean(dep_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = precip, y = delay)) +
  geom_line() + geom_point()

#checking the wind_speed for the arrival delay
flight_weather_delays %>%
  group_by(wind_speed) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  ggplot(aes(wind_speed, delay)) +
  geom_point() +
  geom_line()


view(flight_weather_delays)

#5. What happend on June 13, 2013? Display the spatial pattern of delays, and then use Google to cross-reference with the weather.

#Answer:
view(airports)
june_13_delays <- flights %>%
  filter(year == 2013, month == 6, day == 13) %>%
  group_by(dest) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c("dest" = "faa"))

#map plot
ggplot(june_13_delays, aes(y = lat, x = lon, size = delay, colour = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap() +
  scale_color_viridis_b()
#according to Google: "Storms: Airlines cancel 900 flights, delay thousands"
            
view(june_13_delays)
