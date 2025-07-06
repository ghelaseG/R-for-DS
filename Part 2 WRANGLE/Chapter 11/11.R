#CHAPTER 11
#STRINGS WITH stringr

#here we talk about string manipulation

#focus will be on regexps - regular expressions

library(tidyverse)
library(stringr)

"This is a string without a closing quote"

double_quote <- "\"" #or '"'
single_quote <- '\'' #or "'"

#to see raw contents of the strings, use writeLines():

x <- c("\"", "\\")
x
writeLines(x)

"\n" - new line
"\t" - new tab
?"'"
?'"'

"\u00b5" - writing non-English characters

c("one", "two", "three") - store in a character vector

#String Length

str_length(c("a", "R for data science", NA))

#Combining Strings

#combining 2 or more strings
str_c("x", "y")

#use sep to separate
str_c("x", "y", sep = ", ")

x <- c("abc", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x), "-|")
str_c("prefix-", c("a", "b", "c"), "-suffix")

#objects of length 0 are dropped

name <- "George"
time_of_day <- "evening"
birthday <- TRUE

str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)

#to collapse a vector of strings into a single string, use collapse:
str_c(c("x", "y", "z"), collapse = ", ")

#Subsetting strings

#we can extract part of a string

x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
str_sub(x, -3, -1)

str_sub("a",1, 1)

str_sub(x, 1, 1) <- str_to_lower(str_sub(x,1,1))
x

#Locales
#we can change the text to lower, upper etc, we can specify the locale (ISO 639) - https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes

str_to_upper(c("i", "a"), locale = "tr")

#Exercises:

#1. In code that doesn't use stringr, you'll often see paste() and paste0(). What's the difference between the two functions? What stringr function are they equivalent to? How do the functions differ in their handling of NA?

#Answer:

?paste
#Concatenate vectors after converting to character. Concatenation happens in two basically different ways, determined by collapse being a string or not.
#paste0(..., collapse) is equivalent to paste(..., sep = "", collapse), slightly more efficiently.
str_c() #same as paste and paste0

#2. In your own words, describe the difference between the sep and collapse arguments to str_c().

#Answer:

#sep and collapse are doing the same thing, but collapse can be use in a character vector c(...)