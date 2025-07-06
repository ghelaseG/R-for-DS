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

#3. Use str_length() and str_sub() to extract the middle character from a string. What will you do if the string has an even number of characters?

#Answer:

x <- c("Georgians")
str_length(x)
str_sub(x, 5, 5)

x <- c("Georgian")
#if the size is even, return the 2 elements
str_sub(x, 4, 5)

#4. What does str_wrap() do? When might you want to use it?

#Answer:

?str_wrap
#Wrap words into paragraphs, minimizing the "raggedness" of the lines (i.e. the variation in length line) using the Knuth-Plass algorithm.
#most likely in RMarkdown it can be used.
thanks_path <- file.path(R.home("doc"), "THANKS")
thanks <- str_c(readLines(thanks_path), collapse = "\n")
thanks <- word(thanks, 1, 3, fixed("\n\n"))
cat(str_wrap(thanks), "\n")
cat(str_wrap(thanks, width = 40), "\n")
cat(str_wrap(thanks, width = 60, indent = 2), "\n")

#5. What does str_trim() do? What's the opposite of str_trim()?

#Answer:

?str_trim

#str_trim() removes whitespace from start and end of string; 

#str_pad is the opposite because is adding whitespace.

#6. Write a function that turns (e.g) a vector c("a", "b", "c") into the string a, b, and c. Think carefully about what it should do if given a vector of length 0, 1, or 2.

#Answer:

#fail
x <- str_c(c("a", "b", "c"), collapse = ", ")
x
x[0]
x[1:2]
x[0:2]

func_vec_to_str <- function(x, collapse = ", ") {
  str_c(x, collapse = collapse)
}

func_vec_to_str(x)

vec_len_1 <- letters[1]
func_vec_to_str(vec_len_1)

#Matching Patterns with Regular Expressions

#regexps - describe patterns in strings

#Basic matches

x <- c("apple", "banana", "pear")
str_view(x, "an")

str_view(x, ".a.")

#to create the regular expression, we need \\
dot <- "\\."
#but
writeLines(dot)

str_view(c("abc", "a.c", "bef"), "a\\.c")

x <- "a\\b"
writeLines(x)

str_view(x, "\\\\")

#Exercises:

#1. Explain why each of these strings don't match a \: "\", "\\", "\\\".

#Answer:

#you need to escape it, creating the regular expression \\, and to create that regular expression, you need use a string, which also needs to escape \. that means you need to write "\\\\" to match one. (see exp above)

#2. How would you match the sequence "'\?

#Answer:

str_view("\"'\\", "\"'\\\\", match = TRUE)

#3. What patterns will the regular expression \..\..\.. match? How would you represent it as a string?

#Answer:

#every "\." matches a literal dot and . matches any character

str_view(".a.b.c", "\\..\\..\\..")

