This repository attempts to provide figures on the number of HMOs in each Cardiff ward versus the total number of dwellings, as of 2019/2020.

See  [here for the figures](output/hmos_by_ward_2019.csv).

## Beware

- Licencing requirements for HMOs are more strict in Cathays and Plasnewydd, and so many more properties are licensed as HMOs in these wards

- There is substantial variation within wards, and ward boundaries might not be what you expect. ([See this map of HMO-density by LSOA in Cathays and Plasnewydd for example.](https://stupidpupil.github.io/cardiff_hmo_temp/output/map.html))

- Households resident in HMOs would be a better metric than the proportion of properties

- Counting dwellings is tricky, but generally HMOs are *probably* counted as a single dwelling (I think, because of how council tax is applied)

## Source data and licences

The repository contains:
- LSOA boundaries and mappings provided by the Office for National Statistics licensed under the Open Government Licence v.3.0 and contain OS Data © Crown copyright and database right 2021,
- Dwelling stock information from the VOA provided under the OGLv3

It also contains data derived from:
- Council tax and HMO licence information made [available online by Cardiff Council "for non-commercial purposes"](http://ishare.cardiff.gov.uk/mycardiff.aspx?ms=Cardiff_Live/AllMaps&layers=hmoinfo%2cctax&starteasting=318835.5&startnorthing=177777.69989014&startzoom=7770), but also inspectable on the Council's HMO register at their headquarters

## How to
```R

source("fetch_licences.R")
source("fetch_ctax.R")
source("link_hmos_to_lsoas.R")

```
