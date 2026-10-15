
# install.packages("rstanarm")
# install.packages("bayesplot")
# install.packages("bayestestR")

library(rstanarm)
library(tidyverse)
library(bayesplot)

options(mc.cores = parallel::detectCores())

filtered_mpg <- mpg |>
  filter(when_any(cyl == 4 | cyl == 8)) |>
  mutate(cyl = factor(cyl))

bayes_t_test <- stan_glm(hwy ~ cyl, 
                         data = filtered_mpg,
                         family = "gaussian")
summary(bayes_t_test)
nrow(filtered_mpg)


filtered_mpg$hwy |> mean()

bayes_t_test |>
  summary() |>
  as_tibble(rownames = "params")

prior_summary(bayes_t_test)

rnorm(1000, 24, 17) |> hist()
rexp(1000, rate = 0.15) |> hist()

set.seed(1)

bayes_t_test_v2 <- stan_glm(
  hwy ~ cyl,
  data = filtered_mpg,
  family = "gaussian",
  prior_intercept = normal(24, 12),
  prior = normal(0, 1.5, autoscale = T)
)
summary(bayes_t_test_v2)

posterior_interval(bayes_t_test_v2, prob = .95)
bayestestR::hdi(bayes_t_test_v2, ci = 0.9)


mcmc_areas(bayes_t_test_v2)


mcmc_trace(bayes_t_test_v2)

summary(bayes_t_test_v2) |>
  as_tibble(rownames = "params") |>
  select(params, Rhat)



bayes_t_test_v2 <- stan_glm(
  hwy ~ cyl,
  data = filtered_mpg,
  family = "gaussian",
  prior_intercept = normal(24, 12),
  prior = normal(0, 1.5, autoscale = T),
  iter = 40000,
  diagnostic_file = here::here("lab_07", "bayes_t_test_v2.csv")
)
bayes_t_test_v0 <- stan_glm(
  hwy ~ 1,
  data = filtered_mpg,
  family = "gaussian",
  prior_intercept = normal(24, 12),
  prior = normal(0, 1.5, autoscale = T),
  iter = 40000,
  diagnostic_file = here::here("lab_07", "bayes_t_test_v0.csv")
)

bayestestR::bayesfactor(
  bayes_t_test_v0,
  bayes_t_test_v2
)





















