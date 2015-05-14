`ruigi_scheduler&run` <- function(...) {
  stop("Implement a scheduler first, or use one of available schedulers! Look at documentation at http://github.com/kirillseva/ruigi")
}

## interface for building schedulers
#' @export
ruigi_scheduler <- R6::R6Class("ruigi_scheduler",
  public = list(
    graph = NULL,
    run = `ruigi_scheduler&run`
  )
)
