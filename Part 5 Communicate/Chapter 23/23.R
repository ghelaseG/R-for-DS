#R Markdown Formats

#we can set the output at the beginning with output: html_document or
rmarkdown::render(
  "23.Rmd",
  output_format = "word_document"
)

?rmarkdown:html_document()

#Documents:
#the outputs can vary: odt_document (opendocument text), word_document, pdf_document, rtf_document (rich text format), md_document (markdown document) and also github_document.

#Notebooks:
#this format is great for communitcating with other data scientists because it contains the full source code.
#.nb.html is great for sharing but not for collaboration (learn Git)

#Presentations:
#the benefit of using R Markdown is because you can present the R code easily.
#we can use ioslides_presentation(html +), slidy_presentation(html +) and beamer_presentation(pdf)

#Dashboards:
#are useful way to communicate large info

#Interactivity:
#any format can contain interactive components.
#for example, using htmlwidgets:
#install.packages("leaflet")
library(leaflet)
leaflet() %>% 
  setView(51.178889, -1.826111, zoom = 16) %>% 
  addTiles() %>% 
  addMarkers(51.178889, -1.826111, popup = "Maungawhau")

#great packages includes: dygraphs, DT, rthreejs, and diagrammer.

#Shiny
#this package allows interactivity in R without javascript
#install.packages("shiny")

library(shiny)
runExample("01_hello")

#Websites:
#you can also create websites using RMarkdown and yaml

#Other formats:
#bookdown helps writing books
#prettydoc helps create pretty documents
#rticles great for scientific journals


