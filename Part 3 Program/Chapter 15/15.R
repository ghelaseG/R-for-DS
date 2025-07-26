#Functions

#3 advantages of writing a function (!copy-paste):

##naming a function something easy to understand what the code does
##if requirement change, you only make changes in one place
##eliminate the chance of making incidental mistakes when copy and paste

#we are going to learn about how to write functions and style our code (is like a correct punctuation)

#When should you write a function?
       
#whenever you copied and pasted a block of code more than twice
#for exp:

df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df$a <- (df$a - min(df$a, na.rm = TRUE)) /
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) /
  (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) /
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) /
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))

#here we made a mistake, at df$b

#to write a function, you need to first analyze the code, how many inputs does it have?

(df$c <- (df$c - min(df$c, na.rm = TRUE)) /
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE)) #this code only has one input df$a
  
x <- df$a
(x - min(x, na.rm = TRUE))

(max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

rng <- range(x, na.rm = TRUE)
(x - rng[1]) / (rng[2] - rng[1])

#now that we checked the code, we can wrap it into a function:

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(c(0, 5, 10))

#3 key steps:
##pick a name for the function
##list the inputs or arguments to the function inside function
##place the code in the body

#NOTE: only made the function after we figure out how to make it work with a simple input.
#it's easier to start with working code and turn it into a function

rescale01((c(-10, 0, 10)))

rescale01(c(1, 2, 3, NA, 5))

#after writing more functions, you want to convert these informal, interactive test into formal, automated tests - this is called unit testing

#we can rewrite the original example:

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

#to fix something, it will be a lot easier

x <- c(1:10, Inf)
rescale01(x)

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale01(x)

#this is a good example of the DRY principle

#Exercises:

#1. Why is TRUE not a parameter to rescale01()? What would happen if x contained a single missing value, and na.rm was FALSE?

#Answer:

#because it represents a boolean value
#let's find out what would happen

rescale01 <- function(x) {
  rng <- range(x, na.rm = FALSE)
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale01(c(1, 2, 3, NA, 5))
#we would get all the values, NA

#2. In the second variant of rescale01(), infinite values are left unchanged. Rewrite rescale01() so that -Inf is mapped to 0, and Inf is mapped to 1.

#Answer:

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  x[x == -Inf] <- 0
  x[x == Inf] <- 1 
  (x - rng[1]) / (rng[2] - rng[1])
}
??finite

rescale01(c(1:10, -Inf))

#3. Practice turning the following code snippets into functions. Think about what each function does. What would you call it? How many arguments does it need? Can you rewrite it to be more expressive or less duplicative?

mean(is.na(x))

x / sum(x, na.rm = TRUE)

sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)

#Answer:

coeff_var <- function(x) {
   sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)
}

coeff_var(c(22,24,256))

#4. Follow http://nicercode.github.io/intro/writing-functions.html to write your own functions to compute the variance and skew of a numeric vector.

#Answer:

standard.error <- function(x) {
  v <- var(x)
  n <- length(x)
  sqrt(v/n)
}

n <- length(x)
(1/(n-1))

m <- mean(x)
x - m

(x - m) ^ 2

sum((x - m) ^ 2)

(1 / (n - 1)) * sum((x - m) ^ 2)

variance <- function(x) {
  n <- length(x)
  m <- mean(x)
  (1 / (n - 1)) * sum((x - m) ^ 2)
}

skewness <- function(x) {
  n <- length(x)
  v <- var(x)
  m <- mean(x)
  third.moment <- (1 / (n - 2)) * sum((x - m) ^ 2)
  third.moment / (var(x) ^ (3/2))
}

#5. Write both_na(), a function that takes two vectors of the same length and returns the number of positions that have an NA in both vectors.

#Answer:
x <- c(1,2,3,NA,5)
y <- c(1,2,2,2,NA)

which(is.na(x))
?which

both_na <- function(x, y) {
  which(is.na(x) & is.na(y))  
}

#6. What do the following functions do? Why are they useful even though they are so short?

is_directory <- function(x) file.info(x)$isdir
is_readable <- function(x) file.access(x, 4) == 0

#Answer:

#the functions are doing what the variable name was chosen, checking the file in the directory and if it's readable

