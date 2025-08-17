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
# apply(X, MARGIN, FUN, ..., simplify = TRUE)
# MARGIN : a vector giving the subscripts which the function will be applied over. E.g., for a matrix 1 indicates rows, 2 indicates columns, c(1, 2) indicates rows and columns. Where X has named dimnames, it can be a character vector selecting dimension names.

#whenever we get 1 (rows) or 2 (col), we can do this with the following:

row_mean <- vector("double", length(x))
for (i in seq_along(nrow(df))) {
  row_mean[[i]] <- mean(df[i, ])
}

col_mean <- vector("double", length(x))
for (i in seq_along(ncol(df))) {
  col_mean[[i]] <- mean(df[i, ])
}

#2.

col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- fun(df[[i]])
  }
  out
}

col_summary(df, mean)
#let's try our own function:

numeric_column_summary <- function(df, fun) {
  out <- vector("logical", length(df))
  for (i in seq_along(df)) {
    out[i] <- is.numeric(df[[i]])
  }
  indexes <- which(out)
  print("Indexes:") 
  print(indexes)
  n <- sum(out)
  outp <- vector("double", n)
  for (i in seq_along(indexes)) {
    outp[[i]] <- fun(df[[indexes[[i]]]])
    print("Outpi:") 
    print(outp[[i]])
    print("Here:") 
    print(df[[indexes[[i]]]])
  }
  names(outp) <- names(df)[indexes]
  outp
}
numeric_column_summary(iris, mean)


# The Map Functions

#the pattern of looping over a vector, doing something to each element and saving the results is very common.

map() #makes a list
map_lgl() #makes a logical vector
map_int() #makes an integer vector
map_dbl() #makes a double vector
map_chr() #makes a character vector

#the important thing is that you solve the problem that you're working on, not write the most concise and elegant code.
#the important part of using functions like map() is not speed, but clarity.
#for example:
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10),
)

map_dbl(df, mean)

map_dbl(df, median)

map_dbl(df, sd)

#few differences between map_*() and col_summary():

##> all purrr functions are implemented in C
##> .f - the function to apply, can be a formula, a character vector or an integer vector
##> map_*() uses ... to pass along additional arguments to .f

map_dbl(df, mean, trim = 0.5)
z <- list(x = 1:3, y = 4:5)
map_int(z, length)

# Shortcuts

#for exp, if we want to fit a linear regression to each group of our dataset

#we split into 3 pieces (each value of cyl) and fit the lm
models <- mtcars %>% 
  split(.$cyl) %>% 
  map(function(df) lm(mpg ~ wt, data = df))

#with purrr you can use a one sided formula:
models <- mtcars %>% 
  split(.$cyl) %>% 
  map(~lm(mpg ~ wt, data = .))

#we use . as a pronoun - it refers to the current list element

#when we are looking at many models, we can first extract the r squared.
models %>% 
  map(summary) %>% 
  map_dbl(~.$r.squared)

#we can use a shorter version:
models %>% 
  map(summary) %>% 
  map_dbl("r.squared")

#we can select elements by position
x <- list(list(1, 2, 3), list(4, 5, 6), list(7, 8, 9))
x %>% map_dbl(2)


#Base R

#> lapply() is similar to map() - except the .f function
#> sapply() is a wrapper around lapply() - this one is problematic as you never know what kind of output you'll get by using it
x1 <- list(
  c(0.27, 0.37, 0.57, 0.91, 0.20),
  c(0.90, 0.94, 0.66, 0.63, 0.06),
  c(0.21, 0.18, 0.69, 0.38, 0.77)
)
x2 <- list(
  c(0.50, 0.72, 0.99, 0.38, 0.78),
  c(0.93, 0.21, 0.65, 0.13, 0.27),
  c(0.39, 0.01, 0.38, 0.87, 0.34)
)

threshold <- function(x, cutoff = 0.8) x[x > cutoff]
x1 %>% sapply(threshold) %>% str()
x2 %>% sapply(threshold) %>% str()

#> vapply() - safe alternative to sapply() because you can define the type and can produce matrices
vapply(list, function, FUN.VALUE = type, ...)
vapply(df, is.numeric, logical(1)) equivalent to map_lgl(df, is.numeric)

# Exercises:

#1. Write code that uses one of the map functions to:
#a. Compute the mean of every column in mtcars.
#b. Determine the type of each column in nycflights13::flights.
#c. Compute the number of unique values in each column of iris.
#d. Generate 10 random normals for each of μ = -10, 0, 10, and 100.

#2.How can you create a single vector that for each column in a data frame indicates whether or not it's a factor?

#3. What happens when you use the map functions on vectors that aren't lists? What does map(1:5, runif) do? Why?

