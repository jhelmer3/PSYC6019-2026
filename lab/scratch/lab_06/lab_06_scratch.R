
library(tidyverse)

# one-sample

mean_cty <- mean(mpg$cty)
sd_cty <- sd(mpg$cty)

mu_cty <- 30

(mean_cty - mu_cty) / sd_cty

# independent sample

four_cyl_hwy <- mpg |>
  filter(cyl == 4) |>
  pull(hwy)
eight_cyl_hwy <- mpg |>
  filter(cyl == 8) |>
  pull(hwy)

four_cyl_hwy_mean <- mean(four_cyl_hwy)
four_cyl_hwy_sd <- sd(four_cyl_hwy)
four_cyl_hwy_n <- length(four_cyl_hwy)

eight_cyl_hwy_mean <- mean(eight_cyl_hwy)
eight_cyl_hwy_sd <- sd(eight_cyl_hwy) 
eight_cyl_hwy_n <- length(eight_cyl_hwy)

s_pooled <- sqrt(
  ((four_cyl_hwy_n - 1) * four_cyl_hwy_sd^2 +
    (eight_cyl_hwy_n - 1) * eight_cyl_hwy_sd^2) / 
    (four_cyl_hwy_n + eight_cyl_hwy_n - 2)
)  
(four_cyl_hwy_mean - eight_cyl_hwy_mean) / s_pooled

# paired sample

differences <- mpg$cty - mpg$hwy

diff_mean <- mean(differences)
diff_sd <- sd(differences)

diff_mean / diff_sd


effectsize::cohens_d(mpg$cty, mu = 30)$Cohens_d

filtered_mpg <- mpg |>
  filter(when_any(cyl == 4, cyl == 8))

effectsize::cohens_d(hwy ~ cyl, data = filtered_mpg)

effectsize::cohens_d(mpg$cty, mpg$hwy, paired = T)


chick_data <- read_csv(here::here("lab_06", "chick_data.csv"))
chick_data


risk_data <- chick_data |>
  pivot_longer(cols = c("small", "large"),
               names_to = "size", values_to = "count") |>
  mutate(.by = feed, total = sum(count)) |>
  filter(size == "small") |>
  mutate(risk = count / total)

risk_linseed <- risk_data |>
  filter(feed == "linseed") |>
  pull(risk)
risk_soybean <- risk_data |>
  filter(feed == "soybean") |>
  pull(risk)
risk_linseed / risk_soybean

chick_data |>
  mutate(odds = small / large)

## power analysis

library(pwr)

power_test <- pwr.t.test(power = .8,
           sig.level = .05,
           d = .8)

power_test |> glimpse()
power_test$sig.level



sample_sizes <- c(30, 100, 300, 1000)

map_dbl(sample_sizes, identity)

get_power_for_n <- function(my_n) {
  power_test <- pwr.t.test(sig.level = .05,
             d = .25,
             n = my_n)
  power_test$power
}

get_power_for_n(30)


power_values <- map_dbl(sample_sizes, get_power_for_n)

get_power_for_n(100)

tibble(sample_sizes, power_values) |>
  ggplot(aes(x = sample_sizes, y = power_values)) +
  geom_line()

1:10
seq(1, 10, by = 2)

sample_sizes <- seq(10, 300, by = 20)
power_values <- map_dbl(sample_sizes, get_power_for_n)

tibble(sample_sizes, power_values) |>
  ggplot(aes(x = sample_sizes, y = power_values)) +
  geom_hline(aes(yintercept = 0.8), color = "gray", linetype = "dashed") +
  geom_line() +
  theme_classic()


power_values <- map_dbl(
  sample_sizes, 
  function(my_n) {
    power_test <- pwr.t.test(sig.level = .05,
                             d = .25,
                             n = my_n)
    power_test$power
  }
)

power_values_df <- tibble(
  sample_size = seq(10, 300, by = 20)
) |>
  mutate(
    power =  map_dbl(
      sample_sizes, 
      function(my_n) {
        power_test <- pwr.t.test(sig.level = .05,
                                 d = .25,
                                 n = my_n)
        power_test$power
      }
    )
  )

power_values_df |>
  ggplot(aes(x = sample_sizes, y = power_values)) +
  geom_hline(aes(yintercept = 0.8), color = "gray", linetype = "dashed") +
  geom_line() +
  theme_classic()


power_values_df <- tibble(
  sample_size = seq(10, 300, by = 20)
) |>
  expand_grid(d = c(0.4, 0.3, .25, .2)) |>
  mutate(
    power =  map2_dbl(
      sample_size, d,
      function(my_n, my_d) {
        power_test <- pwr.t.test(sig.level = .05,
                                 d = my_d,
                                 n = my_n)
        power_test$power
      }
    )
  )

power_values_df |>
  mutate(d = factor(d)) |>
  ggplot(aes(x = sample_size, y = power, color = d)) +
  geom_hline(aes(yintercept = 0.8), color = "gray", linetype = "dashed") +
  geom_line() +
  theme_classic()











































  
  
  
  
  
  
  
  
  
  
  