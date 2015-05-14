#' Define the pipeline and watch it get executed
#'
#' @param remote logical. Choose between a local and remote scheduler.
#' @param tasks list. A list of ruigi_tasks
#'
#' @export
pipeline <- function (tasks, remote = FALSE) {
  if (isTRUE(remote)) stop("remote is not yet implemented")
  g <- build_task_graph(tasks)
  g <- topological_sort(g)
  tryCatch(local_scheduler$new(g)$run(), error = function(e) cat(e))
  invisible(NULL)
}
