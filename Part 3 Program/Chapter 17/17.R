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
  for (i in c(rev(seq_len(x)), 0)) {
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




