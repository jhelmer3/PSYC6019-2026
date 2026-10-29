
make_chick_week_data <- function() {
  ChickWeight |>
    mutate(week = floor(Time / 7)) |>
    slice_tail(by = c(Chick, week), n = 1) |>
    select(chick = Chick, diet = Diet, week, weight) |>
    complete(chick, week) |>
    filter_out(.by = chick, sum(is.na(weight)) > 0) |>
    select(chick, diet, week, weight) |>
    arrange(chick)
}