
plt_posterior_samples <- function() {
  n <- 10
  k <- 2
  
  a <- 8
  b <- 6
  
  x <- seq(0, 1, length.out = 500)
  
  curves <- bind_rows(
    tibble(x, y = dbeta(x, a, b), curve = "Prior"),
    tibble(x, y = choose(n, k) * x^k * (1 - x)^(n - k) * 8, curve = "Likelihood"),
    tibble(x, y = dbeta(x, a + k, b + n - k), curve = "Posterior")
  ) |>
    mutate(hjust = recode_values(
      curve,
      "Prior" ~ 0.1,
      "Posterior" ~ 0.7,
      "Likelihood" ~ 0.36
      
    ))
  
  post_mode <- (a + k - 1) / (a + b + n - 2)
  post_peak <- dbeta(post_mode, a + k, b + n - k)
  
  just_prior_and_likelihood <- curves |>
    filter(curve == "Prior" | curve == "Likelihood")
  
  n_samples <- 4000
  
  set.seed(2)
  posterior_samples <- tibble(
    t = 1:n_samples,
    x = rbeta(n_samples, a + k, b + n - k)
  )
  
  # --- which sample counts get their own step -------------------------------
  n_single <- 30   # first 30 draws appear one at a time
  schedule <- unique(c(
    0:n_single,
    round(n_single * (n_samples / n_single)^seq(0, 1, length.out = 50))
  ))
  n_states <- length(schedule)
  
  # --- relative duration of each step: exponential decay --------------------
  speed <- exp(seq(log(1), log(0.2), length.out = n_states))
  #   1 = first step, 0.06 = last step is ~16x quicker; adjust to taste
  
  sample_frames <- map2(
    schedule, lag(schedule, default = 0),
    \(f, prev) posterior_samples |>
      filter(t <= f) |>
      mutate(frame = f, is_new = t > prev)
  ) |>
    list_rbind()
  
  # --- your static plot, unchanged, just assigned ---------------------------
  base_plot <- just_prior_and_likelihood |>
    ggplot(aes(x, y, label = curve, linetype = curve)) +
    geomtextpath::geom_textline(
      aes(color = curve),
      linewidth = 1,
      hjust = just_prior_and_likelihood$hjust,            # position of label along each curve (0-1)
      vjust = -0.2,           # sit just above the line
      size = 5
    ) +
    annotate("curve",
             x = post_mode + 0.225, xend = post_mode + 0.08,
             y = post_peak * 0.97, yend = post_peak * 0.92,
             arrow = arrow(length = unit(0.25, "cm"), type = "closed"),
             linewidth = 0.6, color = scales::col_darker("#8C7AAE", 30)) +
    annotate("text",
             x = post_mode + 0.25, y = post_peak * 0.94,
             label = "Can be difficult or impossible\nto analytically calculate" |>
               str_wrap(25),
             hjust = 0, size = 4.5, lineheight = 0.9, 
             color = scales::col_darker("#8C7AAE", 30)) +
    scale_linetype_manual(values = c(Prior = "dotted", Likelihood = "dashed", Posterior = "solid")) +
    scale_color_manual(values = c(Prior = "steelblue", Likelihood = "#D98282", Posterior = "#8C7AAE")) +
    coord_cartesian(xlim = c(0, 1), ylim = c(0, 4.1), clip = "off") +
    theme_void() +
    theme(legend.position = "none")
  
  # --- animated layers ------------------------------------------------------
  post_col <- "#8C7AAE"
  
  p <- base_plot +
    geom_density(
      data = filter(sample_frames, frame == 0 | frame >= 2),   # density needs >= 2 points
      aes(x = x),
      inherit.aes = FALSE,
      fill = post_col, color = post_col, alpha = 0.3, linewidth = 1
    ) +
    geom_segment(
      data = sample_frames,
      aes(x = x, xend = x, y = 0, yend = 0.2, group = t, alpha = is_new),
      inherit.aes = FALSE,
      color = scales::col_darker(post_col, 30), linewidth = 0.7
    ) +
    scale_alpha_manual(values = c(`TRUE` = 1, `FALSE` = 0.35), guide = "none") +
    geom_text(
      data = sample_frames,
      aes(label = paste0("n = ", frame)),
      x = 0, y = 4, hjust = 0,
      inherit.aes = FALSE,
      color = post_col, size = 5
    ) +
    guides(color = guide_none(),
           alpha = guide_none()) +
    theme_void() +
    theme(plot.title = element_text(size = 14, color = "grey40", hjust = 0.02),
          legend.position = "none")
  
  anim <- p +
    transition_states(
      frame,
      transition_length = 2 * speed,
      state_length      = 2 * speed,
      wrap = FALSE
    ) +
    enter_fade() +
    ease_aes("cubic-in-out")
  
  animate(anim, nframes = 900 + 45 + 120, fps = 30, 
          width = 5, height = 3, units = "in", res = 300,
          start_pause = 0,
          end_pause = 0, 
          renderer = av_renderer(here::here("lab", "media", "lab_07", "posterior_sampling_unedited.mp4")))
  
  system2("ffmpeg", c(
    "-y", "-i", shQuote(here::here("lab", "media", "lab_07", "posterior_sampling_unedited.mp4")),
    "-vf", shQuote("tpad=start_mode=clone:start_duration=1.5:stop_mode=clone:stop_duration=4"),
    shQuote(here::here("lab", "media", "lab_07", "sampling_posterior.mp4"))
  ))
  
  here::here("lab", "media", "lab_07", "sampling_posterior.mp4")
}