#7. Read the complete lyrics (http://bit.ly/littlebunnyfoofoo) to "Little Bunny Foo Foo". There's a lot of duplication in this song. Extend the initial piping example to re-create the complete song, and use functions to reduce the duplication.

#Answer:

#the initial piping example:

foo_foo %>% 
  hop(through = forest) %>% 
  scoop(up = field_mouse) %>% 
  bop(on = head)

#then

good_fairy %>% if (
  foo_foo$hop(!through = forest) | foo_foo$bop(!on = head)
) {
  print("Good Bunny")
} else if (length(foo_foo) > 3) {
  print("Foo Foo is a goon")
}


#Functions are for Humans and Computers

#some guidance in writing functions that anyone can understand

## name of the function is important - keep it short with a good description of what the function is doing
## use verbs for functions and nouns for arguments (with some exceptions of course)
# for example:
#too short : f()
#not a verb, or descriptive : my_awesome_function()
#long, but clear: impute_missing() or collapse_years()

#Never do this: col_mins <- function(x, y) {} or rowMaxes <- function(y, x) {}

#Good:
input_select()
input_checkbox()
input_text()

#Not so good:
select_input()
checkbox_input()
text_input()

#Don't do this:
T <- FALSE
c <- 10
mean <- function(x) sum(x)

#use comments to explain the "why" of your code - avoid comments that explain the "what" or "how"
#another important use of comments is to break up your file into easily readable chunks using - or =, for exp:

# Load data ------------------------

# Plot data ------------------------

#using CMD SHIFT R
# load data ---------------------------------------------------------------

#Exercises:

#1. Read the source code for each of the following three functions, puzzle out what they do, and then brainstorm better names:

f1 <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}
f2 <- function(x) {
  if (length(x) <= 1) return(NULL)
  x[-length(x)]
}
f3 <- function(x, y) {
  rep(y, length.out = length(x))
}

#Answer:

?substr
?nchar
substr("abcdef", 2, 4)

extract_prefix <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}

check_length <- function(x) {
  if (length(x) <= 1) return(NULL)
  x[-length(x)]
}

?rep
rep(1:4, 2)

replicate_value <- function(x, y) {
  rep(y, length.out = length(x))
}

#2. Take a function that you've written recently and spend five minutes brainstorming a better name for it and its arguments.

#3. Compare and contrast rnorm() and MASS::mvrnorm(). How could you make them more consistent?

#Answer:

?rnorm # generates random deviates
rnorm(n, mean = 0, sd = 1)

?MASS::mvrnorm # "produces one or more samples from the specified multivariate normal distribution."
mvrnorm(n = 1, mu, Sigma, tol = 1e-6, empirical = FALSE, EISPACK = FALSE)

#to make them more consistent involves careful data collection, handling outliers, and potentially using robust estimation techniques. (soruce google) 

#4. Make a case for why norm_r(), norm_d(), etc., would be better than rnorm(), dnorm(). Make a case for the opposite.

#Answer:

#as the book mentions, using a common prefix to indicate that they are connected - memebers of the family

# Conditional execution

if (condition) {
  # code executed when condition is TRUE
} else {
  # code executed when condition is FALSE
}

#?'if'

help('if')

# return a logical vector - checking each element is named:

has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}

# Conditions

#the condition must evaluate to either TRUE or FALSE

if (c(TRUE, FALSE)) {}

if (NA) {}

#we can use || - or and && - and to combine multiple logical expressions
#never use | or & in an if statement - use them for multiple values, but if you do have a logical vector, use any() or all() to collapse it to a single value
#when testing for equality, == is vectorized - meaning that you can get more than one output: either check the length is 1, collapse with all() or any(), or use identical()

identical(0L, 0)

x <- sqrt(2) 
x <- sqrt(2) ^ 2
x
# and
x == 2
# but
x - 2
#in this case use dplyr::near()

# Multiple Conditions

if (this) {
  # do that
} else if (that) {
  #do something else
} else {
  #
}

#if you end up with a long chain, just rewrite everything, you can use switch() function. 

#> function(x, y, op) {
#>    switch(op,
#>    plus = x + y,
#>    minus = x - y,
#>    times = x * y,
#>    divide = x / y,
#>    stop("Unknown op!")
#>    )
#> }

#you can also use cut()

# Code Style

# Good
if (y < 0 && debug) {
  message("Y is negative")
}

