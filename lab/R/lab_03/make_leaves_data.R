
make_leaves_data <- function(n_leaves = 1000) {
  tibble(prob = rnorm(n_leaves)) |>
    mutate(
      color = case_when(
        prob < qnorm(.1) ~ "green",
        prob < qnorm(.4) ~ "red",
        prob < qnorm(.9) ~ "orange",
        prob < qnorm(1) ~ "brown"
      ) |>
        factor(levels = c("green", "red", "orange", "brown"))
    ) |>
    mutate(
      .by = color,
      fallen = case_when(
        color == "green" ~ sample(c("no", "yes"), n(), replace = T, prob = c(.9, .1)),
        color == "red" ~ sample(c("no", "yes"), n(), replace = T, prob = c(.7, .3)),
        color == "orange" ~ sample(c("no", "yes"), n(), replace = T, prob = c(.5, .5)),
        color == "brown" ~ sample(c("no", "yes"), n(), replace = T, prob = c(.3, .7))
      )
    ) |>
    select(-prob)
}