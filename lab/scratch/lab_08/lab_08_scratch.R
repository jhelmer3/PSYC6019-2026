
library(tidyverse)
library(palmerpenguins)
penguins

mean(penguins$flipper_length_mm)
c(NA, 1, 2, 3, 4) |> mean()
mean(penguins$flipper_length_mm, na.rm = T)
sd(penguins$flipper_length_mm, na.rm = T)

sum(penguins$flipper_length_mm) / length(penguins$flipper_length_mm)
sum(penguins$flipper_length_mm, na.rm = T) / 
  length(penguins$flipper_length_mm)
c(NA, 1, 2, 3, 4) |> length()


penguins_cleaned <- penguins |>
  filter_out(when_any(is.na(species), is.na(flipper_length_mm)))
c(NA, 1, 2, 3, 4) |> is.na()


mean(penguins$flipper_length_mm, na.rm = T)
sum(penguins_cleaned$flipper_length_mm, na.rm = T) / 
  length(penguins_cleaned$flipper_length_mm)


flipper_model <- aov(flipper_length_mm ~ species,
                     data = penguins)
summary(flipper_model)


effectsize::eta_squared(flipper_model)$Eta2

effectsize::omega_squared(flipper_model)$Omega2


penguins_cleaned |>
  ggplot(aes(y = species, x = flipper_length_mm,
             fill = species, color = species)) +
  geom_violin(alpha = 0.3) +
  geom_jitter(width = 0, alpha = 0.3, shape = 16, size = 2) +
  geom_boxplot(width = 0.2, alpha = 0.3) +
  stat_summary(geom = "point", fun = "mean", color = "white") +
  theme_classic()


flipper_model_lm <- lm(flipper_length_mm ~ species,
                       data = penguins_cleaned)
summary(flipper_model_lm)

contrasts(penguins_cleaned$species)
contrasts(penguins_cleaned$species) <- contr.sum
contrasts(penguins_cleaned$species)

flipper_model_lm_effect <- lm(flipper_length_mm ~ species,
                              data = penguins_cleaned)
summary(flipper_model_lm_effect)


penguins_cleaned$species_reordered <- factor(penguins_cleaned$species,
                                             levels = c("Gentoo", "Chinstrap", "Adelie"))
contrasts(penguins_cleaned$species_reordered)
contrasts(penguins_cleaned$species_reordered) <- contr.sum
contrasts(penguins_cleaned$species_reordered)

contrasts(penguins_cleaned$species) <- contr.treatment
contrasts(penguins_cleaned$species)


flipper_model_bayes <- rstanarm::stan_glm(
  flipper_length_mm ~ species,
  data = penguins_cleaned,
  family = "gaussian"
)
summary(flipper_model_bayes) |>
  as_tibble(rownames = "params")

bayesplot::mcmc_trace(flipper_model_bayes)

rstanarm::prior_summary(
  flipper_model_bayes
)
















