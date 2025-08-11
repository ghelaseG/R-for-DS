# Iteration with purrr

#we are learning about imperative programming and functional programming

#imperative programming: we use for loops and while loops
#functional programming: offers tools to extract out this duplicated code

library(tidyverse)

# For Loops

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df
median(df$a)
median(df$b)
median(df$c)
median(df$d)

#instead we could use a for loop

output <- vector("double", ncol(df)) #output
for (i in seq_along(df)) {           #sequence  
  output[[i]] <- median(df[[i]])     #body
}

output

#every for loop has 3 components:

#> output: output <- vector("double", length(x))
#> you must always allocate sufficient space for the output, if you grow the for loop at each iteration using c(), your for loop will be very slow.
#vector has 2 arguments: "logical", "integer", "double", "character" and the length

#> sequence: i in seq_along(df)
#> determines what to loop over: will assign i to a different value using seq_along() - similar to 1:length(l)

y <- vector("double", 0)
seq_along(y)
1:length(y)

#> body: output[[i]] <- median(df[[i]])

# Exercises:

#1. Write for loops to:
#a. Compute the mean of every column in mtcars.
#b. Determine the type of each column in nycflights13::flights.
#c. Compute the number of unique values in each column of iris.
#d. Generate 10 random normals for each of μ = -10, 0, 10, and 100.
#Think about the output, sequence, and body before you start writing the loop.

#2. Eliminate the for loop in each of the following examples by taking advantage of an existing function that works with vectors:

out <- ""
for (x in letters) {
  out <- stringr::str_c(out, x)
}

x <- sample(100)
sd <- 0
for (i in seq_along(x)) {
  sd <- sd + (x[i] - mean(x)) ^ 2
}
sd <- sqrt(sd / (length(x) - 1))

x <- runif(100)
out <- vector("numeric", length(x))
out[1] <- x[1]
for (i in 2:length(x)) {
  out[i] <- out[i - 1] + x[i]
}

#3. Combine your function writing and for loop skills:
#a. Write a for loop that prints() the lyrics to the children's song "Alice the Camel".
#b. Convert the nursery rhyme "Ten in the Bed" to a function. Generalize it to any number of people in any sleeping structure.
#c. Convert the song "99 Bottles of Beer on the Wall" to a function. Generalize to any number of any vessel containing any liquid on any surface.

#4. It's common to see for loops that don't preallocate the output and instead increase the length of a vector at each step:

output <- vector("integer", 0)
for (i in seq_along(x)) {
  output <- c(output, lengths(x[[i]]))
}
output
#How does this affect performance? Desing and execute an experiment.

# Answers:

#1.a)

df <- mtcars
output <- vector("double", ncol(df))
names(output) <- names(df)
for (i in seq_along(names(df))) {
  output[[i]] <- mean(df[[i]])
}
output

#b)
df1 <- nycflights13::flights
output <- vector("list", ncol(df1))
names(output) <- names(df1)
for (i in seq_along(names(df1))) {
  output[[i]] <- typeof(df1[[i]])
}
output

#c)
df2 <- iris
output <- vector("double", ncol(df2))
names(output) <- names(df2)
for (i in names(df2)) {
  output[[i]] <- n_distinct(df2[[i]])
}
output

#d)
n <- 10
mu <- c(-10,0,10,100)
output <- vector("list", length(mu))
for (i in seq_along(output)) {
  output[[i]] <- rnorm(n, mean = mu[i])
}
output

#2. 

#a) 
out <- ""
for (x in letters) {
  out <- stringr::str_c(out, x)
}
out

stringr::str_c(letters, collapse = "")
?str_c

#b)
x <- sample(100)
sd <- 0
for (i in seq_along(x)) {
  sd <- sd + (x[i] - mean(x)) ^ 2
}
sd <- sqrt(sd / (length(x) - 1))

sd(x) #or
sqrt(sum((x - mean(x)) ^ 2) / (length(x) - 1))

