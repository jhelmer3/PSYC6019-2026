
make_major_data <- function(n_students = 200) {
  majors <- c("STEM", "Humanities", "Social Sciences", "Arts", "Business")
  parent_in_stem <- c("Yes", "No")
  
  tibble(n_students = n_students) |>
    uncount(n_students, .id = "student_id") |>
    mutate(
      school_type = sample(c("STEM School", "Non-STEM School"), n_students, replace = T),
      major = map_chr(
        school_type,
        \(school_type) case_when(
          school_type == "STEM School" ~ sample(majors, 1, prob = c(0.6, 0.03, 0.07, 0.05, 0.25)),
          school_type == "Non-STEM School" ~ sample(majors, 1, prob = c(0.08, 0.27, 0.25, 0.15, 0.25))
        )
      ),
      parent_in_stem = map_chr(
        school_type,
        \(school_type) case_when(
          school_type == "STEM School" ~ sample(parent_in_stem, 1, prob = c(0.65, 0.35)),
          school_type == "Non-STEM School" ~ sample(parent_in_stem, 1, prob = c(0.5, 0.5))
        )
      ),
      age = rnorm(n_students, 21, 1) |> round()
    )  
}


