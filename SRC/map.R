# read in the data
data <- read.csv("data/cleanedData.csv")

# generate occurrence map with legend
map <- leaflet() %>%
  addProviderTiles("Esri.WorldTopoMap") %>%
  addCircleMarkers(data = data,
                   lat = ~decimalLatitude,
                   lng = ~decimalLongitude,
                   radius = 3,
                   color = "maroon",
                   fillOpacity = 0.8) %>%
  addLegend(position = "topright",
            title = "White-flowered Black Mangrove Occurrence Map",
            labels = "Lumnitzera racemosa Willd.",
            colors = "maroon",
            opacity = 0.8)

#view the map
map

# save the map
mapshot2(map, file = "output/mangrovesOccurrence.png")