#c)
x <- runif(100)
out <- vector("numeric", length(x))
out[1] <- x[1]
for (i in 2:length(x)) {
  out[i] <- out[i - 1] + x[i]
}
out

cumsum(x)

#3.
#a)
#Alice the Camel lyrics
"""
Alice the camel has five humps,
Alice the camel has five humps,
Alice the camel has five humps,
Go, Alice, go!


Alice the camel has four humps,
Alice the camel has four humps,
Alice the camel has four humps,
Go, Alice, go!


Alice the camel has three humps,
Alice the camel has three humps,
Alice the camel has three humps,
Go, Alice, go!

Alice the camel has two humps,
Alice the camel has two humps,
Alice the camel has two humps,
Go, Alice, go!

Alice the camel has one hump,
Alice the camel has one hump,
Alice the camel has one hump,
Go, Alice, go!

Alice the camel has no humps,
Alice the camel has no humps,
Alice the camel has no humps,
‘Cause Alice is a horse, of course!
"""

output <- c("five", "four", "three", "two", "one", "no")
?cat
?rep
for (i in output) {
  cat(str_c("Alice the camel has ", rep(i, 3), " humps.", collapse = "\n" ), "\n")
  if (i == "no") {
    cat("'Cause Alice is a horse, of course!\n")
  } else {
    cat("Go, Alice, go!\n")
  }
  cat("\n")
}

#b)
# Ten In The Bed Lyrics
"""
There were ten in the bed
And the little one said,
'Roll over! Roll over!'
So they all rolled over
And one fell out

There were nine in the bed
And the little one said,
'Roll over! Roll over!'
So they all rolled over
And one fell out

There were eight in the bed
And the little one said,
'Roll over! Roll over!'
So they all rolled over
And one fell out

There were seven in the bed
And the little one said,
'Roll over! Roll over!'
So they all rolled over
And one fell out

There were six in the bed
And the little one said,
'Roll over! Roll over!'
So they all rolled over
And one fell out

There were five in the bed
And the little one said,
'Roll over! Roll over!'
So they all rolled over
And one fell out

There were four in the bed
And the little one said,
'Roll over! Roll over!'
So they all rolled over
And one fell out

There were three in the bed
And the little one said,
'Roll over! Roll over!'
So they all rolled over
And one fell out

There were two in the bed
And the little one said,
'Roll over! Roll over!'
So they all rolled over
And one fell out

There was one in the bed
And the little one said,
'Good night!'
"""

output <- c("ten", "nine", "eight", "seven", "six", "five", "four", "three", "two", "one")

for (i in output) {

  if (i == "one") {
    cat(str_c("There was ", i, " in the bed\n"))
    cat("And the little one said,\n")
    cat("'Good night!'")
  } else {
    cat(str_c("There were ", i, " in the bed\n"))
    cat("And the little one said,\n")
    cat("'Roll over! Roll over!'\n")
    cat("So they all rolled over\n")
    cat("And one fell out\n")
  }
  cat("\n")
}

#c)
#99 Bottles of Beer on the Wall Lyrics
"""
99 bottles of beer on the wall, 99 bottles of beer.
Take one down and pass it around, 98 bottles of beer on the wall.

98 bottles of beer on the wall, 98 bottles of beer.
Take one down and pass it around, 97 bottles of beer on the wall.

97 bottles of beer on the wall, 97 bottles of beer.
Take one down and pass it around, 96 bottles of beer on the wall.

96 bottles of beer on the wall, 96 bottles of beer.
Take one down and pass it around, 95 bottles of beer on the wall.

.... ...... ......

3 bottles of beer on the wall, 3 bottles of beer.
Take one down and pass it around, 2 bottles of beer on the wall.

2 bottles of beer on the wall, 2 bottles of beer.
Take one down and pass it around, 1 bottle of beer on the wall.

1 bottle of beer on the wall, 1 bottle of beer.
Take one down and pass it around, no more bottles of beer on the wall.

No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall.
"""

library(stringr)

