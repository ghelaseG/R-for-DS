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

# Naming vectors

#two ways of naming vectors

c(x = 1, y = 2, z = 4)

set_names(1:3, c("a", "b", "c"))

# Subsetting

#filter only works with tibble
# [ use this for vectors : x[a]

#you can subset a vector with:

## a numeric vector containing only integers, exp:

x <- c("one", "two", "three", "four", "five")
x[c(3,2,5)]
x[c(1,1,5,5,5,2)]

#negative values drop the elements
x[c(-1,-3,-5)]

#error to mix positive and negative

x[c(1, -1)]

x[0]

## a logical vector, exp:

x <- c(10, 3, NA, 5, 8, 1, NA)
#All non-missing values of x
x[!is.na(x)]

#all even or missing values
x[x %% 2 == 0]

## character vector, exp:

x <- c(abc = 1, def = 2, xyz = 5)
x[c("xyz", "def")]

## simplest is nothing, x[] - not useful when subsetting vectors, but useful when subsetting matrices, because you can select all the rows or all the columns, by leaving the index blank, exp:

x[1, ]  #select the first row and all the columns
x[, -1] #select all rows and all columns except the first

## [[ only extracts a single element, and always drops names

#Exercises:

#1. What does mean(is.na(x)) tell you about a vector x? What about sum(!is.finite(x))?

#2. Carefully read the documentation of is.vector(). What does it actually test for? Why does is.atomic() not agree with the definition of atomic vectors above?

#3. Compare and contrast setNames() with purrr::set_names().

#4. Create functions that take a vector as input and return:

#a. The last value. Should you use [ or [[?
#b. The elements at even numbered positions.
#c. Every element except the last value.
#d. Only even numbers ( and no missing values).

#5. Why is x[-which(x > 0)] not the same as x[x <= 0]?

#6. What happens when you subset with a positive integer that's bigger than the length o f the vector? What happens when you subset with a name that doesn't exist?


#Answers:

#1.
x <- c(NA, 0, 1, Inf, -Inf)

mean(is.na(x)) #one NA divided by the total number

sum(!is.finite(x)) #sum of anything that is not finite, exp: 0 or 1

#2.

?is.vector 

#>If mode = "any", is.vector may return TRUE for the atomic modes, list and expression. For any mode, it will return FALSE if x has any attributes except names. (This is incompatible with S.) On the other hand, as.vector removes all attributes including names for results of atomic mode.
#>as.vector, a generic, attempts to coerce its argument into a vector of mode mode (the default is to coerce to whichever vector mode is most convenient): if the result is atomic (is.atomic), all attributes are removed. 
#>is.vector(x) returns TRUE if x is a vector of the specified mode having no attributes other than names.

vector(mode = "logical", length = 0)
as.vector(x, mode = "any")
is.vector(x, mode = "any")

#3. 

?setNames # This is a convenience function that sets the names on an object and returns the object. It is most useful at the end of a function definition where one is creating the object to be returned and would prefer not to store it under a name just so the names can be assigned.
??set_names # This is equivalent to stats::setNames(), with more features and stricter argument checking.

setNames( 1:3, c("foo", "bar", "baz") )
set_names(1:4, c("a", "b", "c", "d"))

#4. 
#a.
check_last_value <- function(x) {
  return(x[[length(x)]])
}

check_last_value(1:10)

#b. 
?seq_along
even_number_positions <- function(x) {
  x[seq_along(x) %% 2 == 0]
}

even_number_positions(1:10)
even_number_positions(letters)

#c.

except_last_value <- function(x) {
  x[-length(x)]
}

except_last_value(1:10)

#d.

even_numbers <- function(x) {
  return(x[!is.na(x) & x %% 2 == 0])
}

even_numbers(c(1:10, 2, NA, 4))

#5.
x <- c(1:10, 2, NA, 4, Inf, -Inf, NaN)
x[-which(x > 0)]

x[x <= 0]
?which

#>> x[-which(x > 0)]
#>[1]   NA -Inf  NaN
#>> x[x <= 0] # R treats NaN (Not a number) as NA, because you cannot compare nothing with something
#>[1]   NA -Inf   NA

#6.
x <- c(1:10)

x[-which(x > 0)]

x[x <= 0]

x[11]
x["a"]
x[[11]]
x[["a"]]

