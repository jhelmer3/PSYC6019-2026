
library(tidyverse)

## chi-squared test of goodness of fit


df <- 5 - 1
chisq_crit <- qchisq(p = 0.95, df = df)

major_data <- read_csv(here::here("lab_04", "major_data.csv"))
glimpse(major_data)

table(major_data$major)

counted_major_data <- major_data |>
  count(major)

chisq_stat <- (51 - 40)^2 / 40 + 
  (32 - 40)^2 / 40 +
  (52 - 40)^2 / 40 +
  (32 - 40)^2 / 40 +
  (33 - 40)^2 / 40
chisq_stat

chisq_stat > chisq_crit
1 - pchisq(chisq_stat, df = df)


chisq_test <- counted_major_data |>
  select(n) |>
  chisq.test()
chisq_test |>
  glimpse()

chisq_test$p.value
chisq_test$expected


## chi-squared test of independence


df <- (2 - 1) * (2 - 1)
chisq_crit <- qchisq(0.95, df = df)

major_data

table(major_data$school_type, major_data$parent_in_stem)

major_data |>
  count(school_type, parent_in_stem)

major_data |>
  count(school_type)
major_data |>
  count(parent_in_stem)
major_data |>
  count()
major_data |> nrow()

115 * 91 / 200
85 * 91 / 200

chisq_test <- (59 - 52.3)^2 / 52.3 +
  (32 - 38.7)^2 / 38.7 +
  (53 - 46.3)^2 / 46.3 +
  (56 - 62.7)^2 / 62.7
chisq_test

chisq_test > chisq_crit
1 - pchisq(chisq_test, df = df)


table(major_data$parent_in_stem, major_data$school_type) |>
  chisq.test()

chisq_test <- major_data |>
  count(school_type, parent_in_stem) |>
  pivot_wider(names_from = school_type, values_from = n) |>
  select(-parent_in_stem) |>
  chisq.test()

chisq_test$expected


major_data |>
  ggplot(aes(x = parent_in_stem, fill = school_type)) +
  geom_bar(position = "dodge")




















































































