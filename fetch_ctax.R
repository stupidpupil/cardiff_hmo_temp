library(stringr)
library(readr)

download.file(
  "http://ishare.cardiff.gov.uk/MapGetImage.aspx?Type=json&MapSource=Cardiff_Live/AllMaps&RequestType=GeoJSON&ActiveTool=MultiInfo&ActiveLayer=&Layers=ctax&mapid=-1&axuid=1632754536619&ServiceAction=GetMultiInfoFromPoint&Easting=318140.5&Northing=178195.28320313&tolerance=60000&_=1632754536621",
  destfile = "data-raw/ctax.json")


insert <- ',
"name": "ctax",
"crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:EPSG::27700" }}
'

read_file("data-raw/ctax.json") %>%
  str_replace_all("\\}\\},", "\\}\\},\n") %>%
  str_replace_all("\\\\&", "&") %>%
  str_replace_all("\\\\&", "&") %>%
  str_replace("^\\[", "") %>%
  str_replace("\\]$", "") %>%
  str_replace("],\"properties\":.+?\\}\\}$", "]\\}") %>%
  str_replace(",\"features\":", paste0(insert, ",\"features\":")) %>%
  str_replace_all(
    "\"type\": \"Polygon\",\"coordinates\": \\[\\[(\\d+)\\.0+,(\\d+)\\.0+\\],.+?\\]\\]", 
    "\"type\": \"Point\", \"coordinates\": \\[\\1,\\2\\]") %>%
  write_file("data-raw/ctax.geojson")
