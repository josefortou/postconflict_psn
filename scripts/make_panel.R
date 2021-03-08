# load libraries

library(countrycode)
library(tidyverse)

# make panel with ID variables
panel <- codelist_panel %>%
  select(
    country_name = country.name.en,
    iso2c, iso3c, iso3n,
    year,
    cowc, cown,
    gwc, gwn,
    p4c, p4n, vdem,
    imf, wb,
    un, unpd, region
  ) %>%
  filter(year > 1945) %>%
  as_tibble()

# save dataframe
write_rds(panel, "output/data/panel.rds")
rm(list = ls())
