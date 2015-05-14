`local_scheduler&initialize` <- function (nodes) {
  if (missing(nodes)) stop("Scheduler requires a non-empty graph of nodes!")
  self$graph <- nodes
}

`local_scheduler&run` <- function() {
  ## We assume that the graph has already been sorted
  lapply(self$graph$nodes, function(node) {
    if (isTRUE(node$finished)) {
      cat(crayon::cyan("Running task: "), crayon::red(node$task$name))
      node$task$runner(node$task$requires, node$task$target)
      if (node$task$target$exists()) {
        cat(crayon::green(" ✓"), "\n")
      } else {
        stop(paste0("Something went wrong! This task has finished",
          " running, but the target doesn't exist!"))
      }
    } else {
      cat(crayon::cyan("This node was already computed: "), crayon::green(node$task$name), "\n")
    }
  })
}

## Local scheduler
## Linearly executes the tasks (if needed)
local_scheduler <- R6::R6Class("local_scheduler",
  inherit = ruigi_scheduler,
  public = list(
    initialize = `local_scheduler&initialize`,
    run = `local_scheduler&run`
  )
)
