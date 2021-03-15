# load libraries
library(tidyverse)
library(vdemdata)

# load vdem
vdem <- vdem

vdem_sub <- vdem %>%
  as_tibble() %>%
  select(year, country_id, v2x_polyarchy, v2x_libdem, v2x_partipdem, v2x_delibdem,
         v2x_egaldem, v2xps_party, v2xel_elecparl, v2psbars, v2psparban, v2psoppaut,
         v2psorgs, v2psprbrch, v2psprbrch_osp, v2psprlnks, v2psprlnks_osp, v2psplats, v2pscnslnl, v2pscohesv,
         v2pscomprg, v2psnatpar, v2pssunpar, v2elmulpar, v2elvotbuy, v2elfrfair,
         v2eldommon, v2elintmon, v2eltrnout, v2cacamps_osp, v2caviol_osp)

rm(vdem)

# save
# write_rds(vdem_sub, "output/data/vdem_sub.rds")
# rm(list = ls())
