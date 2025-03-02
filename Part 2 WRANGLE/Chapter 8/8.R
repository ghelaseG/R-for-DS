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




