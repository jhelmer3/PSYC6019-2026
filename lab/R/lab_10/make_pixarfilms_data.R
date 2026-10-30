
make_pixarfilms_data <- function() {
  read_csv("https://raw.githubusercontent.com/erictleung/pixarfilms/main/data-raw/pixar_films.csv") |>
    mutate() |>
    left_join(
      read_csv("https://raw.githubusercontent.com/erictleung/pixarfilms/main/data-raw/pixar_franchises.csv"),
      by = "film"
    ) |>
    left_join(
      read_csv("https://raw.githubusercontent.com/erictleung/pixarfilms/main/data-raw/public_response.csv"),
      by = "film"
    ) |>
    mutate(
      in_franchise = !is.na(franchise),
      era = case_when(
        between(release_date, ymd("1990-01-01"), ymd("2010-12-31")) ~ "1990s-2000s",
        between(release_date, ymd("2011-01-01"), ymd("2029-12-31")) ~ "2010s-2020s"
      ),
      across(where(is.character), factor)
    ) |>
    select(film, release_date, run_time, film_rating, era, 
           rotten_tomatoes_score, imdb_score) 
}


