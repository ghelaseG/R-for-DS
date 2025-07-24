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

#5. Write both_na(), a function that takes two vectors of the same length and returns the number of positions that have an NA in both vectors.

#Answer:
x <- c(1,2,3,NA,5)
y <- c(1,2,2,2,NA)

which(is.na(x))
?which

both_na <- function(x, y) {
  which(is.na(x) & is.na(y))  
}
