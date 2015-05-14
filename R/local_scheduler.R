`local_scheduler&initialize` <- function (graph) {
  if (missing(graph)) stop("Scheduler requires a non-empty graph of tasks!")
  self$graph <- graph
}

`local_scheduler&run` <- function() {
  ## We assume that the graph has already been sorted
  lapply(self$graph$nodes, function(node) {
    if (!isTRUE(node$task$target$exists())) {
      cat(crayon::cyan("Running task: "), node$task$name)
      node$task$runner(node$task$requires, node$task$target)
      if (node$task$target$exists()) {
        cat(crayon::green(" ✓"), "\n")
      } else {
        cat(crayon::red(" ✗"), "\n")
        stop(paste0("Something went wrong! This task has finished",
          " running, but the target doesn't exist!"))
      }
    } else {
      cat(crayon::cyan("Skipping: "), crayon::silver(node$task$name), "\n")
    }
  })
}

## Local scheduler
## Linearly executes the tasks (if needed)
#' @export
local_scheduler <- R6::R6Class("local_scheduler",
  inherit = ruigi_scheduler,
  public = list(
    initialize = `local_scheduler&initialize`,
    run = `local_scheduler&run`
  )
)
