
library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("tidyverse")
)

tar_source("lab/R")

list(
  ## syllabus
  tar_quarto(syllabus, "syllabus.qmd"),
  
  ## index page
  tar_quarto(lab_index, "lab/lab-index.qmd"),
  
  ## lab 03
  tar_target(gatech_admissions_data, make_gatech_admissions_data()),
  tar_target(gatech_admissions_data_file, 
             write.csv(gatech_admissions_data, "lab/data/gatech_admissions.csv",
                       row.names = F),
             format = "file"),
  tar_target(leaves_data, make_leaves_data()),
  tar_target(leaves_data_file, 
             write.csv(leaves_data, "lab/data/leaves.csv", row.names = F)),
  tar_quarto(lab_03_slides, "lab/slides/lab_03.qmd", quiet = F),
  tar_quarto(lab_03_activity, "lab/activities/activity_keys/lab_03_activity_key.qmd"),
  
  ## lab 02
  tar_target(world_cup_player_stats_file, "lab/raw_data/world_cup_player_stats.csv", format = "file"),
  tar_target(world_cup_teams_file, "lab/raw_data/world_cup_teams.csv", format = "file"),
  tar_target(world_cup_player_stats_full, read.csv(world_cup_player_stats_file)),
  tar_target(world_cup_teams_full, read.csv(world_cup_teams_file)),
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
