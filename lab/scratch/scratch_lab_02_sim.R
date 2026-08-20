
library(tidyverse)


sim <- tibble(x = rnorm(100, mean = 10, sd = 3))

mean(sim$x)


n_reps <- 3000
sample_size <- 100

dat <- tibble(
  rep = 1:n_reps,
  draws = map(rep,
              \(rep) tibble(
                normal = rnorm(sample_size, 4, 2),
                exponential = rexp(sample_size, 1),
                uniform = runif(sample_size, 0, 10),
                chisq = rchisq(sample_size, df = 4)
              ))
) |>
  unnest(draws) |>
  pivot_longer(-rep,
               names_to = "distribution", values_to = "draw")

dat |>
  ggplot(aes(x = draw, y = distribution, fill = distribution)) +
  ggridges::geom_density_ridges()

means <- dat |>
  summarize(.by = c(rep, distribution),
            sample_mean = mean(draw))

means |>
  ggplot(aes(x = sample_mean, y = distribution, fill = distribution)) +
  ggridges::geom_density_ridges()


## sim without {purrr}

n_reps <- 3000
sample_size <- 300
total_n <- n_reps * sample_size

draws <- tibble(
  reps = n_reps,
  sample_size = sample_size
) |>
  uncount(n_reps, .id = "rep") |>
  uncount(sample_size, .id = "sample_id") |>
  mutate(
    normal = rnorm(total_n, mean = 5, sd = 2),
    uniform = runif(total_n, min = 0, max = 10),
    chi_squared = rchisq(total_n, df = 1)
  ) |>
  pivot_longer(!c(reps, rep, sample_id),
               names_to = "distribution", values_to = "draw")

draws |>
  ggplot(aes(x = draw, y = distribution, fill = distribution)) +
  ggridges::geom_density_ridges(alpha = 0.8)

draws |>
  filter(rep %in% sample(n_reps, size = 30)) |>
  ggplot(aes(x = draw, y = distribution, 
             color = distribution, group = interaction(distribution, rep))) +
  ggridges::geom_density_ridges(alpha = 0.8, fill = NA) +
  theme_classic(base_size = 14) +
  guides(x = guide_axis(cap = T),
         y = guide_axis(cap = T),
         color = guide_none())

means <- draws |>
  summarize(.by = c(rep, distribution),
            sample_mean = mean(draw))
means |>
  ggplot(aes(x = sample_mean, y = distribution, fill = distribution)) +
  ggridges::geom_density_ridges()


## changing n

n_reps <- 1000
sample_size <- c(3, 10, 30, 100)
total_n <- sum(n_reps * sample_size)

draws <- tibble(
  reps = n_reps,
  sample_size = sample_size
) |>
  uncount(n_reps, .id = "rep") |>
  uncount(sample_size, .id = "sample_id", .remove = F) |>
  mutate(
    normal = rnorm(total_n, mean = 3, sd = 2),
    uniform = runif(total_n, min = 0, max = 6),
    chi_squared = rchisq(total_n, df = 1)
  ) |>
  pivot_longer(!c(reps, rep, sample_id, sample_size),
               names_to = "distribution", values_to = "draw")

draws |>
  ggplot(aes(x = draw, y = distribution, fill = distribution)) +
  ggridges::geom_density_ridges(alpha = 0.8)

draws |>
  filter(rep %in% sample(n_reps, size = 30)) |>
  ggplot(aes(x = draw, y = distribution, 
             color = distribution, group = interaction(distribution, rep))) +
  ggridges::geom_density_ridges(alpha = 0.8, fill = NA) +
  theme_classic(base_size = 14) +
  guides(x = guide_axis(cap = T),
         y = guide_axis(cap = T),
         color = guide_none()) +
  facet_wrap(~ sample_size)

means <- draws |>
  summarize(.by = c(rep, distribution, sample_size),
            sample_mean = mean(draw))
means |>
  ggplot(aes(x = sample_mean, y = distribution, fill = distribution)) +
  ggridges::geom_density_ridges() +
  facet_wrap(~ sample_size, nrow = 1)

