combined_vectors <- Map(c, sample(0:99, 1), sample(c("bowls", "bottles", "vases"), 1), sample(c("water", "beer", "juice", "coffee", "soda", "wine", "cocktail"), 1), sample(c("floor", "ceiling", "wall", "roof"), 1))

lyrics_song <- function(x, combined_vectors) {
  for (i in seq(x, 0)) {
    if (i == 0) {
    cat(glue::glue("No more {combined_vectors[[1]][2]} of {combined_vectors[[1]][3]} on the {combined_vectors[[1]][4]}, no more {combined_vectors[[1]][3]} of {combined_vectors[[1]][3]}.\n Go to the store and buy some more, {x} {combined_vectors[[1]][2]} of {combined_vectors[[1]][3]} on the {combined_vectors[[1]][4]}."), fill = FALSE)
    } else {
    cat(glue::glue("{i} {if (i == 1) str_sub(combined_vectors[[1]][2], end = -2) else combined_vectors[[1]][2]} of {combined_vectors[[1]][3]} on the {combined_vectors[[1]][4]}, {i} {if (i == 1) str_sub(combined_vectors[[1]][2], end = -2) else combined_vectors[[1]][2]} of {combined_vectors[[1]][3]}.\n Take one down and pass it around, {if (i == 1) 'no more' else i - 1} bottles of {combined_vectors[[1]][3]} on the {combined_vectors[[1]][4]}.\n \n \n"))
    }
  }
}  

lyrics_song(combined_vectors[[1]][1], combined_vectors)

#extras:
# output <- sample(0:99, 1)
# vessel <- sample(c("bowl", "bottle", "vase"), 1)
# liquid <- sample(c("water", "beer", "juice", "coffee", "soda", "wine", "cocktail"), 1)
# surface <- sample(c("floor", "ceiling", "wall", "roof"), 1)
#?glue
#?cat
#typeof(combined_vectors)
#combined_vector(combined_vectors[[1]][2])

#4.

output <- vector("integer", 0)
for (i in seq_along(x)) {
  output <- c(output, lengths(x[[i]]))
}
output

x <- rerun(1000, sample(sample(10, 1)))
microbenchmark::microbenchmark(
  non_allocate = {
    output <- vector("integer", 0)
    for (i in seq_along(x)) {
      output <- c(output, length(x[[i]]))
    }
  },
  allocate = {
    output <- vector("integer", 0)
    for (i in seq_along(x)) {
      output[i] <- length(x[[i]])
    }
  }
)


# For Loop Variations

#there are 4 variations on the basic theme of the for loop:

##> modifying an existing object
##> looping over names or values
##> handling outputs and sequences of unknown length


# Modifying an Existing Object

#sometimes we can use a for loop to modify an existing object

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10),
)

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

#we can solve this with a for loop
## output, sequence, body:

for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}


# Looping patterns

#there are 3 basic ways to loop over a vector:
##the basic way is looping over the numeric indices with for (i in seq_along(xs)), and extracting the value with x[[i]], but there are 2 other ways:

# loop over the elements: for (x in xs) - useful when plotting or saving a file
# loop over the names: for (nm in names(xs)) - useful using the name in a plot title or a filename

results <- vector("list", length(x))
names(results) <- names(x)

for (i in seq_along(x)) {
  name <- names(x)[[i]]
  value <- x[[i]]
}

# ?names
# names(islands)


# Unknown Output Length

means <- c(0, 1, 2)

output <- double()
for (i in seq_along(means)) {
  n <- sample(100, 1)
  output <- c(output, rnorm(n, means[[i]]))
}
str(output)

#not efficient because in each iteration the data is copied from the previous one - quadratic (On^2) behaviour (meaning that a loop with 3x elements, would take nine (3^2) times as long to run)

#one solution is to save the results in a list, and then combine into a single vector

out <- vector("list", length(means))
for (i in seq_along(means)) {
  n <- sample(100, 1)
  out[[i]] <- rnorm(n, means[[i]])
}
str(out)
str(unlist(out)) #we've flatten a list of vectors into a single vector, we can use purrr::flatten_dbl()

