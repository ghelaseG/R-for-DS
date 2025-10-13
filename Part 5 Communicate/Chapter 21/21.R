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