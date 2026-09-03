
make_pumpkin_data <- function() {
  tibble(pumpkin = 1:20,
         oct1 = rnorm(20, 12, 3)) |>
    mutate(oct31 = oct1 - rnorm(20, 3, 1),
           across(everything(), ~ round(.x, 2)))
}


