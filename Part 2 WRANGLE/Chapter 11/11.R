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

#ANCHORS

# ^ to match the start of the string
# $ to match the end of the string

x <- c("apple", "banana", "pear")
str_view(x, "^a")

str_view(x, "a$")

x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
str_view(x, "^apple$")

#Exercises

#1. How would you match the literal string "$^$"?

#Answer:

str_view(c("$^$", "ab$^$gg"), "^\\$\\^\\$", match = TRUE)

#2. Given the corpus of common words in stringr::words, create regular expressions that find all words that:
    #a. Start with "y"
    #b. End with "x"
    #c. Are exactly three letters long (Don't cheat by using str_length()!)
    #d. Have seven letters or more.
#Since this list is long, you might want to use the match argument to str_view() to show only the matching or non-matching words.

#Answer:

stringr::words
help("function")
#a.
startWithY <- function(x) str_view(x, "^y")
startWithY("yahoo")

#b.
endingWithX <- function(y) str_view(y, "x$")
endingWithX("ggx")

#c.
threeLettersLong <- function(z) str_view(z, "^.{3}$")
threeLettersLong("ggr")

#d.
sevenLettersOrMore <- function(abc) str_view(abc, "^.{7,}$")
sevenLettersOrMore("abcdefgsjdhsada")

#Character classes and alternatives

#. matches any character apart from a newline
#\d matches any digit
#\s matches any whitespace (space, tab, newline)
#[abc] matches a,b,or c
#[^abc] matches anything except a,b, or c

#alternation: abc | xyz - matches abc or xyz

str_view(c("grey", "gray"), "gr(e|a)y")

#Exercises:

#1. Create regular expressions to find all words that:
#a, Start with a vowel.
#b. Only contain consonants. (Hint: think about matching "not"-vowels)
#c. End with ed, but not with eed.
#d. End with ing or ize.

#Answer:

#a.
words <- c("george", "mikala", "anca", "fred", "creed", "smiling", "frize")
str_view(words, "^[aeiou]")

#b.
str_view(words, "^[^aeiou]")

#c.
str_view(words, "[^e]ed$")

#d.
str_view(words, "i(ng|ze)$")

#2. Empirically verify the rule "i before e except after c."

#Answer:

str_view(stringr::words, "ie|[^c]ie")

#3. Is "q" always followed by a "u"?

#Answer:

str_view(stringr::words, "q[^u]") # yes, if we run this syntax we can't find anything.

#4. Write a regular expression that matches a word if it's probably written in British English, not American English.

#Answer:

#in British English:
## "ou" instead of "o"
## "ae" and "oe" instead of "a" and "o"
## ends in "ise" != "ize"
## ends in "yse"

# ou | ise$ | ae | oe | yse$

#5. Create a regular expression that will match telephon numbers as commonly written in your country.
  
#Answer:
  
tel_nr_uk <- c("44 7783 667788", "020 7946 0018") #source google

str_view(tel_nr_uk, "^44.{12}$")

str_view(tel_nr_uk, "\\d{3}\\s\\d{4}\\s\\d{4}") 


#Repetition

#now we learn how many times a pattern matches

# ?:0 or 1
# +: 1 or more
# *: 0 or more

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")

str_view(x, "CC+")

str_view(x, 'C[LX]+')

#we can use colou?r to match American and British
#most uses will need parentheses - bana(na)+

#{n}: exactly n
#{n,}: n or more
#{,m}: at most m
#{n,m}: between n and m

str_view(x, "C{2}")
str_view(x, "C{2,}")
str_view(x, "C{2,3}")

#matching the shortest string:
str_view(x, 'C{2,3}?')

str_view(x, 'C[LX]+?')

#1. Describe the equivalents of ?, +, and * in {m,n} form.

#Answer:

#as per our notes, let's see how many times a pattern matches:
#?: 0 or 1 - that is equivalent to {0,1}
#+: 1 or more - {1, }
#*: 0 or more - {0, }

#2. Describe in words what these regular expressions match (read carefully to see if I'm using a regular expression or a string that defines a regular expression):
#a. ^.*$
#b. "\\{.+\\}"
#c. \d{4}-\d{2}-\d{2}
#d. "\\\\{4}"

#Answer:

#a. will match any string:
# ^ match the start of the string
#. match any character except new line
#* match 0 or more characters
#$ match the end of the string

