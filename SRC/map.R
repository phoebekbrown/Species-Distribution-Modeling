# read in the data
data <- read.csv("data/cleanedData.csv")

# load libraries
library(leaflet)
library(mapview)

# generate occurrence map with legend
map <- leaflet() %>%
  addProviderTiles("Esri.WorldTopoMap") %>%
  addCircleMarkers(data = data,
                   lat = ~decimalLatitude,
                   lng = ~decimalLongitude,
                   radius = 3,
                   color = "maroon",
                   fill = 0.8) %>%
  addLegend(position = "topright",
            title = "Species Occurrence from GBIF",
            labels = "Habronatus americanus",
            colors = "maroon",
            opacity = 0.8)

# save the map
mapshot2(map, file = "output/leaflettest.png")
# error :-(
