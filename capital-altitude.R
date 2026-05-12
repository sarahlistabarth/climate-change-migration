library(mapdeck)
library(rvest)

# location
data(capitals)

# altitude
url <- "https://en.wikipedia.org/wiki/List_of_capital_cities_by_elevation"
altitude <- url(url) |> 
  read_html() |> 
  html_table() %>%
  `[[`(3)