#b. will match any string with curly braces, having at least one character - "{g}"

#c. matches a set of numbers in this format: yyyy-mm-dd

#d. matches four back slashes - "\\\\\\\\"

#3. Create regular expressions to find all words that:
#a. Start with three consonants.
#b. Have three or more vowels in a row.
#c. Have two or more vowel-consonant pairs in a row.

#Answer:

#a.
str_view(stringr::words, "^[^aeiou]{3}")

#b. 
str_view(stringr::words, "[aeiou]{3,}+")

#c.
str_view(stringr::words, "([aeiou][^aeiou]){2,}")

#4. Solve the beginner regexp crosswords at https://regexcrossword.com/challenges/beginner.
#done!!!!!!


#Grouping and Backreferences

#grouping with (..)
#in this example we can find all fruits that have a repeated pair of letters:
str_view(fruit, "(..)\\1", match = TRUE)

#Exercises:

#1. Describe in words, what these expressions will match:

#a. (.)\1\1 
#b. "(.)(.)\\2\\1"
#c. (..)\1
#d. "(.).\\1.\\1"
#e. "(.)(.)(.).*\\3\\2\\1"

#Answer:

#a. this regular expression matches the same character 3 times.
str_view(c("george", "geeorororge", "geeeorge"), "(.)\\1\\1", match = TRUE)

#b. matches a pair of character followed by the same reversed pair of characters
str_view(fruit, "(.)(.)\\2\\1", match = TRUE)

#c. matches a repeated pair of characters
str_view(fruit, "(..)\\1", match = TRUE)

#d. first main character, followed by a different one, then again the main one, and then any other character and finally the main character again
str_view(fruit, "(.).\\1.\\1", match = TRUE)

#e. first 3 characters of any type, followed by (*) any nr of characters until reaches the first 3 characters in reverse order.
str_view(c("george", "georgegheoeg"), "(.)(.)(.).*\\3\\2\\1", match = TRUE)

#2. Construct regular expressions to match words that:
#a. Start and end with the same character.
#b. Contain a repeated pair of letters (e.g, "church" contains "ch" repeated twice)
#c. Contain one letter repeated in at least three places (e.g., "eleven" contains three "e"s)

#a.
str_view(stringr::words, "^(.).*\\1$")

#b.
str_view(stringr::words, "([A-Za-z][A-Za-z]).*\\1")

#c.
str_view(stringr::words, "([a-z]).*\\1.*\\1")

#Tools

#Jamie Zawinski: "Some people, when confronted with a problem, think "I know, I'll use regular expressions." Now they have two problems."

https://stackoverflow.com/questions/201323/how-can-i-validate-an-email-address-using-a-regular-expression/201378#201378

#Detect matches

#to determine if a character vector matches a pattern, use str_detect()

x <- c("apple", "banana", "pear")
str_detect(x, "e")

#we can use str_detect if we want to get the sum or mean across a larger vector:

#How many common words start with t?
sum(str_detect(stringr::words, "^t"))

#What proportion of common words end with a vowel?
mean(str_detect(stringr::words, "[aeiou]$"))

#Find all words containing at least one vowel, and negate
no_vowels_1 <- !str_detect(stringr::words, "[aeiou]")
#Find all words consisting only of consonants
no_vowels_2 <- str_detect(stringr::words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)
?identical

words[str_detect(words, "g$")]
str_subset(words, "g$")

df <- tibble(
  word = words,
  i = seq_along(word)
)

df %>% filter(str_detect(words, "g$"))

?seq_along
?filter

x <- c("apple", "banana", "pear")
str_count(x, "a")

#On average, how many vowels per word?
mean(str_count(stringr::words, "[aeiou]"))

#we can use str_count with mutate
df %>% mutate(
  vowels = str_count(words, "[aeiou]"),
  consonants = str_count(words, "[^aeiou]")
)
?mutate

#Note: matches never overlap
str_count("abababa", "aba")
str_view_all("abababa", "aba")

#Exercises:

#1. For each of the following challenges, try solving it by using both a single regular expression, and a combination of multiple str_detect() calls:
#a. Find all words that start or end with x
#b. Find all words that start with a vowel and end with a consonant.
#c. Are there any words that contain at least one of each different vowel?
#d. What word has the highest number of vowels? What word has the highest proportion of vowels? (Hint: what is the denominator?)

