# Pipes with magrittr
install.packages("magrittr")
library(magrittr)

#The following example is made after a popular children's poem:

"""
Little bunny Foo Foo
Went hopping thorugh the forest
Scooping up the field mice
And bopping them on the head
"""

foo_foo <- little_bunny()

foo_foo_1 <- hop(foo_foo, through = forest)
foo_foo_2 <- scoop(foo_foo_1, up = field_mice)
foo_foo_3 <- bop(foo_foo_2, on = head)

diamonds <- ggplot2::diamonds

diamonds2 <- diamonds %>% dplyr::mutate(price_per_carat = price / carat)

diamonds$carat[1] <- NA
pryr::object_size(diamonds)
pryr::object_size(diamonds2)
pryr::object_size(diamonds, diamonds2)

#Overwrite the original

foo_foo <- hop(foo_foo, through = forest)
foo_foo <- scoop(foo_foo, up = field_mice)
foo_foo <- bop(foo_foo, on = head)

#Function Composition

bop(
  scoop(
    hop(foo_foo, through = forest),
    up = field_mice
  ),
  on = head
)

#Use the pipe

foo_foo %>% 
  hop(through = forest) %>% 
  scoop(up = field_mouse) %>% 
  bop(on = head)

#when running the above pipe, magrittr does this:

my_pipe <- function(.) {
  . <- hop(., through = forest)
  . <- scoop(., up = field_mice)
  bop(., on = head)
}
my_pipe(foo_foo)  

# pipe won't work for two classes of functions:
## functions that use the current environmment:

assign("x", 10)
x

"x" %>%  assign(100) #this won't work because it assigns it to a temporary environment
x

env <- environment()
"x" %>% assign(100, envir = env)
x
#other functions with this problem include get() and load()

##and functions that use lazy evaluation

tryCatch(stop("!"), error = function(e) "An error")

stop("!") %>% 
  tryCatch(error = function(e) "An error")
#other functions with this behavior: try(), suppressMessages() and suppressWarnings()

#When not to use the Pipe

#the pipe doesn't solve every problem
##use alternatives when:

#pipes are longer than 10 steps (you can use intermediate objects with meaningful names)
#or you have multiple inputs or outputs (if there are two or more objects being combined together, don't use the pipe)
#or you are started to think about a directed graph with a complex dependency structure (pipes are linear)

#Other tools from magrittr

#we can use the "tee" pipe %T>% - this return the lefthand side instead of the righthand side

rnorm(100) %>% 
  matrix(ncol = 2) %>% 
  plot() %>% 
  str()

rnorm(100) %>% 
  matrix(ncol = 2) %T>%
  plot() %>% 
  str()

#we can use %$% if working with functions that don't have a data frame-based API
##it is useful when working with multiple functions in base R

mtcars %$%
  cor(disp, mpg)

#we can use %<>% operator, for exp:

mtcars <- mtcars %>%
  transform(cyl= cyl * 2)

#with

mtcars %<>% transform(cyl = cyl * 2)
