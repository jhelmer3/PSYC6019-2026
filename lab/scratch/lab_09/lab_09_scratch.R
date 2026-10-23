
library(palmerpenguins)
library(emmeans)
library(tidyverse)

penguins_cleaned <- penguins |>
  filter_out(when_any(is.na(species), is.na(flipper_length_mm)))

flipper_model <- aov(flipper_length_mm ~ species, data = penguins_cleaned)
summary(flipper_model)

emms_flipper <- emmeans(flipper_model, specs = "species")
emms_flipper

emms_flipper |> class()

confint(emms_flipper, level = .99)

plot(emms_flipper) +
  theme_minimal()

emms_flipper_df <- as_tibble(emms_flipper)
emms_flipper_df

emms_flipper_df |>
  ggplot(aes(x = species, y = emmean, ymin = lower.CL, ymax = upper.CL,
             color = species)) +
  geom_violin(data = penguins_cleaned,
              aes(x = species, y = flipper_length_mm, color = species),
              inherit.aes = F) +
  geom_point() +
  geom_errorbar(width = 0.1) +
  scale_y_continuous("Flipper Length EMMs") +
  coord_cartesian(ylim = c(160, 240), clip = "off") +
  labs(caption = "Error bars represent 95% confidence intervals.") +
  guides(x = guide_axis(cap = T),
         y = guide_axis(cap = T)) +
  theme_classic()


emms_flipper

pairs(emms_flipper)

summary(flipper_model)
eff_size(emms_flipper, edf = 339, sigma = sqrt(44))

flipper_model_tidy <- broom::tidy(flipper_model)
flipper_model_tidy

df_residuals <- flipper_model_tidy |>
  filter(term == "Residuals") |>
  pull(df)
ms_w <- flipper_model_tidy |>
  filter(term == "Residuals") |>
  pull(meansq)

eff_size(emms_flipper, edf = df_residuals, sigma = sqrt(ms_w))


penguins_cleaned$species |> levels()
contrast(emms_flipper, method = list(gentoo_vs_others = c(-1/2, -1/2, 1),
                                     gentoo_vs_adelie = c(-1, 0, 1)))


