#4.What does map(-2:2, rnorm, n=5) do? Why? What does map_dbl(-2:2, rnorm, n=5) do? Why?

#5. Rewrite map(x, function(df) lm(mpg ~ wt, data = df)) to eliminate the anonymous function.


# Answers:

#1.
#a)
?map
map_dbl(mtcars, mean)

#b)
map_chr(nycflights13::flights, typeof)

#c)
map_dbl(iris, n_distinct)

#d)
map(c(-10, 0, 10, 100), rnorm, n = 10)

#2.
#source stackoverflow
mtcars$am <- as.factor(mtcars$mpg)

mtcars[ , "cyl"] <- as.factor(mtcars[, 'cyl'])
str(mtcars)

map_lgl(mtcars, is.factor)

# ?str
# str(options())
# ?options
# options("width")

#3.
?runif
#> These functions provide information about the uniform distribution on the interval from min to max.
#> runif generates random deviates.

?map
#> The map functions transform their input by applying a function to each element of a list or atomic vector and returning an object of the same length as the input.

#?~
  
testing123 <- map(1:3, ~rnorm(x)) 
typeof(testing123)

#4. 
map(-2:2, rnorm, n = 5) #returns a list of 5 numeric vectors
#?rnorm #random generation for the normal distribution
map_dbl(-2:2, rnorm, n = 5)

?map_dbl
#we get an error because:
#map_dbl() return an atomic vector of the indicated type (or die trying). For these functions, .f must return a length-1 vector of the appropriate type.

#5.
map(x, function(df) lm(mpg ~ wt, data = df))

map(x, ~df, lm(mpg ~ wt, data = mtcars))


# Dealing with Failure

#> When you use the map functions to repeat many operations, the chances are that one of those operations will fail.
#> "how do you ensure that one bad apple doesn't ruin the whole barrel?"
#> we can use a function called: safely() - takes a function and returns a modified version (the modified function will never throw an error), instead you'll get a list with:
#> original result (if error then NULL) and
#> an error object (if operation is successful then NULL)
#> 
#> try() function is similar
#> 
#> we can see this using log():

safe_log <- safely(log)
str(safe_log(10)) #function succeeds, we get: $ result: num 2.3 $ error : NULL

str(safe_log("a")) #function fails, we get: $ result: NULL $ error :List of 2

#we can use safely() with map:
x <- list(1, 10, "a")
y <- x %>% map(safely(log))
str(y)

# we can use purrr:transpose() to work with 2 lists:

y <- y %>% transpose()
str(y)

is_ok <-y$error %>% map_lgl(is_null)
x[!is_ok]

y$result[is_ok] %>% flatten_dbl()

# an alternative to safely() is possibly()

x <- list(1, 10, "a")
x %>%  map_dbl(possibly(log, NA_real_))

# or quietly() - captures printed output, messages and warnings:
x <- list(1, -1)
x %>% map(quietly(log)) %>% str()


# Mapping over Multiple Arguments

#> we can use map2() and pmap() functions to iterate over multiple arguments

mu <- list(5, 10, -3)
mu %>% 
  map(rnorm, n = 5) %>% 
  str()

#if you also want to vary the standard deviation, you have to:
sigma <- list(1, 5, 10)
seq_along(mu) %>% 
  map(~rnorm(5, mu[[.]], sigma[[.]])) %>% 
  str()

#instead, we can simply use map2 function, simpler and quicker:

map2(mu, sigma, rnorm, n = 5) %>% str()

#map2 is a wrapper around a for loop:

map2 <- function(x, y, f, ...) {
  out <- vector("list", length(x))
  for (i in seq_along(x)) {
    out[[i]] <- f(x[[i]], y[[i]], ...)
  }
  out
}

#instead of using map3, map4 etc, we can simply use pmap, which takes a lis tof arguments:

n <- list(1, 3, 5)
args1 <- list(n, mu, sigma)
args1 %>% 
  pmap(rnorm) %>% 
  str()

#with pmap is better to name the arguments:
args2 <- list(mean = mu, sd = sigma, n = n)
args2 %>% 
  pmap(rnorm) %>% 
  str()

# since the arguments are all the same length, we can store them in a data frame:

params <- tribble(
  ~mean, ~sd, ~n,
    5,   1,   1,
  10,    5,   3,
  -3,   10,   5
)

params %>% 
  pmap(rnorm)

# when the code gets complicated, a data frame is a good approach

# Invoking different functions

#there's one more step up in complexity - varying the arguments and the function itself

f <- c("runif", "rnorm", "rpois")
param <- list(
  list(min = -1, max = 1),
  list(sd = 5),
  list(lambda = 10)
)

#we can do that using invoke_map():

