
# load datasets
panel <- read_rds("output/data/panel.rds")

acd_cy <- read_rds("output/data/acd_cy.rds") %>%
  mutate(gwno_a = as.integer(gwno_a)) 

# merge
dat <- panel %>%
  left_join(acd_cy, by = c("year", "gwn" = "gwno_a")) 

# recode variables
dat <- dat %>%
  mutate(
    conflict_dummy = fct_relevel(case_when(
      num_conflicts > 0 ~ "Conflict", 
      TRUE ~ "No conflict"
    ), "No conflict"),
    num_conflicts = replace_na(num_conflicts, 0)
  )

# explore
dat %>%
  group_by(year, max_intensity_level) %>%
  summarize(conflicts = sum(num_conflicts, na.rm = TRUE)) %>%
  ggplot(aes(year, conflicts, fill = max_intensity_level)) + 
  geom_col()

dat %>%
  filter(num_conflicts > 0) %>%
  ggplot(aes(num_conflicts)) +
  geom_histogram() +
  scale_x_log10()

# load vdem

vdem <- vdem 

vdem_sub <- vdem %>%
  as_tibble() %>%
  select(year, country_id, v2x_polyarchy, v2x_libdem, v2x_partipdem, v2x_delibdem,
         v2x_egaldem, v2xps_party, v2xel_elecparl, v2psbars, v2psparban, v2psoppaut,
         v2psorgs, v2psprbrch, v2psprbrch_osp, v2psprlnks, v2psprlnks_osp, v2psplats, v2pscnslnl, v2pscohesv,
         v2pscomprg, v2psnatpar, v2pssunpar, v2elmulpar, v2elvotbuy, v2elfrfair,
         v2eldommon, v2elintmon, v2eltrnout, v2cacamps_osp, v2caviol_osp)

dat2 <- dat %>%
  left_join(vdem_sub, by = c("year", "vdem" = "country_id"))

dat2 %>%
  filter(v2xel_elecparl == 1) %>%
  group_by(conflict_dummy) %>%
  summarize(media = mean(v2cacamps_osp, na.rm = TRUE))

mod <- lm(v2cacamps_osp ~ conflict_dummy + v2x_polyarchy,
          data = dat2)
broom::tidy(mod)
sjPlot::plot_model(mod, type = "pred")

dat2 %>%
  mutate(psn_index = (v2psprbrch_osp + v2psprlnks_osp)/2) %>%
  summarize(range(psn_index, na.rm = TRUE))
