
make_pumpkin_prices_data <- function() {
  # data acccessed from https://www.kaggle.com/datasets/usda/a-year-of-pumpkin-prices/data
  # on 2026-10-03 for atlanta
  
  read_csv(here::here("lab", "raw-data", "pumpkin-prices.csv")) |>
    janitor::clean_names() |>
    filter(when_any(variety == "HOWDEN TYPE", variety == "PIE TYPE")) |>
    mutate(id = row_number()) |>
    pivot_longer(c("low_price", "high_price"), names_to = "measurement", values_to = "price") |>
    summarize(
      .by = id,
      city_name = first(city_name),
      price = mean(price),
      date = first(date),
      variety = factor(first(variety)),
      item_size = first(item_size),
      origin = first(origin)
    ) |>
    filter(price > 100)
}