#Answer:

#a.

str_view(stringr::words, "^y|y$")

#or

start_y <- str_detect(words, "^y")
end_y <- str_detect(words, "y$")
combined <- words[start_y|end_y]
combined

#b.

str_view(stringr::words, "^[aeiou].*[^aeiou]$")

#or

start_v <- str_detect(stringr::words, "^[aeiou]")
end_c <-str_detect(stringr::words, "[^aeiou]$")
combined_z <- stringr::words[start_v & end_c]  
combined_z

#c.
#trials:
str_view(stringr::words, "^[aeiou]+$")
str_view("aeiousss", "^+[aeiou] && [aeiou] && [aeiou]+$")
str_view(stringr::words, "[aeiou]{3,}")
str_view("asdsedsadidsadasodsadau", "[aeiou]{4,}")

str_view(stringr::words, "[aeiou]*")

str_view(stringr::words, "a|e|i|o|u")

vowels <- str_detect(stringr::words, "a") & str_detect(stringr::words, "e") & str_detect(stringr::words, "i") & str_detect(stringr::words, "o") & str_detect(stringr::words, "u")

stringr::words[vowels]
sum(vowels, wt = vowels)
print(table(vowels))
summary(vowels)

#d.
vowels <- str_count(stringr::words, "[aeiou]")
stringr::words[which(vowels == max(vowels))]

stringr::words[which.max(vowels / str_length(stringr::words))]

#Extract Matches

#to extract the text of a match, use str_extract()

length(sentences)
head(sentences)
#find all sentences that contain a color
colors <- c("red", "orange", "yellow", "green", "blue", "purple")

color_match <- str_c(colors, collapse = "|")
color_match

has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
head(matches)
head(has_color)

more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)

str_extract(more, color_match)
str_extract_all(more, color_match)

str_extract_all(more, color_match, simplify = TRUE)

x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)

#Exercises:

#1. In the previous example, you might have noticed that the regular expression matched "flickered", which is not a color. Modifiy the regex to fix the problem.

#Answer:

colors <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c("\\s", colors, "\\s", collapse = "|")
color_match

more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)
str_extract(more, color_match)

#2. From the Harvard sentences data, extract:
#a. The first word from each sentence.
#b. All words ending in ing.
#c. All plurals

#Answer:

#a.
str_extract(sentences, "^[A-Za-z]*")

#b.
str_extract(sentences, "[A-Za-z]+ing")
# str_extract(sentences, "ing$")

#c.
str_extract(sentences, "\\s[A-Za-z]{3,}s\\s")


#Grouped Matches

noun <- "(a|the) ([^ ]+)"

has_noun <- sentences %>% 
  str_subset(noun) %>% 
  head(10)

has_noun %>% 
  str_extract(noun)

has_noun %>% 
  str_match(noun)

tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)",
    remove = FALSE
  )

#Exercises:

#1. Find all words that come after a "number" like "one", "two", "three", etc. Pull out both the number and the word.

#Answer:

tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("number", "word"), "(one|two|three|four|five|six|seven|eight|nine|ten) ([^ ]+)",
    remove = FALSE
  )

#2.Find all contractions. Separate out the pieces before and after the apostrophe.

#Answer:

contraction <- "([A-Za-z]+)'([A-Za-z]+)"
sentences[str_detect(sentences, contraction)] %>% 
  str_extract(contraction) %>% 
  str_split("'")

#Replacing Matches

#str_replace allows you to replace matches with new strings

x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
str_replace_all(x, "[aeiou]", "-")

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

#flip the orderd of the second and third words

sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2")

# Exercises:

#1. Replace all forward slashes in a string with backslashes.

#Answer:

str_replace_all("past/present/future", "/", "\\\\")

#2. Implement a simple version of str_to_lower() using replace_all().

#Answer:

my_str_lower <- function(x) {
  lower_let <- letters
  names(lower_let) <- LETTERS
  
  str_replace_all(x, lower_let)
}

identical(my_str_lower(sentences), str_to_lower(sentences))

#3. Switch the first and last letters in words. Which of those strings are still words?

#Answer:

str_replace_all(words, "^([a-z])(.*)([a-z])$", c("\\3\\2\\1"))
