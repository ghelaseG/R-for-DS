# DATA IMPORT WITH READR

#this chopter teaches you how to read plain-text rectangular files into R
#we use the package from tidyverse called readr

library(tidyverse)

read_csv() # reads comma-delimited files
read_csv2() # reads semicolon-separated files (common in countries where , is used as the decimal place)
read_tsv() #reads tab-delimited files
read_delim() #reads in files with any delimiter
read_fwf() #reads fixed-width files - you can specify fields either by their widths with fwf_widths() or their position with fwf_positions()
read_table() #reads a common variation of fixed-width files where columns are separated by white space
read_log() # reads Apache style log files
webreadr #https://github.com/Ironholds/webreadr 

heights <- read_csv("data/heights.csv") # I got this data from https://github.com/hadley/r4ds/blob/main/data/heights.csv
View(heights)
getwd()
read_csv("a,b,c
         1,2,3
         4,5,6")

#skip = n - can be used to skip the first n lines or use comment ='#' to drop all lines that start with #:

read_csv("The first line of metadata 
         The second line of metadata
         x,y,z
         1,2,3", skip = 2)
read_csv("# A comment I want to skip
         x,y,z
         1,2,3", comment = "#")

#the data might not have column names. You can use col_names = FALSE to tell read_csv() not to treat the first row as headings, and instead to label them sequentially from X1 to Xn:

read_csv("1,2,3\n4,5,6", col_names = FALSE) #"\n" is a convenient shortcut for adding a new line

read_csv("1,2,3\n4,5,6", col_names = c("x","y","z")) # you can pass  col_names a character vector

read_csv("a,b,c\n1,2,.", na= ".") #na is used to represent missing values

# Compared to Base R

#for a raw speed when doing long running jobs - try data.table::fread


#Exercises:

#1. What function would you use to read a file where fields are separated with "|"?

# Answer:

#we use read_delim(), for example:

read_delim(I("a|b\n1.0|2.0"), delim = "|")

#2. Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?

#Answer:

#read_csv(
# file,
# col_names = TRUE,
# col_types = NULL,
# col_select = NULL,
# id = NULL,
# locale = default_locale(),
# na = c("", "NA"),
# quoted_na = TRUE,
# quote = "\"",
# comment = "",
# trim_ws = TRUE,
# skip = 0,
# n_max = Inf,
# guess_max = min(1000, n_max),
# name_repair = "unique",
# num_threads = readr_threads(),
# progress = show_progress(),
# show_col_types = should_show_types(),
# skip_empty_rows = TRUE,
# lazy = should_read_lazy()
# )

# and

# read_tsv(
#   file,
#   col_names = TRUE,
#   col_types = NULL,
#   col_select = NULL,
#   id = NULL,
#   locale = default_locale(),
#   na = c("", "NA"),
#   quoted_na = TRUE,
#   quote = "\"",
#   comment = "",
#   trim_ws = TRUE,
#   skip = 0,
#   n_max = Inf,
#   guess_max = min(1000, n_max),
#   progress = show_progress(),
#   name_repair = "unique",
#   num_threads = readr_threads(),
#   show_col_types = should_show_types(),
#   skip_empty_rows = TRUE,
#   lazy = should_read_lazy()
# )

#they're both identical

# 3. What are the most important arguments to read_fwf()?

#Answer:

fwf_empty() # Guesses based on the positions of empty columns.

fwf_widths() # Supply the widths of the columns.

fwf_positions() # Supply paired vectors of start and end positions.

fwf_cols() # Supply named arguments of paired start and end positions or column widths.

#4. Sometimes strings in a CSV file contain commas. To prevent them from causing problems they need to be surrounded by a quoting character, like " or '. By convention, read_csv() assumes that the quoting character will be ". and if you want to change it you'll need to use read_delim() instead. What arguments do you need to specify to read the following text into a data frame?

"x,y\n1,'a,b'"

#Answer:

# data <- read_csv("x,y\n1,'a,b'")
# read_csv(I("x,y\n1,'a,b'"))
# problems(data)
# data
# 
# read_fwf("x,y\n1,'a,b'", fwf_widths(c(1,6)))
# 
# read_delim("x,y\n1,'a,b'", skip = 1)
# after many attempts I managed to do it:

read_csv("x,y\n1,'a,b'", quote = "'")

#5. Identify what is wrong with each of the following inline CSV files. What happens when you run the code?

read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2n\1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3")

#Answer:

read_csv("a,b\n1,2,3\n4,5,6") # here we got a missing column, and the row values are registering together

read_csv("a,b,c\n1,2n\1,2,3,4") # for this we get the following:
a b              c
<dbl> <chr>      <dbl>
  1     1 "2n\u0001"   234
#this is caused by the missing value on the first row and the extra value in the second row

read_csv("a,b\n\"1") #this will not identify the row value, therefore Rows: 0 Columns: 2                                                                    

read_csv("a,b\n1,2\na,b") #this ones works perfectly

read_csv("a;b\n1;3") #here we should of used read_csv2()

# PARSING A VECTOR

#parse_*() function
#these functions take a character vector and return a more specialized vector like a logical, integer, or date:

str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1","2","3")))
str(parse_date(c("2010-01-01", "1979-10-14")))

parse_integer(c("1","231", ".", "456"), na = ".")
#if parsing fails, the next warning will come:
x <- parse_integer(c("123", "345", "abc", "123.45"))
#Warning: 2 parsing failures.
# row col               expected actual
# 3  -- no trailing characters abc   
# 4  -- no trailing characters 123.45
x
# attr(,"problems")
# # A tibble: 2 × 4
# row   col expected               actual
# <int> <int> <chr>                  <chr> 
#   1     3    NA no trailing characters abc   
# 2     4    NA no trailing characters 123.45

#if there are many parsing failures, you can use problems() to see the complete set
problems(x)

#there are 8 important parsers:

# parse_logical() and parse_integer() 
# parse_double() - is a strict numeric parser
# parse_number() - flexible numeric parser (those are more complicated, because different parts of the world write numbers in different ways)
# parse_character() - you can encounter character encodings
# parse_factor() - creates factors, the data structure that R uses to represent categorical variables with fixed and known values
# parse_datetime(), parse_date(), parse_time()

# NUMBERS

# some countries use . in between the integer while others use ,

parse_double("1.23")
#you can override the default value of . by creating a new locale
parse_double("1,23", locale = locale(decimal_mark = ","))

# parse_number() ignores non-numeric characters
parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")

#we can use parse_number() in combination with locale
parse_number("$123,456,789") #used in America
parse_number(
  "123.456.789",
  locale = locale(grouping_mark = ".")) #used in many parts of Europe
parse_number("123'456'789", locale = locale(grouping_mark = "'")) #used in Switzerland

# STRINGS

charToRaw("George") #getting the underlying representation of a string
#each hexadecimal represent a byte of information
#the mapping from hexadecimal number to character is called the encoding, ASCII.
#two common encodings are Latin1(W European) and Latin2(E European)
#UTF-8 can encode just about every character used by humans today, even emoji!

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

#to fix this you need to specify the encoding:
parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

#if you can't find the correct encoding, guess_encoding() can be used to help you figure it out; this works better when you have lots of text
guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

#FACTORS

fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

#DATES, DATE-TIME, AND TIMES

parse_datetime("2010-10-01T2010")
parse_datetime("20101010")
#parse_datetime expects an ISO8601

parse_date("2010-10-01") - year, month, day

library(hms)
parse_time("01:10 am")
parse_time("20:10:01")

#Year
%Y (4 digits)
%y (2 digits)

#Month
%m (2 digits)
%b (abbreviated name, like "Jan")
%B (full name, "January")

#Day
%d (2 digits)
%e (optional leading space)

#Time
%H (0-23 hour)
%I (0-12, used with %p)
%p (a.m./p.m indicator)
%M (minutes)
%S (integer seconds)
%OS (real seconds)
%Z (time zone)
%z (as offset from UTC)

#Non digits
%. (skips one nondigit character)
%* (skips any number of nondigits)

#examples:
parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")

parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

# Exercises:

#1. What are the most important arguments to locale()?

# Answer:

# the most important arguments to locale() are, depending on the circumstances:
## date_names, date_format, time_format, decimal_mark, grouping_mark, tz, encoding

#2. What happens if you try and set decimal_mark and grouping_mark to the same character? What happens to the default value of grouping_mark when you set decimal_mark to ","? What happens to the default value of decimal_mark when you set the grouping_mark to "."?

#Answer:

parse_number("1,23", locale = locale(decimal_mark = ",", grouping_mark = ",")) #we get this error: Error: `decimal_mark` and `grouping_mark` must be different
parse_number("1,23", locale = locale(decimal_mark = ",", grouping_mark = )) #it is set by default to False
parse_number("1.23", locale = locale(decimal_mark = , grouping_mark = ".")) #puts the number together

#3. I didn't discuss the date_format and time_format options to locale(). What do they do? Construct an example that shows when they might be useful.

#Answer:

#date_format and time_format gives the default date and time formats

parse_date("01/02/15", locale = locale(date_format = "%d/%m/%y"))
parse_time("20:10:01", locale = locale(time_format = "%H:%M:%S"))
