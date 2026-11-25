
library(palmerpenguins)
library(tidyverse)

m1 <- lm(body_mass_g ~ bill_depth_mm, data = penguins)
summary(m1)

penguins_cleaned <- penguins |>
  drop_na(bill_depth_mm, species, year) |>
  mutate(
    across(
      ends_with("_mm"),
      function(col) (col - mean(col)) / sd(col),
      .names = "{.col}_z"
    ),
    year = year - 2007,
    .after = flipper_length_mm
  ) 


m1 <- lm(body_mass_g ~ bill_depth_mm_z,
         data = penguins_cleaned)
summary(m1)

gtsummary::tbl_regression(m1, intercept = TRUE)


fitted.values(m1) |> hist()


new_data <- tibble(
  bill_depth_mm_z = seq(-3, 3)
)

predict(m1, newdata = new_data)
range(penguins_cleaned$bill_depth_mm_z)

predicted <- tibble(
  bill_depth_mm_z = seq(-3, 3)
) |>
  mutate(
    predicted_y = predict(m1, newdata = tibble(bill_depth_mm_z))
  )

predicted |>
  ggplot(aes(x = bill_depth_mm_z, y = predicted_y)) +
  geom_line() +
  geom_point(
    data = penguins_cleaned,
    aes(y = body_mass_g)
  )


ggeffects::ggpredict(m1, terms = "bill_depth_mm_z") |>
  plot() +
  geom_point(
    data = penguins_cleaned,
    aes(y = body_mass_g, x = bill_depth_mm_z)
  )



m2 <- lm(body_mass_g ~ bill_depth_mm_z + species, data = penguins_cleaned)
gtsummary::tbl_regression(m2, intercept = TRUE)

ggeffects::ggpredict(m2, terms = c("bill_depth_mm_z", "species")) |>
  plot()



m3 <- lm(body_mass_g ~ bill_depth_mm_z + species + year, data = penguins_cleaned)
gtsummary::tbl_regression(m3, intercept = TRUE)


ggeffects::ggpredict(
  m3, 
  terms = c("bill_depth_mm_z", "species", "year")
) |> 
  plot() +
  geom_point(
    data = penguins_cleaned |>
      mutate(facet = paste("year =", year)),
    aes(x = bill_depth_mm_z, y = body_mass_g,
        color = species, fill = species)
  )


ggeffects::ggpredict(m3, terms = c("bill_depth_mm_z", "species", "year")) |>
  plot() +
  geom_point(
    data = penguins_cleaned |> mutate(facet = paste("year =", year)), # needs to match ggpredict's name
    aes(x = bill_depth_mm_z, y = body_mass_g, color = species),
    inherit.aes = FALSE,
    shape = 21,
    alpha = 0.4
  ) 


residuals(m3) |>
  hist()

penguins_cleaned |>
  mutate(
    residual = residuals(m3)
  ) |> 
  ggplot(aes(sample = residual)) +
  geom_qq() +
  geom_qq_line()



penguins_cleaned |>
  mutate(
    residual = residuals(m3)
  ) |> 
  ggplot(aes(y = residual, x = bill_depth_mm_z)) +
  geom_point() +
  geom_smooth()

penguins_cleaned |>
  mutate(
    residual = residuals(m3)
  ) |> 
  ggplot(aes(y = residual, x = species)) +
  geom_jitter() 

penguins_cleaned |>
  mutate(
    residual = residuals(m3)
  ) |> 
  ggplot(aes(y = residual, x = year)) +
  geom_jitter() 



m_numeric_only <- lm(body_mass_g ~ bill_length_mm_z + 
                       bill_depth_mm_z + flipper_length_mm_z, 
                     data = penguins_cleaned)
names(coefficients(m_numeric_only))

car::vif(m_numeric_only)

1 - (1 / car::vif(m_numeric_only))



car::vif(m3)


n_predictors <- length(coef(m3)) - 1
n_observation <- nrow(penguins_cleaned)

cutoff <- 3 * (n_predictors + 1) / n_observation

penguins_cleaned |>
  mutate(hat = hatvalues(m3)) |>
  filter(hat > cutoff)

penguins_cleaned |>
  mutate(
    ext_stud_resid = rstudent(m3)
  )



dffits(m3)


dfbetas_values <- dfbetas(m3) |>
  as_tibble() |>
  rename_with(
    function(col_name) paste0("dfbetas_", col_name)
  )


penguins_cleaned |>
  bind_cols(dfbetas_values) |> View()




























