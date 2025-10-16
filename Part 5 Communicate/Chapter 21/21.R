# R Markdown

# combines your code with the results and the commentary; this supports PDFs, Word files etc.

#these files are good of use in communication, collaboration and as a modern lab notebook.

#some useful resources mentioned in the book:

## R Markdown Cheat Sheet and the Reference Guide.


# Exercises:

#1. Create a new notebook using File -> New File -> R Notebook. Read the instructions. Practice running the chunks. Verify that you can modify the code, rerun it, and see modified output.

#2. Create a new R Markdown document with File -> New File -> R Markdown... Knit it by clicking the appropriate button. Knit it by using the appropriate keyboard shortcut. Verify that you can modify the input and see the output update.

#3. Compare and contrast the R Notebook and R Markdown files you created earlier. How are the outputs similar? How are they different? How are the inputs similar? How are they different? What happens if you copy the YAML header from one to the other?

#4. Create one new R Markdown document for each of the three built-in formats: HTML, PDF, and Word. Knit each of the three documents. How does the output differ? How does the input differ? (You may need to install LaTeX in order to build the PDF output - RStudio will prompt you if this is necessary.)


# Text Formatting with Markdown

#we can use Pandoc's Markdown

#for more help we can use "Help -> Markdown Quick Reference".

# Exercises:

#1. Practice what you've learned by creating a brief CV. The title should be your name, and you should include headings for (at least) education or employment. Each of the sections should include a bulleted list of jobs/degrees. Hightlight the year in bold.

"""
---
title: "My CV"
output: html_document
---

##  Georgian Ghelase
##  **Year: 2025**

# Education
- Master's in Data Science and Big Data
- BSc in Finance and Accounting

# Employment
- Data Scient at Upwork
- Daata Scientist at HyperionDev

Skills: Python, R, SQL.

"""

#2. Using the R Markdown quick reference, figure out how to:

#a. Add a footnote.
"""
[^ ]
"""

#b. Add a horizontal rule.
"""
Horizontal Rule / Page Break
Three or more asterisks or dashes:

******

------
"""
#c. Add a block quote.
"""
Blockquotes
A friend once said:

> It's always better to give 
> than to receive.
"""

#3. Copy and paste the contents of diamond-sizes.Rmd from https::/github.com/hadley/r4ds/tree/master/rmarkdown into a local R Markdown document. Check that you can run it, then add text after the frequency polygon that describes its most striking features.


# Code Chunks

#to run code inside R MArkdown we can:

#use keyboard shortcut Cmd-Alt-I
#Insert button
#or manually typing: ```{r} and ```

#the chunk header looks like this:

# ```{r, followed by an optional chunk name, followed by comma-separated options, followed by }. Next comes the R code and the chunk end is indicated by a final ```


# Chunk Names

#chunks can be give an optional name, useful when you want to navigate between these, graphics have an unique name and set up networks of cached chunks.


# Chunk Options

## https://yihui.org/knitr/options/: great website

#most important set of options control:

# eval = FALSE: prevents code from being evaluated.
# include = FALSE: runs but not showing the code.
# echo = FALSE: prevents code but not the results.
# message = FALSE or warning = FALSE: prevents messages or warnings from appearing.
# results = 'hide': hides printed output.
# fig.show = 'hide': hides plots.
# error = TRUE: causes the render to continue even if code has an error.


# Table

# R Markdown prints data frames and matrices by default.

mtcars[1:5, 1:10]

#to have this displayed with additional formatting we can use knitr::kable function.

knitr::kable(
  mtcars[1:5, ],
  caption = "A knitr kable."
)

# ?knitr::kable #we can also use packages such as xtable, stargazer, pander, tables and ascii.


# Caching

# each knit starts from a clean state, but if we have computations that takes a long time, then the solution will be to set cache = TRUE (this will save the output on disk).
# knitr plays a smart role, because if he doesn't see any changes, then it will reuse the cached results.

#however, this process must be used with care:

```{r raw_data}
rawdata <- readr::read_csv("a_very_large_file.csv")
```

```{r processed_data, cached = TRUE}
processed_data <- rawdata %>% 
  filter(!is.na(import_var)) %>% 
  mutate(new_variable = complicated_transformation(x, y, z))
```

#in the next example, the code will rerun only if the dplyr pipeline is changed, not the read_csv().

```
{r processed_data, cached = TRUE, dependson = "raw_data"}
processed_data <- rawdata %>% 
  filter(!is.na(import_var)) %>% 
  mutate(new_variable = complicated_transformation(x, y, z))
```

#to track changes to a file we can use: cache.extra.
#file.info(): you get all the information about the file

```{r raw_data, cache.extra = file.info("a_very_large_file.csv")}
rawdata <- readr::read_csv("a_very_large_file.csv")
```

#we can clear all the caches with knitr::clean_cache()

#these chunks can be named after the function you create. (David Robinson X / twitter)


# Global options

# we can use knitr::opts_chunk$set() in a code chunk to change the options.

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE
)