if (y == 0) {
  log(x)
} else {
  y ^ x
}

#BAD

if (y < = && debug)
  message("Y is negative")

if (y == 0) {
  log(x)
}
else {
  y ^ x
}

#drop the {} when there's a very short if statement

y <- 10
x <- if (y < 20) "Too low" else "Too high"
x

if (y < 20) {
  x <- "Too low"
} else {
  x <- "Too high"
}

# Exercises:

#1. What's the difference between if and ifelse()? Carefully read the help and construct 3 examples that illustrate the key differences.

#Answer:

help('if')
help('ifelse')

# if returns the value of the expression evaluated, or NULL invisibly if none was (which may happen if there is no else).
# ifelse returns a value with the same shape as test which is filled with elements selected from either yes or no depending on whether the element of test is TRUE or FALSE.

#Usage:

#if(cond) expr
#ifelse(test, yes, no)

#examples from the help function:

res <- if(sum(x) > 7.5) mean(x) # may be NULL

x <- c(6:-4)
sqrt(x)  #- gives warning
sqrt(ifelse(x >= 0, x, NA))  # no warning

## Note: the following also gives the warning !
ifelse(x >= 0, sqrt(x), NA)

yes <- 1:3
no  <- pi^(1:4)
utils::str( ifelse(NA,    yes, no) ) # logical, length 1
utils::str( ifelse(TRUE,  yes, no) ) # integer, length 1
utils::str( ifelse(FALSE, yes, no) )

# source r bloggers:
#>ifelse() has two major advantages over if … else:
#>It’s super fast.
#>It’s more convenient to use.

#2. Write a greeting function that says "good morning". "good afternoon" or "good evening", depending on the time of day. (Hint: use a time argument that defaults to lubridate::now(). That will make it easier to test your function.)

#Answer:
??between # between(x, lower, upper, incbounds=TRUE, NAbounds=TRUE, check=FALSE)
input_greeting <- function(now = lubridate::now()) {
  if (between(hour(now), 6, 12)){
    print("good morning")
  } else if (between(hour(now), 13, 17)) {
    print("good afternoon")
  } else {
    print("good evening")
  }
}

#3. Implement a fizzbuzz function. It takes a single number as input. If the number is divisible by three, it returns "fizz". If it's divisible by five it returns "buzz". If it's divisible by three and five, it returns "fizzbuzz". Otherwise, it returns the number. Make sure you first write working code before you create the function.

#Answer:

x = readline(prompt = "Please enter a number: ")
x <- 3
if (x %% 3) "fizz" else if (x %% 5) "buzz" else if (x %% 3 && x %% 5) "fizzbuzz" else (print(x))

checking_fizzbuzz <- function(x) { 
    if (x %% 3 == 0) {
    return("fizz")
    } else if (x %% 5) {
    return("buzz") 
    } else if (x %% 3 && x %% 5) {
    return("fizzbuzz")
  } else {
    return(x)
    }
}
checking_fizzbuzz(x <- 123422)

#4. How could you use cut() to simplify this set of nested if-else statements?

if (temp <= 0) {
  "freezing"
} else if (temp <= 10) {
  "cold"
} else if (temp <= 20) {
  "cool"
} else if (temp <= 30) {
  "warm"
} else {
  "hot"
}

#How would you change the call to cut() if I'd used < instead of <=? What is the other chieft advantage of cut() for this problem? (Hint: what happens if you have many values in temp?)

#Answer:

?cut # cut divides the range of x into intervals and codes the values in x according to which interval they fall.
temp <- c(10,22)
cut(temp, breaks = seq(-10, 40, 10),
    labels(c("freezing", "cold", "cool", "warm", "hot")))

cut(temp, breaks = seq(-10, 40, 10),
    right = TRUE, #practice this side
    labels(c("freezing", "cold", "cool", "warm", "hot")))

#5. What happens if you use swtich() with numeric values?

#Answer:

#?switch

x = 2
switch (x, 2 = "no", 1 = "yes")
switch (x, `1` = "no", `2` = "yes")

#6. What does this switch() call do? What happens if x is "e"?

#Answer:
x <- "e"
x <- "a"
switch(x,
       a = ,
       b = "ab",
       c = ,
       d = "cd"
      )

#Experiment, then carefully read the documentation.

