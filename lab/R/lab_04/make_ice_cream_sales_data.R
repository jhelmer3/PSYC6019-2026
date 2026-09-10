
make_ice_cream_sales_data <- function() {
  n_obs_each <- 20
  
  vanilla_mean <- 10
  vanilla_sd <- 3
  
  cookie_dough_mean <- 15
  cookie_dough_sd <- 5
  
  tibble(flavor = c("vanilla", "cookie_dough"),
         mean = c(vanilla_mean, cookie_dough_mean),
         sd = c(vanilla_sd, cookie_dough_sd),
         n_obs_each = n_obs_each) |>
    uncount(n_obs_each, .id = "id") |>
    mutate(sales = rnorm(n_obs_each * 2, mean, sd) |> round(2)) |>
    select(flavor, sales)
}