invoke_map(f, param, n = 5) %>%  str()

#we can use tribble() to make creating these matching pairs easier:

sim <- tribble(
  ~f,        ~params,
  "runif",   list(min = -1, max = 1),
  "rnorm",   list(sd = 5),
  "rpois",   list(lambda = 10)
)

sim %>% 
  mutate(sim = invoke_map(f, params, n = 10))

# Walk

#walk is an alternative to map, it is used when you want to call a function for its side effects

x <- list(1, "a", 3)

x %>% 
  walk(print)

#walk2 and pwalk is more useful

#if you had a list of plots and a vector of filenames, you could use pwalk to save each file to the corresponding location on disk:

library(ggplot2)
plots <- mtcars %>% 
  split(.$cyl) %>% 
  map(~ggplot(., aes(mpg, wt)) + geom_point())
paths <- stringr::str_c(names(plots), ".pdf")
pwalk(list(paths, plots), ggsave, path = tempdir())
paths
plots
getwd()


#Other patterns of for loops

#purrr provides other functions as well, these are not so much used, but is good to know about it.

#Predicate Functions

#a number of functions work with predicate functions that returns either TRUE or FALSE

#keep and discard() keep elements of the input where the predicate is TRUE or FALSE

iris %>% 
  keep(is.factor) %>% 
  str()

iris %>% 
  discard(is.factor) %>% 
  str()

#some and every determine of the preicate is true of any of the elements

x <- list(1:5, letters, list(10))

x %>% 
  some(is_character)

x %>% 
  every(is_vector)

#detect finds the first element where the predicate is true, detect_index returns its position

x <- sample(10)
x

x %>% 
  detect(~ . > 5)

x %>% 
  detect_index(~ . > 5)

#head_while and tail_while take elements from the start or end

x %>% 
  head_while(~ . > 5)

x %>% 
  tail_while(~ . > 5)

# Reduce and Accumulate

#sometimes you want to reduce a complex list to a simple list, for exp:

dfs <- list(
  age = tibble(name = "John", age = 30),
  sex = tibble(name = c("John", "Mary"), sex = c("M", "F")),
  trt = tibble(name = "Mary", treatment = "A")
)

dfs %>%  reduce(full_join)

#we can also find the intersection:

vs <- list(
  c(1, 3, 5, 6, 10),
  c(1,2,3,7,8,10),
  c(1,2,3,4,8,9,10)
)

vs %>%  reduce(intersect)

x <- sample(10)
x

x %>%  accumulate(`+`)

# Exercises:

#1. Implement your own version of every() using a for loop. Compare it with purrr:every(). What does purrr's version do that your version doesn't?

#2. Create an enhanced col_sum() that applies a summary function to every numeric column in a data frame.

#3. A possible base R equivalent of col_sum() is:
col_sum3 <- function(df, f) {
  is_num <- sapply(df, is.numeric)
  df_num <- df[, is_num]
  
  sapply(df_num, f)
}
#But it has a umber of bugs as illustrated with the following inputs:

df <- tibble(
  x = 1:3,
  y = 3:1,
  z = c("a", "b", "c")
)
# OK
col_sum3(df, mean)
# Has problems: don't always return numeric vector
col_sum3(df[1:2], mean)
col_sum3(df[1], mean)
col_sum3(df[0], mean)
#What causes the bugs?

#Answers:

#1.
every() #the version behind is:
function (.x, .p, ...) 
{
  .p <- as_predicate(.p, ..., .mapper = TRUE, .allow_na = TRUE)
  val <- TRUE
  for (i in seq_along(.x)) {
    val <- val && .p(.x[[i]], ...)
    if (is_false(val)) {
      return(FALSE)
    }
  }
  val
}

#let's find out what every is doing:
?every #returns TRUE when .p is TRUE for all elements.

#exp
xyz <- list(0:10, 5.5)
x |> every(is.numeric)
x |> every(is.integer) #|> is the base R "pipe" operator.

# .p	
## A predicate function (i.e. a function that returns either TRUE or FALSE) specified in one of the following ways:
  
##  A named function, e.g. is.character.

## An anonymous function, e.g. ⁠\(x) all(x < 0)⁠ or function(x) all(x < 0).

## A formula, e.g. ~ all(.x < 0). You must use .x to refer to the first argument). Only recommended if you require backward compatibility with older versions of R.


my_every <- function(.x, fun, ...) {
  for (i in seq_along(.x)) {
    val[[i]] <- fun(.x[[i]], ...)

  }
  all(val, na.rm = TRUE) #we use 'all' to combine all boolean values https://stackoverflow.com/questions/28559785/r-check-if-a-list-of-true-false-values-evaluate-to-true
}

my_every(xyz, is.numeric)
