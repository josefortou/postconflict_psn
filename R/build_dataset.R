# build country-year dataset on post-conflict party systems

# libraries ####

# load libraries
library(tidyverse)
library(countrycode)
library(stevemisc)

# data ####

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

# load datasets
source("R/ucdp_cy.R")

# merge
panel <- panel %>%
  left_join(acd_cy, by = c("year", "gwn" = "gwno_a")) %>%
  # sort data
  arrange(gwn, year)

rm(acd_cy)

# code new variables
panel <- panel %>%
  mutate(
    # dummy for conflict years
    conflict_year = case_when(
      num_conflicts > 0 ~ 1, 
      TRUE ~ 0
    ),
    # fix NAs in number of conflict + intensity for country-years with no conflict
    num_conflicts = replace_na(num_conflicts, 0),
    max_intensity_level = replace_na(max_intensity_level, 0)
  )

# check: quickly explore data
panel %>%
  group_by(year, max_intensity_level) %>%
  summarize(conflicts = sum(num_conflicts, na.rm = TRUE)) %>%
  ggplot(aes(year, conflicts, fill = factor(max_intensity_level))) + 
  geom_col()

# code post-conflict episodes ####

# insert code here

# add other data ####

# load vdem data
source("R/select_vdem.R")

# merge
panel <- panel %>%
  left_join(vdem_sub, by = c("year", "vdem" = "country_id"))

# save panel
write_rds(panel, "output/data/panel.rds")
rm(list = ls())
