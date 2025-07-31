# VECTORS

#the focus of this chapter is on data structures

library(tidyverse)

#Vector Basics

#we got 2 types:

## atomic vectors : logical, integer, double, character, complex and raw - homogeneous
## lists can be called recursive vectors - heterogeneous

#every vector has two key properties

#its type and its length

typeof(letters)
typeof(1:10)

x <- list("a", "b", 1:10)
length(x)

#can also contain attributes used to create augmented vectors

#factors are built on top of integer vectors, dates on top of numeric, and data frames and tibble on top of lists.

# Important types of Atomic Vector

#four most important are logical, integer, double and character; raw and complex are rarely used.


#Logical

#take only FALSE, TRUE and NA

1:10 %% 3 == 0

c(TRUE, TRUE, FALSE, NA)

#Numeric

#numbers are doubles by default
#use L to make an integer

typeof(1)
typeof(1L)
1.5L

#doubles are approximations, floating-point numbers, they have NA, NaN, Inf, -Inf

x <- sqrt(2) ^ 2
x
x - 2

#integers have NA

c(-1, 0, 1) / 0

#use is.finite(), is.infinite(), is.nan() 


#Character

#R uses a global string pool, each unique string is only stored in memory once

x <- "This is a reasonably long string."
pryr::object_size(x)

y <- rep(x, 1000)
pryr::object_size(y)

# a pointer is 8 bytes, so 8 * 1000 + 136 = 8.13 kB

#Missing Values

NA # logical

NA_integer_ # integer

NA_real_ # double

NA_character_ # character

# Exercises:

#1. Describe the difference between is.finite(x) and !is.infinite(x).

#Answer:

?is.infinite

# is.finite and is.infinite return a vector of the same length as x, indicating which elements are finite (not infinite and not missing) or infinite.
is.finite(x)
!is.infinite(x)

# is.finite returns a vector of the same length as x the j-th element of which is TRUE if x[j] is finite (i.e., it is not one of the values NA, NaN, Inf or -Inf) and FALSE otherwise. Complex numbers are finite if both the real and imaginary parts are.
# is.infinite returns a vector of the same length as x the j-th element of which is TRUE if x[j] is infinite (i.e., equal to one of Inf or -Inf) and FALSE otherwise. This will be false unless x is numeric or complex. Complex numbers are infinite if either the real or the imaginary part is.

#2. Read the source code for dplyr::near() (Hint: to see the source code, drop the ()). How does it work?

#Answer:

?dplyr::near #This is a safe way of comparing if two vectors of floating point numbers are (pairwise) equal. This is safer than using ==, because it has a built in tolerance

sqrt(2) ^ 2 == 2
near(sqrt(2) ^ 2, 2)

#3. A logical vector can take three possible values. How many possible values can an integer vector take? How many possible values can a double take? Use Google to do some research.

#Answer:

?integer # Note that current implementations of R use 32-bit integers for integer vectors, so the range of representable integers is restricted to about +- 2 x 10^9 doubles can hold much larger integers exactly.

?double # All R platforms are required to work with values conforming to the IEC 60559 (also known as IEEE 754) standard. This basically works with a precision of 53 bits, and represents to that precision a range of absolute values from about. It also has special values NaN (many of them), plus and minus infinity and plus and minus zero (although R acts as if these are the same). There are also denormal(ized) (or subnormal) numbers with values below the range given above but represented to less precision.

#4. Brainstorm at least four functions that allow you to convert a double to an integer. How do they differ? Be precise.

#Answer:

x <- c(1:10)
typeof(x)
y <- seq(-10, 10, by = 1)
typeof(y)
y

as.integer(y) 
floor(y)
ceiling(y)
trunc(y)

#5. What functions from the readr package allow you to turn a string into a logical, integer, and double vector?

#Answer:

?readr

parse_logical() #one option
parse_integer()
parse_number()
parse_double()

x <- c("1", "2")
parse_integer(x)

x <- c("1.1", "1.2")
parse_double(x)


# Using Atomic Vectors

#Coercion

#there are two ways to convert one type of vector to another:

#explicit coercion: happens when you call as.logical(), as.integer(), as.double() or as.character(); check if you can make the fix upstream, so that the vector never had the wrong type
#implicit coercion: happens when you use a vector in a specific context that expects a certain type of vector.

#one of the most important type of implicit coercion is using a logical vector in a numeric context - True becomes 1 and False 0.

x <- sample(20, 100, replace = TRUE)
y <- x > 10
sum(y)
mean(y)

if (length(x)) {
  # do something
}

#the most complex type always wins:

typeof(c(TRUE, 1L))
typeof(c(1L, 1.5))
typeof(c(1.5, "a"))

# Test functions

#you can use:

typeof()
is.vector()
is.atomic()
is_*(purr)

is_scalar_atomic() #checks length is 1

# Scalars and Recycling Rules

#R will coerce the types of vectors to be compatible and also the length of vectors (vector recycling)

#a single number is a vector of length 1

sample(10) + 100

runif(10) > 0.5

#in R basic mathematical pperations work with vectors

1:10 + 1:2 #recycling - R expand the shortest vector to the same length as the longest

1:10 + 1:3

#if you do want to recycle, you'll need to do it yourself with rep()

tibble(x = 1:4, y = 1:2)
tibble(x = 1:4, y = rep(1:2, 2))

tibble(x = 1:4, y = rep(1:2, each = 2))

