library(sf)
library(tidyverse)

hmos <- st_read("data-raw/licences.geojson")
lsoas <- st_read("data-raw/lsoa11_boundaries_full.geojson") %>%
  rename(LSOA11CD = LSOA11Code)

hmos_by_lsoa <- hmos %>% 
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


dwellings_by_lsoa %>% 
  left_join(read_csv("data-raw/Lower_Layer_Super_Output_Area__2011__to_Ward__2020__Lookup_in_England_and_Wales.csv")) %>%
  left_join(hmos_by_lsoa) %>%
  filter(LAD20NM %>% str_detect("Cardiff")) %>%
  group_by(WD20NM) %>%
  summarise(
    CountLicensedHMOs = sum(CountLicensedHMOs, na.rm=TRUE),
    CountDwellings = sum(CountDwellings),
    PropHMOs = CountLicensedHMOs/CountDwellings
  ) %>% 
  arrange(-PropHMOs) %>%
  write_excel_csv("output/hmos_by_ward_2019.csv")