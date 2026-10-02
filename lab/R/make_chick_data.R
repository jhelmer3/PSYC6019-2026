
make_chick_data <- function() {
  chickwts |> 
    as_tibble() |> 
    mutate(size = ifelse(weight > 250, "large", "small")) |>
    count(feed, size) |>
    filter(when_any(feed == "soybean", feed == "linseed", feed == "sunflower")) |>
    pivot_wider(names_from = size, values_from = n, values_fill = 0) |>
    select(feed, small, large)
}