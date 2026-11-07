
library(tidyverse)
library(rstanarm)

chick_data <- read_csv(here::here("lab_11", "chick_week_data.csv"))
chick_data

psych::describe(chick_data)

chick_data |>
  summarize(
    .by = chick,
    week = n_distinct(week),
    diet = n_distinct(diet)
  ) |>
  summary()


chick_cleaned <- chick_data |>
  mutate(
    across(c(chick, week, diet), factor),
    week = paste0("week_", week)
  )
chick_cleaned

paste(1, 2)
paste(1, 2, "hello", sep = "_")
paste0(1, 2, "hello")


chick_data |>
  mutate(
    across(everything(), 
           function(column) (column - mean(column)) / sd(column),
           .names = "{.col}_z")
  )

chick_data |>
  summarize(
    .by = diet,
    across(
      where(is.numeric),
      list(
        mean = mean,
        min = min,
        max = max
      )
    )
  )

within_model <- ez::ezANOVA(
  data = chick_cleaned,
  dv = weight,
  wid = chick,
  within = week
)
within_model

within_model |> class()


within_model$ANOVA |> class()

chick_cleaned |>
  pivot_wider(names_from = week,
              values_from = weight,
              names_prefix = "week_") |>
  select(starts_with("week_")) |>
  cov()


emmeans::emmeans(within_model, specs = "week") 


within_model_afex <- afex::aov_ez(
  data = chick_cleaned,
  dv = "weight",
  id = "chick",
  within = "week"
)
within_model_afex
summary(within_model_afex)

emms_week <- emmeans::emmeans(within_model_afex, specs = "week")
emms_week

# install.packages("ggdist")


emms_week |>
  as_tibble() |>
  ggplot(aes(x = week, y = emmean)) +
  ggdist::geom_dots(
    data = chick_cleaned,
    aes(y = weight)
  ) +
  geom_point() +
  geom_pointrange(aes(ymin = lower.CL, ymax = upper.CL)) +
  scale_x_discrete("Week", labels = parse_number) +
  labs(caption = "Line ranges represent 95% confidence intervals of the mean.") +
  theme_classic()




between_model_afex <- afex::aov_ez(
  data = chick_cleaned,
  dv = "weight",
  id = "chick",
  within = "week",
  between = "diet"
)
between_model_afex
summary(between_model_afex)

emms_week_diet <- emmeans::emmeans(
  between_model_afex,
  specs = c("week", "diet")
)
emms_week_diet


emms_week_diet |>
  as_tibble() |>
  ggplot(aes(x = week, y = emmean, color = diet)) +
  geom_line(aes(group = diet),
            position = position_dodge(.5)) +
  ggdist::geom_dots(
    data = chick_cleaned,
    aes(y = weight),
    position = position_dodge(.5)
  ) +
  geom_pointrange(aes(ymin = lower.CL, ymax = upper.CL),
                  position = position_dodge(.5)) +
  scale_x_discrete("Week", labels = parse_number) +
  facet_wrap("diet") +
  labs(caption = "Line ranges represent 95% confidence intervals of the mean.") +
  theme_classic()


# install.packages("lme4")

chicks_mlm <- lme4::lmer(
  weight ~ week * diet + (1 | chick),
  data = chick_cleaned
)
summary(chicks_mlm)


chicks_mlm_stan <- stan_lmer(
  weight ~ week * diet + (1 | chick),
  data = chick_cleaned
)
summary(chicks_mlm_stan)




























