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