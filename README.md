This repository attempts to provide figures on the number of HMOs in each Cardiff ward versus the total number of dwellings.

## Beware

- Licencing requirements for HMOs are more strict in Cathays and Plasnewydd, and so many more properties are registered as HMOs in these wards

- Households resident in HMOs would be better metric than the proportion of properties

## Source data and licences

The repository contains:
- LSOA boundaries and mappings provided by the Office for National Statistics licensed under the Open Government Licence v.3.0 and contain OS Data © Crown copyright and database right 2021,
- Dwelling stock information from the VOA provided under the OGLv3

It also contains data derived from:
- HMO licence information made [available online by Cardiff Council "for non-commercial purposes"](http://ishare.cardiff.gov.uk/mycardiff.aspx?ms=Cardiff_Live/AllMaps&layers=hmoinfo%2cctax&starteasting=318835.5&startnorthing=177777.69989014&startzoom=7770), but also inspectable on the Council's HMO register at their headquarters

## How to
```R

source("dump2.R")
source("link_hmos_to_lsoas.R")

```