
library(tidyverse)
library(palmerpenguins)

cov(penguins$flipper_length_mm, penguins$body_mass_g, use = "complete.obs")

penguins |>
  select(flipper_length_mm, body_mass_g) |>
  cov(use = "complete.obs")
var(penguins$flipper_length_mm, na.rm = T)


cor(penguins$flipper_length_mm, penguins$body_mass_g, use = "complete.obs")
penguins |>
  select(flipper_length_mm, body_mass_g) |>
  cor(use = "complete.obs")

penguins |>
  select(flipper_length_mm, body_mass_g) |>
  rstatix::cor_test()

penguins |>
  rstatix::cor_test(vars = c("flipper_length_mm", "body_mass_g"))


penguins |>
  select(flipper_length_mm, body_mass_g, 
         bill_length_mm, bill_depth_mm) |>
  cor(use = "pairwise.complete.obs")

penguins |>
  select(flipper_length_mm, body_mass_g,
         bill_length_mm) |>
  rstatix::cor_test() |>
  filter(var1 < var2)

penguins |>
  select(flipper_length_mm, body_mass_g,
         bill_length_mm, bill_depth_mm) |>
  rstatix::cor_test() |>
  filter(var1 < var2)



penguins_ordered <- penguins |>
  mutate(
    across(
      c(bill_length_mm, bill_depth_mm),
      \(column) cut_number(
        column,
        n = 3,
        labels = c("low", "med", "high"),
        ordered_result = TRUE
      ),
      .names = "{.col}_ordered"
    )
  ) |>
  select(ends_with("_ordered"))
penguins_ordered

penguins_ordered |>
  mutate(across(everything(), as.numeric)) |>
  cor(method = "kendall", use = "complete.obs")

penguins_ordered |>
  mutate(across(everything(), as.numeric)) |>
  rstatix::cor_test(method = "spearman")


## scatterplots


penguins |>
  ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()


diamonds |>
  slice_sample(n = 1000) |>
  ggplot(aes(x = carat, y = price)) +
  geom_point(alpha = 0.1, shape = 16, size = 2)



r <- cor(penguins$flipper_length_mm, penguins$body_mass_g, 
         use = "complete.obs")
r_label <- paste("italic(r) ==", round(r, 2))

penguins |>
  ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point() +
  geom_smooth(method = "lm", color = "salmon", fill = "salmon") +
  annotate(geom = "text", 
           label = r_label, 
           x = 185, 
           y = 5500, 
           parse = TRUE)


# install.packages("GGally")

penguins |>
  select(flipper_length_mm, body_mass_g, 
         bill_depth_mm, bill_length_mm) |>
  GGally::ggpairs(
    lower = list(continuous = "smooth")
  )

penguins |>
  ggplot(aes(x = flipper_length_mm)) +
  geom_density()



## regression

bill_model <- lm(bill_depth_mm ~ bill_length_mm, data = penguins)
summary(bill_model)


broom::tidy(bill_model)

summary(bill_model)$r.squared


coefficients(bill_model) |>
  pluck("(Intercept)")

coefficients(bill_model)["bill_length_mm"]





penguins_cleaned <- penguins |>
  mutate(across(
    c(bill_depth_mm, bill_length_mm),
    function(bill_column)
      (bill_column - mean(bill_column, na.rm = T)) / sd(bill_column, na.rm = T),
    .names = "{.col}_z"
  )) 
penguins_cleaned

options(scipen = 999)
bill_model_z <- lm(bill_depth_mm_z ~ bill_length_mm_z, data = penguins_cleaned)
summary(bill_model_z)
















































































