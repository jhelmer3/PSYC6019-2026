library(tidyverse)

mpg
summary(mpg)

mpg$cty

cty_mean <- mean(mpg$cty)
cty_mu <- 30
cty_sd <- sd(mpg$cty)
cty_n <- length(mpg$cty)

df <- cty_n - 1

.05 / 2
.05 / 2 + (1 - .05)

qt(c(0.1, 0.5, 0.9), df = 3)
t_crits <- qt(c(.025, .975), df = df)

se <- cty_sd / sqrt(cty_n)
(t_stat_obs <- (cty_mean - cty_mu) / se)

cty_t_test <- t.test(mpg$cty, mu = 30)
cty_t_test$statistic
cty_t_test$p.value

cty_mean + t_crits * se
cty_t_test$conf.int

mpg |>
  ggplot(aes(sample = cty)) +
  geom_qq() +
  geom_qq_line()

mpg |>
  ggplot(aes(x = cty)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 3) +
  geom_density()


t.test(mpg$cty, mu = 50, alternative = "less")


filtered_mpg <- mpg |>
  filter(when_any(cyl == 4, cyl == 8))

four_cyl_hwy <- filtered_mpg |>
  filter(cyl == 4) |>
  pull(hwy)
eight_cyl_hwy <- filtered_mpg |>
  filter(cyl == 8) |>
  pull(hwy)

four_cyl_hwy_mean <- mean(four_cyl_hwy)
four_cyl_hwy_sd <- sd(four_cyl_hwy)
four_cyl_hwy_n <- length(four_cyl_hwy)

eight_cyl_hwy_mean <- mean(eight_cyl_hwy)
eight_cyl_hwy_sd <- sd(eight_cyl_hwy)
eight_cyl_hwy_n <- length(eight_cyl_hwy)

df <- (four_cyl_hwy_n - 1) + (eight_cyl_hwy_n - 1)

t_crits <- qt(c(.025, .975), df = df)

sd_pooled <- sqrt((
  (four_cyl_hwy_n - 1) * four_cyl_hwy_sd^2 +
    (eight_cyl_hwy_n - 1) * eight_cyl_hwy_sd^2
) /  df)

se <- sd_pooled * sqrt( 
  (1 / four_cyl_hwy_n) + (1 / eight_cyl_hwy_n) 
  )

t_stat_obs <- (four_cyl_hwy_mean - eight_cyl_hwy_mean) / se
t_stat_obs
t_crits

1 - pt(t_stat_obs, df = df)


t.test(hwy ~ cyl, data = filtered_mpg)

filtered_mpg |>
  mutate(cyl = factor(cyl)) |>
  ggplot(aes(sample = hwy, group = cyl, color = cyl)) +
  geom_qq() +
  geom_qq_line()


## paired samples


ice_cream_sales <- read_csv(here::here("lab_05", "ice_cream_sales_data.csv"))


ice_cream_cleaned <- ice_cream_sales |>
  pivot_wider(names_from = flavor, values_from = sales) |>
  mutate(difference = vanilla - cookie_dough)

difference_mean <- mean(ice_cream_cleaned$difference)
difference_sd <- sd(ice_cream_cleaned$difference)
difference_n <- length(ice_cream_cleaned$difference)

df <- difference_n - 1
t_crits <- qt(c(.025, .975), df = df)

t_stat_obs <- difference_mean / 
  (difference_sd / sqrt(difference_n))
t_stat_obs

t.test(ice_cream_cleaned$vanilla, ice_cream_cleaned$cookie_dough,
       paired = T)

ice_cream_sales |>
  ggplot(aes(x = flavor, y = sales)) +
  stat_summary(fun.data = "mean_se")















