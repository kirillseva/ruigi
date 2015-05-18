#' Define the pipeline and watch it get executed
#'
#' @param remote logical. Choose between a local and remote scheduler.
#' @param tasks list. A list of ruigi_tasks.
#' @param to ruigi_target. The scheduler will stop executing the graph once this target is created.
#'
#' @export
pipeline <- function (tasks, to, remote = FALSE) {
  if (isTRUE(remote)) stop("remote is not yet implemented")
  g <- build_task_graph(tasks)
  g <- topological_sort(g)
  args <- if (missing(to)) list(g) else list(g, to)
  do.call(local_scheduler$new, args)$run()
  invisible(NULL)
}
