`local_scheduler&initialize` <- function (graph, to) {
  if (missing(graph)) stop("Scheduler requires a non-empty graph of tasks!")
  self$graph <- graph
  if (! missing(to)) {
    stopifnot(is.ruigi_target(to))
    gr <- list(nodes = list(), edges = graph$edges)
    found <- FALSE
    ## If the user specified to parameter, we'd better check if it's valid before execution
    ## and truncate the graph accordingly if validity is verified
    lapply(graph$nodes, function(node) {
      if (! found) {
        if (target_hash(node$task$target) == target_hash(to)) {
          found <<- TRUE
        }
        gr$nodes <<- append(gr$nodes, list(node))
      }
    })
    if (! isTRUE(found)) stop ("The final target you specified is not being created by this pipeline")
    self$graph <- gr
  }
}

`local_scheduler&run` <- function() {
  ## We assume that the graph has already been sorted
  lapply(self$graph$nodes, function(node) {
    if (! isTRUE(node$task$target$exists())) {
      cat(crayon::cyan("Running task: "), node$task$name)
      node$task$runner(node$task$requires, node$task$target)
      if (node$task$target$exists()) {
        cat(crayon::green(" \u2713"), "\n")
      } else {
        cat(crayon::red(" \u2717"), "\n")
        stop(paste0("Something went wrong! This task has finished",
          " running, but the target doesn't exist!"))
      }
    } else {
      cat(crayon::cyan("Skipping: "), crayon::silver(node$task$name), "\n")
    }
  })
}

#' Local scheduler
#' Linearly executes the tasks (if needed)
#' @export
local_scheduler <- R6::R6Class("local_scheduler",
  inherit = ruigi_scheduler,
  public = list(
    initialize = `local_scheduler&initialize`,
    run = `local_scheduler&run`
  )
)
