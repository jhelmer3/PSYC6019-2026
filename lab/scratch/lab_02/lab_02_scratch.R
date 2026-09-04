
# kdgsadgdsgh
# install.packages("here")
# install.packages("tidyverse")

library(tidyverse)

here::here()
here::here("lab_02", "world_cup_player_stats.csv")

file.exists(here::here("lab_02", "world_cup_player_stats.csv"))

player_stats <- read.csv(here::here("lab_02", "world_cup_player_stats.csv"))

head(player_stats)

summary(player_stats)
str(player_stats)
glimpse(player_stats)
names(player_stats)


ggplot(data = player_stats, 
       mapping = aes(x = goals, fill = position)) +
  geom_bar(position = "dodge")

ggplot(data = player_stats, 
       mapping = aes(x = goals, fill = position)) +
  geom_bar() +
  facet_wrap("position")


days <- c("Tues", "Wed", "Thurs")
moredays <- c("Teus", "Wed", "Thrus")
sort(days)
class(days)

weekdays_levels <- c("Mon", "Tues", "Wed", "Thurs", "Fri")
weekdays_labels <- c("Mon" = "Monday",
                     "Tues" = "Tuesday",
                     "Wed" = "Wednesday",
                     "Thurs" = "Thursday",
                     "Fri" = "Friday")

factor(moredays, levels = weekdays_levels)
days_fct <- factor(days, levels = weekdays_levels,
                   labels = weekdays_labels, ordered = TRUE)
sort(days_fct)


unique(player_stats$position)

position_levels <- c("GK", "DEF", "MID", "FWD")
position_labels <- c("GK" = "Goalkeeper",
                     "DEF" = "Defense",
                     "MID" = "Midfield",
                     "FWD" = "Forward")
factor(player_stats$position, levels = position_levels,
       labels = position_labels)

player_stats$position_fct <- factor(player_stats$position, levels = position_levels,
                                    labels = position_labels)


ggplot(data = player_stats, 
       mapping = aes(x = goals, fill = position_fct, y = after_stat(prop))) +
  geom_bar() +
  facet_wrap("position_fct") + 
  scale_y_continuous(labels = scales::label_percent()) +
  scale_x_continuous(breaks = 0:10) +
  labs(x = "Goals", y = "Proportion",
       title = "Goals in 2026 World Cup",
       subtitle = "By Position") +
  theme_minimal()



ggplot(player_stats, aes(x = minutes_played)) +
  geom_density()

ggplot(player_stats, aes(x = minutes_played, y = position_fct)) +
  geom_violin() +
  geom_boxplot(width = 0.2) +
  geom_jitter(alpha = 0.4) 




















