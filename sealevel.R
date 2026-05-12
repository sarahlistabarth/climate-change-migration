library(terra)
library(here)
library(sf)
library(ecmwfr)
library(dotenv)

wf_set_key(key = Sys.getenv("cds_token")) 

# get sealevel data

request_until_2014 <- list(
  dataset_short_name = "reanalysis-oras5",
  product_type = "consolidated",
  vertical_resolution = "single_level",
  variable = "sea_surface_height",
  year = c(2000:2014) |> as.character(),
  month = "01",
  target = "sealevel.nc"
)

wf_request(
  request  = request,  
  transfer = TRUE,     
  path     = here("output")     
  )

request_after_2014 <- list(
  dataset_short_name = "reanalysis-oras5",
  product_type = "operational",
  vertical_resolution = "single_level",
  variable = "sea_surface_height",
  year = c(2015:2024) |> as.character(),
  month = "01",
  target = "sealevel_after_2014.nc"
)

wf_request(
  request  = request_after_2014, 
  transfer = TRUE,    
  path     = here("output")     
  )

# unzip

here("output/sealevel.zip") |> 
  unzip(exdir = "output/sealevel")

here("output/sealevel_after_2014.zip") |> 
  unzip(exdir = "output/sealevel")

# read in

sealevel <- here("output/sealevel") |>
  list.files(full.names = TRUE) %>%
  rast() |> 
  setNames(paste0("year_", 2000:2024))

# write

terra::writeCDF(sealevel, here("output/sealevel_yearly.nc"), overwrite = TRUE)



library(ggplot2)
library(tidyterra)

ggplot() +
  geom_spatraster(data = sealevel[[2]]) 