#we're getting NA

# Recursive Vectors (Lists)

x <- list(1, 2 , 3)
x
#str - structure
str(x)

x_named <- list(a = 1, b = 2, c = 3)
str(x_named)

#unlike atomic vectors, lists can contain a mix of objects

y <- list("a", 1L, 1.5, TRUE)
str(y)

z <- list(list(1, 2), list(3, 4))
str(z)

#Visualising lists

x1 <- list(c(1,2), c(3,4))
x2 <- list(list(1,2), list(3,4))
x3 <- list(1, list(2, list(3)))

#three principles:

#lists have rounded corners - atomic vectors squared
#children are drawn inside their parent
#the orientation of the children (rows or columns) isn't important

#Subsetting

#three ways to subset a list:

a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))

# [ extracts a sublist - the result will always be a list

str(a[1:2])
str(a[4])

# [[ extracts a single component from a list

str(y[[1]])
str(y[[4]])

# $ is a shorthand for extracting named elements of a list - similar to [[]]

a$a
a[["a"]]

# [[]] drills down into a list, while [] returns a new smaller list

# Exercises:

#1. Draw the following lists as nested sets:
#a. list(a, b, list(c, d), list(e, f))
#b. list(list(list(list(list(list(a))))))

#2. What happens if you subset a tibble as if you're subsetting a list? What are the key differences between a list and a tibble?

# Answers:

#1.a)

library(DiagrammeR)

?DiagrammeR

DiagrammeR::mermaid("
  graph TB;
  subgraph a, b
  id1(c, d); id2(e, f)
  end
  ")

#b)

grViz("

digraph {
      node [shape='box' style='rounded' peripheries = 8 width = 0.9]
      A;
}")

?grViz

#2. 
?tibble #tibble() constructs a data frame. It is used like base::data.frame()
?list # Almost all lists in R internally are Generic Vectors, whereas traditional dotted pair lists (as in LISP) remain available but rarely seen by users (except as formals of functions).

#subsetting works the same way in both sides, the only difference is that you need the same length (col and rows) in a tibble.


# Attributes

#any vector can contain additional metadata through its attributes.
#use attr() to get and set attribute values
#use attributes() to see them all at once

x <- 1:10
attr(x, "greeting")
attr(x, "greeting") <- "Hi!"
attr(x, "farewell") <- "Bye!"
attributes(x)

#>three important attributes:
#>names
#>dimensions
#>class

#exp of generic function

as.Date
methods("as.Date")

#if x is a character - as.Date.character()

getS3method("as.Date", "default")

getS3method("as.Date", "numeric")


# Augmented Vectors

#four important augmented vectors:
##>factors
##>date-times and times
##>tibble

#Factors

#designed to represent categorical data

x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x)
attributes(x)

# Dates and Date-Times

#started on January 1 1970

x <- as.Date("1971-01-01")
unclass(x)

typeof(x)
attributes(x)

x <- lubridate::ymd_hm("1970-01-01 01:00")
unclass(x)
typeof(x)
attributes(x)

attr(x, "tzone") <- "US/Pacific"
x
attr(x, "tzone") <- "US/Eastern"
x

y <- as.POSIXlt(x)
typeof(y)
attributes(y)

#Tibbles

tb <- tibble::tibble(x = 1:5, y = 5:1)
typeof(tb)
attributes(tb)

#data frames have a very similar structure

df <- data.frame(x = 1:5, y = 5:1)
typeof(df)
attributes(df)

# Exercises:

#1. What does hms::hms(3600) return? How does it print? What primitive type is the augmented vector built on top of? What attributes does it use?

#2. Try and make a tibble that has columns with different lengths. What happens?

#3. Based of the previous definition, is it OK to have a list as a column of a tibble?

#Answers:

#1.
hms::hms(3600) #seconds
#01:00:00
?hms::hms
#Supports construction from time values, coercion to and from various data types, and formatting. Can be used as a regular column in a data frame.
#hms() is a high-level constructor that accepts second, minute, hour and day components as numeric vectors.

#2.
?tibble
a <- 1:5
b <- 1:2
tibble(a, a * 2)
tibble(b, a*2) 
#Error in `tibble()`:
#! Tibble columns must have compatible sizes.

#3. 
c <- list("a", "b", "c")
tibble(b, list(a, c))

#it works