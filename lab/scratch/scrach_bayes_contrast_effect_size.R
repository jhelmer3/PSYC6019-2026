
library(rstanarm)
library(palmerpenguins)
library(emmeans)
library(tidyverse)

library(posterior)

penguins_cleaned <- penguins |>
  filter_out(when_any(is.na(species), is.na(flipper_length_mm)))

m <- stan_glm(flipper_length_mm ~ species, data = penguins_cleaned)

emms <- emmeans(m, "species")
emms

contrs <- pairs(emms)

contr_draws <- as.mcmc.emmGrid(contrs, sep.chains = F)
sigma_draws <- m |> 
  as.data.frame(pars = "sigma") |>
  pull(sigma)

d_draws <- contr_draws |> 
  as_tibble() |> 
  mutate(across(everything(), function(contrast_draws_column) contrast_draws_column / sigma_draws))

d_draws |> 
  pivot_longer(everything(), names_to = "contrast_name", values_to = "d_draw") |> 
  summarize(
    .by = contrast_name,
    mean = mean(d_draw),
    lower_025 = quantile(d_draw, 0.025),
    upper_975 = quantile(d_draw, 0.975),
  )

pairs(emms) |> 
  as_tibble()

m |>
  pluck("stanfit") |>
  glimpse()
