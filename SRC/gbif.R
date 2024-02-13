#gbif.R
#query species occurrence data from GBIF
#clean up the data
# save it to a csv file
#create a map to display species occurrence points

#list of packages 
packages <- c("tidyverse", "rgbif", "usethis", "CoordinateCleaner", "leaflet", "mapview")

#install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if(any(installed_packages==FALSE)){
  install.packages(packages[!installed_packages])
}

#packages loading with library function
invisible(lapply(packages, library, character.only=TRUE))


usethis::edit_r_environ()

spiderbackbone <- name_backbone(name="Habronattus americanus")
speciesKey <- spiderbackbone$usageKey

occ_download(pred("taxonKey", speciesKey), format="SIMPLE_CSV")

<<gbif download>>
# Your download is being processed by GBIF:
# https://www.gbif.org/occurrence/download/0012234-240202131308920
# Most downloads finish within 15 min.
# Check status with
# occ_download_wait('0012234-240202131308920')
# After it finishes, use

# to retrieve your download.
# Download Info:
#   Username: phoebebrown
# E-mail: lc20-0156@lclark.edu
# Format: SIMPLE_CSV
# Download key: 0012234-240202131308920
# Created: 2024-02-13T20:24:50.720+00:00
# Citation Info:  
#   Please always cite the download DOI when using this data.
# https://www.gbif.org/citation-guidelines
# DOI: 10.15468/dl.z3c3yj
# Citation:
#   GBIF Occurrence Download https://doi.org/10.15468/dl.z3c3yj Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2024-02-13

d <- occ_download_get('0012234-240202131308920', path = "data/") %>%
  occ_download_import()

write_csv(d, "data/rawData.csv")

#cleaning

fData <- d %>%
  filter(!is.na(decimalLatitude), !is.na(decimalLongitude))

fData <- fData %>%
  filter(countryCode %in% c("US", "CA", "MX"))

fData <- fData %>%
  filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN"))

fData <- fData %>%
  cc_sea(lon="decimalLongitude", lat="decimalLatitude")


