
library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("tidyverse")
)

tar_source("lab/R")

list(
  ## index page
  tar_quarto(lab_index, "lab/lab-index.qmd"),
  
  ## lab 02
  tar_target(world_cup_player_stats_full, read.csv("lab/raw_data/world_cup_player_stats.csv")),
  tar_target(world_cup_teams_full, read.csv("lab/raw_data/world_cup_teams.csv")),
  tar_target(player_stats, 
             clean_world_cup_player_stats(world_cup_player_stats_full, world_cup_teams_full)),
  tar_target(player_stats_csv, 
             write.csv(player_stats, "lab/data/world_cup_player_stats.csv",
                       row.names = F),
             format = "file"),
  tar_quarto(lab_02_slides, "lab/slides/lab_02.qmd"),
  tar_quarto(lab_02_activity, "lab/activities/lab_02_activity.qmd"),
  tar_quarto(lab_02_activity_key, "lab/activities/activity_keys/lab_02_activity_key.qmd"),
  
  ## lab 01
  tar_quarto(lab_01_slides, "lab/slides/lab_01.qmd"),
  tar_quarto(lab_01_activity, "lab/activities/lab_01_activity.qmd"),
  tar_quarto(lab_01_activity_key, "lab/activities/activity_keys/lab_01_activity_key.qmd")

)
