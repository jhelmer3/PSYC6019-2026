
library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("tidyverse", "quarto")
)

tar_config_set(
  as_job = T
)

tar_source("lab/R")

list(
  ## main pages
  tar_quarto(index, "index.qmd"),
  tar_quarto(syllabus, "syllabus.qmd"),
  tar_quarto(extra_credit, "extra-credit.qmd"),
  
  ## lab index page
  tar_quarto(lab_index, "lab/lab-index.qmd"),
  
  ## lab 04
  tar_target(gatech_admissions_data, make_gatech_admissions_data()),
  tar_target(gatech_admissions_data_file, 
             write.csv(gatech_admissions_data, "lab/data/gatech_admissions.csv",
                       row.names = F),
             format = "file"),
  tar_target(pumpkin_data, make_pumpkin_data()),
  tar_target(pumpkin_data_file, 
             write.csv(pumpkin_data, "lab/data/pumpkin_data.csv", row.names = F),
             format = "file"),
  tar_target(leaves_data, make_leaves_data()),
  tar_target(leaves_data_file, 
             write.csv(leaves_data, "lab/data/leaves.csv", row.names = F)),
  
  tar_target(lab_04_slides_qmd, 
             "lab/slides/lab_04.qmd", 
             format = "file"),
  tar_target(lab_04_slides, {
    gatech_admissions_data_file
    pumpkin_data_file
    quarto::quarto_render(lab_04_slides_qmd)
    qmd_out(lab_04_slides_qmd)
  }, format = "file"),
  tar_target(lab_04_activity_key_qmd, 
             "lab/activities/activity_keys/lab_04_activity_key.qmd", 
             format = "file"),
  tar_target(lab_04_activity_key, {
    leaves_data_file
    quarto::quarto_render(lab_04_activity_key_qmd)
    qmd_out(lab_04_activity_key_qmd)
  }, format = "file"),
  
  ## lab 03

  tar_target(lab_03_slides_qmd, 
             "lab/slides/lab_03.qmd", 
             format = "file"),
  tar_target(lab_03_slides, {
    player_stats
    gatech_admissions_data_file
    quarto::quarto_render(lab_03_slides_qmd)
    qmd_out(lab_03_slides_qmd)
  }, format = "file"),
  tar_target(lab_03_activity_key_qmd, 
             "lab/activities/activity_keys/lab_03_activity_key.qmd", 
             format = "file"),
  tar_target(lab_03_activity_key, {
    quarto::quarto_render(lab_03_activity_key_qmd)
    qmd_out(lab_03_activity_key_qmd)
  }, format = "file"),
  
  ## lab 02
  tar_target(world_cup_player_stats_file, "lab/raw-data/world_cup_player_stats.csv", format = "file"),
  tar_target(world_cup_teams_file, "lab/raw-data/world_cup_teams.csv", format = "file"),
  tar_target(world_cup_player_stats_full, read.csv(world_cup_player_stats_file)),
  tar_target(world_cup_teams_full, read.csv(world_cup_teams_file)),
  tar_target(player_stats, 
             clean_world_cup_player_stats(world_cup_player_stats_full, world_cup_teams_full)),
  tar_target(player_stats_csv, 
             write.csv(player_stats, "lab/data/world_cup_player_stats.csv", row.names = F),
             format = "file"),
  
  tar_target(lab_02_slides_qmd, 
             "lab/slides/lab_02.qmd", 
             format = "file"),
  tar_target(lab_02_slides, {
    player_stats_csv
    quarto::quarto_render(lab_02_slides_qmd, quiet = F)
    qmd_out(lab_02_slides_qmd)
  }, format = "file"),
  
  tar_target(lab_02_activity_qmd, 
             "lab/activities/lab_02_activity.qmd", 
             format = "file"),
  tar_target(lab_02_activity, {
    quarto::quarto_render(lab_02_activity_qmd)
    qmd_out(lab_02_activity_qmd)
  }, format = "file"),
  
  tar_target(lab_02_activity_key_qmd, 
             "lab/activities/activity_keys/lab_02_activity_key.qmd", 
             format = "file"),
  tar_target(lab_02_activity_key, {
    quarto::quarto_render(lab_02_activity_key_qmd)
    qmd_out(lab_02_activity_key_qmd)
  }, format = "file"),
  
  ## lab 01
  tar_target(lab_01_slides_qmd, 
             "lab/slides/lab_01.qmd", 
             format = "file"),
  tar_target(lab_01_slides, {
    quarto::quarto_render(lab_01_slides_qmd)
    qmd_out(lab_01_slides_qmd)
  }, format = "file"),
  
  tar_target(lab_01_activity_qmd, 
             "lab/activities/lab_01_activity.qmd", 
             format = "file"),
  tar_target(lab_01_activity, {
    quarto::quarto_render(lab_01_activity_qmd)
    qmd_out(lab_01_activity_qmd)
  }, format = "file"),
  
  tar_target(lab_01_activity_key_qmd, 
             "lab/activities/activity_keys/lab_01_activity_key.qmd", 
             format = "file"),
  tar_target(lab_01_activity_key, {
    quarto::quarto_render(lab_01_activity_key_qmd)
    qmd_out(lab_01_activity_key_qmd)
  }, format = "file")

)
