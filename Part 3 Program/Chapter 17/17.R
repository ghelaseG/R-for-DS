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

