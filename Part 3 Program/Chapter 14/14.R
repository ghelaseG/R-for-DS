# Pipes with magrittr
install.packages("magrittr")
library(magrittr)

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