#this pattern occurs in other places too:

##> if we generate a long string, instead of pasteing each iteration, we can save the output in a single character vector (paste(output, collapse =""))
##> if we generate a big data frame, instead of rbinding in each iteration, save the output in a list then use dplyr::bind_rows(output)


# Unknown sequence length

#we can use a while loop, made out of a condition and a body

while(condition) {
  # body
}

#you can rewrite any for loop as a while loop, but not the other way around

for (i in seq_along(x)) {
  # body
}

# Equivalent to
i <- 1
while ( i <= length(x)) {
  # body
  i <- i + 1
}

#how many tries to get 3 heads in a row:

flip <- function() sample(c("T", "H"), 1)

flips <- 0
nheads <- 0

while (nheads < 3) {
  if (flip() == "H") {
    nheads <- nheads + 1
  } else {
    nheads <- 0
  }
  flips <- flips + 1
}
flips

#use while loops when the number of iteration is unknown.

# Exercises:

#1. Imagine you have a directory full of CSV files that you want to read in. You have their paths in a vector, files <- dir("data/", pattern = "\\.csv$", full.names = TRUE), and now want to read each one with read_csv(). Write the for loop that will load them into a single data frame.

#2. What happens if you use for (nm in names(x)) and x has no names? What if only some of the elements are names? What if the names are not unique?

#3. Write a function that prints the mean of each numeric column in a data frame, along with its name. For example, show_mean(iris) would print:

show_mean(iris)
#> Sepal.Length: 5.84
#> Sepal.Width: 3.06
#> Petal.Length: 3.76
#> Petal.Width: 1.20

#(Extra challenge: what function did I use to make sure that the numbers lined up nicely, even though the variable names had different lengths?)

#4. What does this code do? How does it work?

trans <- list(
  disp = function(x) x * 0.0163871
  am = function(x) {
    factor(x, labels = c("auto", "manual"))
  }
)
for (var in names(trans)) {
  mtcars[[var]] <- trans[[var]](mtcars[[var]])
}

#Answers:

#1. 
files <- dir("data/", pattern = "\\.csv$", full.names = TRUE)
?read_csv

read_csv(file, id = "file")
#or

output <- vector("list", length(files))

for (x in files) {
  output[[x]] <- read_csv(files[[x]]) 
}
bind_rows(output)

#2.
x <- c(1, 2, 3)
print(names(x))
for (nm in names(x)) {
  print(x[[nm]])
}

x <- c(a = 1, b = "gg", "gg")
names(x)
print(names(x))
for (nm in names(x)) {
  print(x[[nm]])
}

x <- c(a = 1, a = "gg", b = "gg")
names(x)
print(names(x))
for (nm in names(x)) {
  print(x[[nm]])
}

# If x has no names, nothing happens.
# If only some of the elements are named, we get the error: Error in x[[nm]] : subscript out of bounds
# If the names are not unique, it is still running normally.

#3.

#we can use different methods to select the numeric column in a data frame:
#source github
show_mean <- function(df, digits = 2) {
  maxstr <- max(str_length(names(df)))
  print(maxstr)
  for (nm in names(df)) {
    if (is.numeric(df[[nm]])) {
      cat(
        str_c(
          str_pad(
          str_c(nm, ":"), maxstr + 1L, side = "right"),
              format(mean(df[[nm]]), digits = digits, nsmall = digits),
              sep = " "
        ),
        "\n"
      )
    }
  }
}
show_mean(iris) 

#trial 1 - DONE!!!!!
df <- iris

xyz <- max(nchar(names(df[ , purrr::map_lgl(df, is.numeric)])))

for(i in names(df[ , purrr::map_lgl(df, is.numeric)])) {
  cat(str_c(str_pad(str_c(i, ":"), width = xyz + 2, side = "right", use_width = TRUE), round(mean(df[[i]]), 2), sep = " "), "\n")
}  

#now we can add all of this in a function

