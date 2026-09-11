
library(tidyverse)

table1

table2 |>
  pivot_wider(names_from = type, values_from = count) |>
  pivot_longer(cols = c("cases", "population"),
               names_to = "type", values_to = "count")

player_stats <- read.csv(here::here("lab_02", "world_cup_player_stats.csv"))
head(player_stats)


glimpse(player_stats)

player_minutes_played <- player_stats |>
  select(player_name, team_name, minutes_played)

player_stats |>
  select(starts_with("a")) |>
  glimpse()

players_hours_played <- player_minutes_played |>
  mutate(hours_played = minutes_played / 60,
         hours_played_round = round(hours_played, 2))

players_hours_played$hours_played |> quantile(probs = c(0.3, 0.6))

players_hours_played$hours_played |> quantile(probs = c(.999))

top_hours_played <- players_hours_played |>
  filter(hours_played >= quantile(hours_played, probs = 0.99))



players_hours_played |>
  summarize(
    .by = team_name,
    mean_hours_played = mean(hours_played),
    median_hours_played = mean(hours_played)
  )

players_hours_played |>
  arrange(desc(hours_played)) |>
  head(5)



player_stats |>
  summarize(.by = team_name,
            total_goals = sum(goals)) |>
  arrange(desc(total_goals))


player_stats |>
  summarize(.by = team_name,
            total_goals = sum(goals)) |>
  filter(total_goals == max(total_goals))


player_stats |>
  filter(position == "GK" & matches_played > 0) 

player_stats |>
  filter(when_all(position == "GK",
                  matches_played > 0))

player_stats |>
  filter(position == "GK") |>
  filter(matches_played > 0) |>
  mutate(saves_per_match = saves / matches_played) |>
  arrange(desc(saves_per_match)) |>
  head()


## simulation

rnorm(5, mean = 1, sd = 0.5) |> mean()

n_reps <- 1000
sample_size <- 10
total_n <- n_reps * sample_size

sim_data <- tibble(sample_size = sample_size,
                   n_reps = n_reps) |>
  uncount(n_reps, .id = "rep_id") |>
  uncount(sample_size, .id = "sample_id") |>
  mutate(draw = rnorm(total_n, 1, 0.5))

means <- sim_data |>
  summarize(.by = rep_id,
            sample_mean = mean(draw))


sim_data |>
  ggplot(aes(x = draw)) +
  geom_density() +
  coord_cartesian(xlim = c(-1, 3)) +
  labs(title = "Sample Distribution")

means |>
  ggplot(aes(x = sample_mean)) +
  geom_density() +
  coord_cartesian(xlim = c(-1, 3)) +
  labs(title = "Sampling Distribution")




runif(10000, min = -1, max = 3) |> hist()
rchisq(10000, df = 1) |> hist()


n_reps <- 1000
sample_size <- 50
total_n <- n_reps * sample_size

sim_data <- tibble(sample_size = sample_size,
                   n_reps = n_reps) |>
  uncount(n_reps, .id = "rep_id") |>
  uncount(sample_size, .id = "sample_id") |>
  mutate(
    draw_normal = rnorm(total_n, 1, 0.5),
    draw_uniform = runif(total_n, -1, 3),
    draw_chisquared = rchisq(total_n, df = 1)
    ) |>
  pivot_longer(cols = starts_with("draw"),
               names_to = "distribution", values_to = "draw")

means <- sim_data |>
  summarize(.by = c(distribution, rep_id),
            sample_mean = mean(draw))


sim_data |>
  ggplot(aes(x = draw)) +
  geom_density() +
  facet_wrap("distribution") +
  coord_cartesian(xlim = c(-1, 3)) +
  labs(title = "Sample Distribution")

means |>
  ggplot(aes(x = sample_mean)) +
  geom_density() +
  facet_wrap("distribution") +
  coord_cartesian(xlim = c(-1, 3)) +
  labs(title = "Sampling Distribution")














































