# load libraries
library(tidyverse)

# load data
load("data/ucdp/ucdp-prio-acd-201.RData") 

# filter and select only interstate conflicts
acd <- ucdp_prio_acd_201 %>%
  # filter(type_of_conflict == c(3, 4)) %>%
  filter(type_of_conflict == 3) %>%
  arrange(conflict_id, year)

# aggregate into country-year format
acd_cy <- acd %>%
  group_by(side_a_id, year) %>%
  summarize(
    gwno_a = unique(gwno_a),
    side_a = unique(side_a),
    conflict_id = paste(conflict_id, collapse = ", "),
    num_conflicts = n(),
    all_side_b = paste(side_b, collapse = ", "),
    all_side_b_id = paste(side_b_id, collapse = ", "),
    all_incompatibility = paste(incompatibility, collapse = ", "),
    max_intensity_level = max(intensity_level, na.rm = TRUE),
    # max_cumulative_intensity = max(cumulative_intensity, na.rm = TRUE),
    any_ep_end = max(ep_end, na.rm = TRUE)
  ) %>% 
  ungroup() %>%
  # recode some variables
  mutate(
    gwno_a = as.integer(gwno_a),
    all_incompatibility = fct_relevel(case_when(
      all_incompatibility %in% c("1", "1, 1", "1, 1, 1", "1, 1, 1, 1") ~ "Territory",
      all_incompatibility == 2 ~ "Government",
      TRUE ~ "Government and Territory"
    ), "Government")
  )  

# clear other objects
rm(list = c("ucdp_prio_acd_201", "acd"))

# save
# write_rds(acd_cy, "output/data/acd_cy.rds")
# rm(list = ls())
