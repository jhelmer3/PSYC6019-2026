
zdist <- tibble(x = seq(-4, 4, length.out = 1000),
                density = dnorm(x))

reps <- 10000
n_people <- 5
n_total <- reps * n_people

mu <- 12
sigma <- 6

d <- tibble(reps = reps,
       n_people = n_people) |>
  uncount(reps, .id = "rep") |>
  uncount(n_people, .remove = F, .id = "person_id") |>
  mutate(y = rnorm(n_total, mu, sigma)) |>
  mutate(
    .by = rep,
    observed_mean = mean(y),
    observed_sd = sd(y),
    observed_se = observed_sd / sqrt(first(n_people)),
    observed_z = (observed_mean - mu) / observed_se
  )

ggplot(d, aes(x = observed_z)) +
  geom_density(color = "steelblue") +
  geom_function(fun = dnorm)
  # geom_line(data = zdist, aes(x = x, y = density))


