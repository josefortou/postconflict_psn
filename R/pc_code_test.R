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

# test 2 ####
# using old code

# Variable for conflict begin
# 1 if there is conflict and the previous year there was not
# Variable for conflict end
# 1 if there is conflict but the next year there is not
panel <- panel %>%
  group_by(gwn) %>%
  mutate(
    conflict_country = case_when(
      sum(max_intensity_level, na.rm = TRUE) > 0 ~ 1,
      TRUE ~ 0
    ),
    conflict_begin = case_when(
      conflict_year == 1 & 
        lag(conflict_year == 0) ~ 1,
      TRUE ~ 0
    ),
    conflict_end = case_when(
      conflict_year == 1 & 
        lead(conflict_year == 0) ~ 1, 
      TRUE ~ 0
    )
  ) %>%
  ungroup()

# Add counter for years after conflict ended
panel %>% 
  group_by(gwn, idx = cumsum(conflict_end == 1L)) %>% 
  mutate(
    counter = row_number() - 1
  ) %>%
  ungroup() %>% 
  select(-idx) %>% filter(conflict_country == 1) %>% View()

# Check: 
# restarts with every country 
# and every time there is a new conflict beginning
panel %>% filter(conflict_country==1) %>% 
  select(cown, year, conflict_end, counter) %>% 
  View()

# Variables for postconflict years
# No conflict, but at least one conflict year before
# Post conflict ends after 10, 20 years
# But no minimum time: postconflict starts and can recur anytime
# Conflict recurrence
# If a conflict restarts after a postconflict period has ended, 
# that is not recurrence, it's a new conflict
panel <- panel %>%
  group_by(cown) %>%
  mutate(
    postconflict_year = if_else(
      conflict_year == 0
      & cumsum(conflict_year > 0),
      1, 0
    ),
    postconflict_year10 = if_else(
      conflict_year == 0
      & cumsum(conflict_year > 0)
      & counter < 12,
      1, 0
    ),
    postconflict_year20 = if_else(
      conflict_year == 0
      & cumsum(conflict_year > 0)
      & counter < 22,
      1, 0
    ),
    recur = if_else(
      conflict_begin == 1
      & lag(postconflict_year == 1),
      1, 0
    ),
    recur10 = if_else(
      conflict_begin == 1
      & lag(postconflict_year10 == 1),
      1, 0
    ),
    recur20 = if_else(
      conflict_begin == 1
      & lag(postconflict_year10 == 1),
      1, 0
    )
  )

# Check
panel %>% filter(conflict_country==1) %>% 
  select(cown, year, conflict_year,
         postconflict_year, postconflict_year10, postconflict_year20,
         recur, recur10, recur20) %>% 
  View()

# Add postconflict episode ID
# Group by country
# If an observation country-year is in postconflict_year == 1, then
# make a variable with countrycode + sum(end_episode)
panel <- panel %>%
  group_by(cown) %>%
  mutate(
    count_conflict_end = as.integer(cumsum(conflict_end)),
    postconflict_epid = if_else(
      postconflict_year == 1,
      paste(cown, count_conflict_end, sep = "-"),
      "0"
    ),
    count_conflict_begin = as.integer(cumsum(conflict_begin)),
    conflict_id = if_else(
      conflict_year == 1,
      paste(cown, count_conflict_begin, sep = "-"),
      "0"
    )
  )

# test 1 ####
# code some country-level conflict variables
# panel %>%
#   group_by(gwn) %>%
#   mutate(
#     # dummy for countries with at least one conflict
#     conflict_country_dummy = case_when(
#       sum(num_conflicts, na.rm = TRUE) > 0 ~ "Yes",
#       sum(num_conflicts, na.rm = TRUE) == 0 ~ "No",
#     ),
#     # dummy for country-years with previous conflicto
#     conflict_previous_dummy = case_when(
#       lag(cumsum(num_conflicts)) > 0 ~ "Yes",
#       lag(cumsum(num_conflicts)) == 0 ~ "No",
#     )
#   ) %>%
#   ungroup() %>% 
#   filter(conflict_country_dummy=="Yes") %>% 
#   select(country_name, year, conflict_dummy, num_conflicts, 
#          conflict_country_dummy, conflict_previous_dummy) %>% 
#   View() %>%
#   mutate(
#     postconflict_dummy = case_when(
#       conflict_dummy == "No conflict" &
#         conflict_previous_dummy == "Yes" ~ "Yes",
#       conflict_dummy == "Conflict" | 
#         conflict_country_dummy == "Yes" ~ "No" 
#     )
#   ) %>%
#   count(postconflict_dummy)

