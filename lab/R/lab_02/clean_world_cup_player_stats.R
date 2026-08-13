
clean_world_cup_player_stats <- function(player_stats_full, teams_full) {
  teams <- teams_full |>
    select(team_id, team_name, fifa_code)
  
  player_stats_full |>
    left_join(teams, by = "team_id") |>
    select(-c(team_id, player_id, shots, shots_on_target,
              clean_sheets, penalty_goals, 
              average_rating, data_source, last_verified)) |>
    select(team_name, fifa_code, player_name, everything())
}
