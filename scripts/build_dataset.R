# build country-year dataset on post-conflict party systems

# libraries ####

# load libraries
library(tidyverse)
library(countrycode)

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
source("scripts/ucdp_cy.R")

# merge
panel <- panel %>%
  left_join(acd_cy, by = c("year", "gwn" = "gwno_a")) 

rm(acd_cy)

# code new variables
panel <- panel %>%
  mutate(
    # dummy for conflict years
    conflict_dummy = fct_relevel(case_when(
      num_conflicts > 0 ~ "Conflict", 
      TRUE ~ "No conflict"
    ), "No conflict"),
    # fix NAs in number of conflict for country-years with no conflict
    num_conflicts = replace_na(num_conflicts, 0)
  )

# check: quickly explore data
panel %>%
  group_by(year, max_intensity_level) %>%
  summarize(conflicts = sum(num_conflicts, na.rm = TRUE)) %>%
  ggplot(aes(year, conflicts, fill = max_intensity_level)) + 
  geom_col()

# add other data ####

# load vdem data
source("scripts/select_vdem.R")

# merge
panel <- panel %>%
  left_join(vdem_sub, by = c("year", "vdem" = "country_id"))

# save panel
write_rds(panel, "output/data/panel.rds")
rm(list = ls())
