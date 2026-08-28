
qmd_out <- function(path) {
  file.path("docs", sub("\\.qmd$", ".html", path))
}