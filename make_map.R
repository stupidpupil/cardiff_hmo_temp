library(sf)
library(leaflet)
library(tidyverse)

licences <- st_read("data-raw/licences.geojson")

lsoas <- st_read("data-raw/lsoa11_boundaries_full.geojson") %>%
  rename(LSOA11CD = LSOA11Code)

licences_by_lsoa <- licences %>% 
  st_join(lsoas) %>% 
  st_drop_geometry() %>% 
  group_by(LSOA11CD) %>%
  summarise(CountLicensedHMOs = n())

dwellings_by_lsoa <- read_csv("data-raw/Table_CTSOP4_1_2020.csv") %>%
  filter(band == "All") %>%
  mutate(
    LSOA11CD = ECODE,
    CountDwellings = as.integer(ALL_PROPERTIES)
  ) %>%
  select(LSOA11CD, CountDwellings)

rate_by_lsoa <- dwellings_by_lsoa %>% 
  left_join(read_csv("data-raw/Lower_Layer_Super_Output_Area__2011__to_Ward__2020__Lookup_in_England_and_Wales.csv")) %>%
  left_join(licences_by_lsoa) %>%
  filter(WD20NM %in% c('Cathays', 'Plasnewydd')) %>%
  replace_na(list(CountLicensedHMOs = 0)) %>%
  mutate(PropLicensedHMOs = CountLicensedHMOs/CountDwellings)


lsoa_boundaries <- st_read("data-raw/lsoa11_boundaries_full.geojson") %>%
  rename(LSOA11CD = LSOA11Code) %>% st_transform(crs = 4326) %>%
  left_join(read_csv("data-raw/Lower_Layer_Super_Output_Area__2011__to_Ward__2020__Lookup_in_England_and_Wales.csv")) %>%
  filter(LSOA11CD %in% rate_by_lsoa$LSOA11CD) %>%
  left_join(rate_by_lsoa)
 
bins <- c(0, 10, 20, 30, 40, 50, 100)/100
pal <- colorBin("YlOrRd", domain = lsoa_boundaries$PropLicensedHMOs, bins = bins)

m <- leaflet() %>%
  addTiles() %>% 
  addPolygons(
    data = lsoa_boundaries,
    fillColor = ~pal(PropLicensedHMOs),
    weight = 0,
    opacity = 0,
    fillOpacity = 0.7) %>%
  addLegend(
    data = lsoa_boundaries,
    pal = pal, 
    values = ~PropLicensedHMOs, opacity = 0.7, title = "% dwellings registered as HMOs",
    labFormat = labelFormat(
      prefix = "(", suffix = ")%", between = ", ",
      transform = function(x) 100 * x
    ),
    position = "bottomright")