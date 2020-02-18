# libraries
library(tidyverse)

# load data
acd <- read_csv("data/ucdp-prio-acd-191.csv") %>%
  filter(type_of_conflict %in% c(3, 4))

# agreggate into country-year format
acd_cy <- acd %>%
  group_by(gwno_a, year) %>%
  summarize(
    conflicts = n()
  )

# save
write_rds(acd_cy, "data/acd_cy.rds")
rm(list = ls())
