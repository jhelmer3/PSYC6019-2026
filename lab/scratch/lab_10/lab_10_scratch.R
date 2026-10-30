
library(emmeans)
library(rstanarm)
library(palmerpenguins)
library(tidyverse)

penguins_cleaned <- penguins |>
  filter_out(when_any(is.na(species), is.na(flipper_length_mm), is.na(year))) |>
  mutate(year = factor(year),
         id = row_number() |> factor())

flipper_model_twoway <- aov(flipper_length_mm ~ species * year, data = penguins_cleaned)
summary(flipper_model_twoway)

penguins_cleaned |>
  count(species, year)

penguins_cleaned |>
  count(species, year) |>
  pivot_wider(names_from = species, values_from = n)

# install.packages("car")

type_i_model <- summary(flipper_model_twoway)

type_ii_model <- car::Anova(flipper_model_twoway, type = 2)

type_iii_model_wrong <- car::Anova(flipper_model_twoway, type = 3)

options(contrasts = c("contr.sum", "contr.poly"))

flipper_model_twoway <- aov(flipper_length_mm ~ species * year, data = penguins_cleaned)
type_iii_model <- car::Anova(flipper_model_twoway, type = 3)


ez_flipper_model <- ez::ezANOVA(
  data = penguins_cleaned,
  dv = flipper_length_mm,
  wid = id,
  between = c(species, year),
  type = 3
)
ez_flipper_model


penguins_cleaned |>
  ggplot(aes(x = year, y = flipper_length_mm,
             fill = species, color = species)) +
  geom_violin(alpha = 0.4) +
  geom_jitter(position = position_jitterdodge(.9),
              alpha = 0.4) +
  stat_summary(geom = "point", fun = "mean",
               position = position_dodge(.9),
               color = "white", size = 3, shape = 18) +
  labs(caption = "White diamonds represent means.") +
  theme_classic()

effectsize::eta_squared(flipper_model_twoway, partial = T)


flipper_model_twoway_lm <- lm(flipper_length_mm ~ species * year, data = penguins_cleaned)
summary(flipper_model_twoway_lm)

flipper_model_bayes <- stan_glm(
  flipper_length_mm ~ species * year,
  data = penguins_cleaned
)
summary(flipper_model_bayes)
bayesplot::mcmc_trace(flipper_model_bayes, pars = c("year2"))



flipper_model_emms <- emmeans(flipper_model_twoway, specs = c("species", "year"))
flipper_model_emms

sme_by_species <- joint_tests(flipper_model_twoway, by = "species")
sme_by_species

pairs(flipper_model_emms, by = "species")


broom::tidy(flipper_model_twoway)

flipper_model_emms |>
  confint(level = .5)

flipper_model_emms |>
  as_tibble() |>
  ggplot(aes(x = year, y = emmean, 
             ymin = lower.CL, ymax = upper.CL,
             color = species, group = species)) +
  geom_line(position = position_dodge(0.5)) +
  geom_point(position = position_dodge(0.5)) +
  geom_linerange(position = position_dodge(0.5), linewidth = 0.5) +
  scale_color_discrete(palette = "Set2") +
  labs(caption = "Line ranges represent 95% confidence intervals of the mean" |>
         str_wrap(width = 40)) +
  theme_classic()


## plotting multiple confidence levels (95% and 50%)

flipper_model_emms_ci50 <- emmeans(flipper_model_twoway, specs = c("species", "year")) |>
  confint(level = .50)

flipper_model_emms |>
  as_tibble() |>
  ggplot(aes(x = year, y = emmean, 
             ymin = lower.CL, ymax = upper.CL,
             color = species, group = species)) +
  geom_point() +
  geom_line() +
  geom_pointrange() +
  geom_pointrange(data = as_tibble(flipper_model_emms_ci50), linewidth = 2) +
  scale_color_discrete(palette = "Set2") +
  labs(caption = "Thick and thin line ranges represent 50% and 95% confidence intervals of the mean, respectively." |>
         str_wrap(50)) +
  theme_classic()














