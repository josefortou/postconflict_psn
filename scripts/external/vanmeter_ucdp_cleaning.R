################################################################################
### Download and convert the UCDP data to country-year format
### Emily VanMeter, Political Science, University of Rochester
################################################################################
library(countrycode)
library(tidyverse)
library(plyr)
library(readxl)
library(stringr)
library(rlang)
library(reshape)
library(doBy)
rm(list=ls())

##Download the data
#Obviously will need to update file name in three places indicated as new versions are released

download.file(url = "http://ucdp.uu.se/downloads/ucdpprio/ucdp-prio-acd-191.csv",
              destfile = "data/ucdp-prio-acd-191.csv")

ucdp <- read_csv("data/ucdp-prio-acd-191.csv")

##Split ccodes at commas 
ucdp2 <- ucdp %>%
  mutate(gwno_a = strsplit(as.character(gwno_a), ",")) %>%
  unnest(gwno_a)
ucdp2$cid <- ucdp2$gwno_a

ucdp3 <- ucdp %>%
  mutate(gwno_a_2nd = strsplit(as.character(gwno_a_2nd), ",")) %>%
  unnest(gwno_a_2nd)
ucdp3$cid <- ucdp3$gwno_a_2nd

ucdp4 <- ucdp %>%
  mutate(gwno_b = strsplit(as.character(gwno_b), ",")) %>%
  unnest(gwno_b)
ucdp4$cid <- ucdp4$gwno_b

ucdp5 <- ucdp %>%
  mutate(gwno_b_2nd = strsplit(as.character(gwno_b_2nd), ",")) %>%
  unnest(gwno_b_2nd)
ucdp5$cid <- ucdp5$gwno_b_2nd

ucdp6 <- ucdp %>%
  mutate(gwno_loc = strsplit(as.character(gwno_loc), ",")) %>%
  unnest(gwno_loc)
ucdp6$cid2 <- ucdp6$gwno_loc

ucdp23 <- rbind(ucdp2, ucdp3, ucdp4, ucdp5)
ucdp23 <- cbind(ucdp23[, 1:20], ucdp23[, 24:26], ucdp23$cid)
ucdp23 <- as.data.frame(ucdp23)
unique <- unique(ucdp23)
unique$ccode <- unique$`ucdp23$cid`
new_ucdp <- unique[order(unique$ccode, unique$year), ]

attach(new_ucdp)

###For total number of events per country per year###
new_ucdp %>%
  group_by(ccode, year) %>%
  summarize(conflicts = n())

###For civil conflicts-- count of country-years with civil conflict###
c1 <- merge(new_ucdp, ucdp6, by = c("conflict_id", "year"))
c2 <- c1[c1$ccode == c1$cid2, ]
col2 <- summaryBy(conflict_id ~ ccode + year, FUN = length, data = c2)
col2 %>% as_tibble()

new_ucdp %>%
  filter(type_of_conflict %in% c(3, 4)) %>%
  group_by(ccode, year) %>%
  summarize(conflicts = n())
