
N <- 16 # sample size
mu0 <- 0 # null mean
mu1 <- 1 # true population mean
sigma <- 4 # so that sigma / sqrt(N) = 1

n_reps <- 1000


tibble(n_reps = n_reps,
       N = N,
       mu0 = mu0,
       mu1 = mu1,
       sigma = sigma) |>
  uncount(n_reps, .id = "id") |>
  mutate(
    ys = pmap(
      list(N, mu1, sigma), 
      \(N, mu1, sigma) 
      tibble(y = rnorm(N, mu1, sigma))
    ),
    zobs = pmap_dbl(list(ys, N, mu0, sigma), 
                    \(ys, N, mu0, sigma) 
                    (mean(ys$y) - mu0) / (sigma / sqrt(N))),
    p = pnorm(zobs, lower.tail = F)
  ) |>
  summarize(correct_rejections = mean(p < 0.05))