show_mean123 <- function(x) {
  xyz <- max(nchar(names(df[ , purrr::map_lgl(df, is.numeric)])))
  
  for(i in names(df[ , purrr::map_lgl(df, is.numeric)])) {
    cat(str_c(str_pad(str_c(i, ":"), width = xyz + 2, side = "right", use_width = TRUE), round(mean(df[[i]]), 2), sep = " "), "\n")
  }
}
show_mean123(iris)

?str_pad

#to achieve the same result we can use str_pad or sprintf

#practice str_pad
#stringsss <- "Sepal.Length:"
#str_pad(stringsss, width = max(str_length(stringsss)) + 1, side = "both", pad = " ", use_width = TRUE)

#trial 2
show_means <- function(x, output) {
  numeric_col <- x[ , purrr::map_lgl(x, is.numeric)]
  for (i in seq_along(x)) {
    cat(paste0(names(numeric_col)[i], ": ", round(mean(numeric_col[[i]]), 2)), "\n")
  }
}
show_means(df)

PadRight <- function(s, x) {
  require(stringr)
  sprintf("%*s", -str_length(s)-x, s)
}

PadRight(show_means(df), 3)

#trial 3

df <- iris
show_means(numeric_col <- df[ , purrr::map_lgl(df, is.numeric)])
output <- vector("logical", length(x))
iris_means <- function(x, output) {
  numeric_col <- df[ , purrr::map_lgl(df, is.numeric)]
  meansss <- colMeans(numeric_col)
  print(meansss, sep = "\n")
  cat(paste0(names(x)[1], ": ", round(mean(x[[1]]), 2)), fill = TRUE)
  cat(meansss[[2]], sep = "\n", fill = TRUE, labels = c("Sepal.Width:"))
  cat(meansss[[3]], sep = "\n", fill = TRUE, labels = c("Petal.Length:"))
  cat(meansss[[4]], sep = "\n", fill = TRUE, labels = c("Petal.Width:")) 
}

iris_means(df, output)

#4.

trans <- list(
  disp = function(x) x * 0.0163871,
  am = function(x) {
    factor(x, labels = c("auto", "manual"))
  }
)
for (var in names(trans)) {
  mtcars[[var]] <- trans[[var]](mtcars[[var]])
}

#Cubic inches per hour to Litres per hour, for manual and auto cars: 0.0163871

trans[["disp"]](mtcars[["disp"]])
help("mtcars")
#[, 3]	disp	Displacement (cu.in.)
#[, 9]	am	Transmission (0 = automatic, 1 = manual)

#n cars, engine displacement refers to the total volume of air and fuel that the engine's cylinders can hold, measured in cubic centimeters (cc) or liters. It essentially indicates the size of the engine and is a key factor in determining its power and fuel consumption ( source google )


# For Loops Versus Functionals

## for loops are not as important in R as they are in other languages, because R is a functional programming language
#for example:

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10),
)

output <- vector("double", length(df))
for (i in seq_along(df)) {
  output[[i]] <- mean(df[[i]])
}
output

#you want to do the mean
col_mean <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- mean(df[[i]])
  }
  output
}

#then you want to do the median and standard deviation

col_median <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- median(df[[i]])
  }
  output
}

col_sd <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- mean(df[[i]])
  }
  output
}

#instead of:
f1 <- function(x) abs(x - mean(x)) ^ 1
f2 <- function(x) abs(x - mean(x)) ^ 2
f3 <- function(x) abs(x - mean(x)) ^ 3
#we can do:
f <- function(x, i) abs(x - mean(x)) ^ i #reducing the code and bugs

#we can do the same with previous col mean median and sd
col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- fun(df[[i]])
  }
  out
}

col_summary(df, median)
col_summary(df, mean)

#the idea of passing a function to another function is powerful

#Exercises:

#1. Read the documentation for apply(). In the second case, what two for loops does it generalize?

#2. Adapt col_summary() so that it only applies to numeric columns. You might want to start with an is_numeric() function that returns a logical vector that has a TRUE corresponding to each numeric column.

#Answers:
#1.
help("apply")
