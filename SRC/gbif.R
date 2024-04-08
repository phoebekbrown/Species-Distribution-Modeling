#gbif.R
#query species occurrence data from GBIF
#clean up the data
# save it to a csv file
#create a map to display species occurrence points

#gbif querying
usethis::edit_r_environ()

mangrovebackbone <- name_backbone(name="Lumnitzera racemosa Willd.")
speciesKey <- mangrovebackbone$usageKey

occ_download(pred("taxonKey", speciesKey), format="SIMPLE_CSV")

<<gbif download>>
# Your download is being processed by GBIF:
#   https://www.gbif.org/occurrence/download/0123179-240321170329656
# Most downloads finish within 15 min.
# Check status with
# occ_download_wait('0123179-240321170329656')
# After it finishes, use
# d <- occ_download_get('0123179-240321170329656') %>%
#   occ_download_import()
# to retrieve your download.
# Download Info:
#   Username: phoebebrown
# E-mail: lc20-0156@lclark.edu
# Format: SIMPLE_CSV
# Download key: 0123179-240321170329656
# Created: 2024-04-08T20:26:43.670+00:00
# Citation Info:  
#   Please always cite the download DOI when using this data.
# https://www.gbif.org/citation-guidelines
# DOI: 10.15468/dl.zn2pkz
# Citation:
#   GBIF Occurrence Download https://doi.org/10.15468/dl.zn2pkz Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2024-04-08.15468/dl.zn2pkz Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2024-04-08

d <- occ_download_get('0123179-240321170329656') %>%
  occ_download_import()

write_csv(d, "data/rawData.csv")

#cleaning

#filtering out occurrences that aren't geo-referenced
fData <- d %>%
  filter(!is.na(decimalLatitude), !is.na(decimalLongitude))

#filtering to only occurrences in Bay of Bengal/SE Asia countries (not exhaustive)
fData <- fData %>%
  filter(countryCode %in% c("IN", "TH", "ID", "VN", "MY", "SG", "BD", "LK"))

#removing any captive or preserved specimens
fData <- fData %>%
  filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN"))

#removing occurrences that are in the ocean
#fData <- fData %>%
#  cc_sea(lon="decimalLongitude", lat="decimalLatitude")

#that removed a lot of data (makes sense)! 
#will rewrite, comment out that step, and check the occurrence map to see if
#it's necessary
#all look good except for one point in the ocean off the west coast of Africa
# the error point is actually an na but recorded with 0lat 0long
#removing
fData <- fData %>%
  filter(decimalLongitude != 0)
#fixed!

# remove duplicates
fData <- fData %>%
  distinct(decimalLongitude, decimalLongitude, speciesKey, datasetKey, .keep_all = TRUE)

# one fell swoop:
# cleanData <- d %>%
#   filter(!is.na(decimalLatitude), !is.na(decimalLongitude)) %>%
#   filter(countryCode %in% c("US", "CA", "MX")) %>%
#   filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN")) %>%
#   cc_sea(lon="decimalLongitude", lat="decimalLatitude") %>%
#   distinct(decimalLongitude, decimalLongitude, speciesKey, datasetKey, .keep_all = TRUE)

# saved cleaned data as CSV
write.csv(fData, "data/cleanedData.csv")
