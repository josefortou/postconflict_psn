Post-Conflict Party Nationalization
================
Jose Antonio Fortou
2021-03-15

## Introduction

What do postconflict party systems look like, and why are some more
nationalized (i.e. exhibit competition that is both programmatic and
geographically dispersed) than others?

This repository is associated with my dissertation project at Ohio
State. I thank Sarah Brooks, Jan Pierskalla, Cris Gelpi, Austin Knuppe,
Jessiva Maves Braithwaite, John Ishiyama, Irfan Nooruddin, Tom Flores,
Mike Weintraub, among many others.

<!-- ## The Data -->
<!-- This is a time-series cross-sectional panel; each observation is a country-election-year, since the key unit of analysis is the election, characteristics of the country and year it was held in, and the resulting party system.  -->
<!-- ### Elections Around the World -->
<!-- I focus on legislative elections; the number of elections around the world has been on the rise since 1940s. -->
<!-- ```{r} -->
<!-- nelda %>%  -->
<!--   filter(types == "Legislative/Parliamentary") %>% -->
<!--   group_by(year) %>% -->
<!--   count() %>% -->
<!--   ggplot(aes(year, n)) + -->
<!--   geom_col(width = 1) + -->
<!--   scale_x_continuous(breaks = seq(1945, 2015, 5)) + -->
<!--   labs(x = "Year", y = "Number of legislative elections") -->
<!-- ``` -->
<!-- ### Armed Conflict -->
<!-- The universe of cases are elections held during postconflict episodes; this is given on one hand by NELDA and/or V-Dem, and on the other hand by UCDP's list of internal and internal internationalized armed conflicts.  -->
<!-- ```{r} -->
<!-- acd %>% -->
<!--   filter(type_of_conflict %in% c(3, 4)) %>% -->
<!--   group_by(year, type_of_conflict) %>% -->
<!--   count() %>% -->
<!--   ggplot(aes(year, n, fill = factor(type_of_conflict))) + -->
<!--   geom_col(width = 1) + -->
<!--   scale_x_continuous(breaks = seq(1945, 2015, 5)) + -->
<!--   scale_fill_discrete( -->
<!--     name = "Type of conflict",  -->
<!--     labels = c("Internal", "Internationalized") -->
<!--   ) + -->
<!--   labs(x = "Year", y = "Number of armed conflicts") + -->
<!--   theme(legend.position = "bottom") -->
<!-- ``` -->
<!-- ### New Democracies -->
<!-- I compare these elections and their results among themselves, but also to elections in new or consolidating democracies (list taken from the Boix, Miller, and Rosato coding and V-Dem). See, for example, the number of regime transitions per year. -->
<!-- ```{r} -->
<!-- brm %>% -->
<!--   filter(year > 1945, democracy_trans %in% c(-1, 1)) %>% -->
<!--   group_by(year, democracy_trans) %>% -->
<!--   count() %>% -->
<!--   ggplot(aes(year, n, fill = factor(democracy_trans))) + -->
<!--   geom_col(width = 1) + -->
<!--   scale_x_continuous(breaks = seq(1945, 2015, 5)) + -->
<!--   scale_y_continuous(breaks = seq(0, 10, 1)) + -->
<!--   scale_fill_discrete( -->
<!--     name = "Type of transition",  -->
<!--     labels = c("Breakdown", "Democratization") -->
<!--   ) + -->
<!--   labs(x = "Year", y = "Number of transitions") + -->
<!--   theme(legend.position = "bottom") -->
<!-- ``` -->
<!-- ### Party System Nationalization -->
<!-- Party system nationalization data (the dependent variable) come from V-Dem, CLEA for some cases, and data collected from official sites, etc. -->
<!-- ```{r} -->
<!-- vdem %>% -->
<!--   filter(year > 1945) %>% -->
<!--   ggplot(aes(v2psprlnks_osp, v2pscomprg_osp)) + -->
<!--   geom_point(alpha = 0.25, size = 2) + -->
<!--   labs(x = "Party linkages", y = "Party competition across regions") -->
<!-- ``` -->
<!-- The key independent variables are whether there was a peace agreement signed to end conflict, whether it includes provisions for the electoral participation of former combatants, and whether former rebels participated in the election (and how). -->
<!-- ```{r} -->
<!-- mgep %>% -->
<!--   filter(election == 1) %>% -->
<!--   group_by(year, part) %>% -->
<!--   count() %>% -->
<!--   ggplot(aes(year, n, fill = factor(part))) + -->
<!--   geom_col(width = 1) + -->
<!--   scale_x_continuous(breaks = seq(1945, 2010, 5)) + -->
<!--   scale_fill_discrete( -->
<!--     name = "Electoral participation",  -->
<!--     labels = c("No", "Yes") -->
<!--   ) + -->
<!--   labs(x = "Year", y = "Number of rebel groups") + -->
<!--   theme(legend.position = "bottom") -->
<!-- ``` -->
