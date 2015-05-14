## The mission of the pipeline is to take a list of nodes,
## build the dependency graph and give it to the scheduler.
## The scheduler, in turn, should take this graph and execute the unfinished nodes.
build_task_graph <- function(tasks) {
  if (! all(sapply(tasks, is.ruigi_task)))
    stop("You must provide a flat list of tasks for luigi to execute.")

  nodes <- lapply(tasks, function(task) {
    list(
      id = digest::digest(task),
      task = task
    )
  })

  edges <- list()
  target_id <- function(target) {
    stopifnot(is.ruigi_target(target))
    digest::digest(digest::digest(paste0(target$location, class(target))))
  }
  ## `O(n^2 * k)`, n - number of nodes, k - maximum number of requirements...
  ## Pretty sure we can do better
  lapply(nodes, function(lst) {
    lapply(nodes, function(other_lst) {
      ## no edges that start and end in the same node
      if (identical(lst$id, other_lst$id)) return(NULL)
      lapply(other_lst$task$requires, function(target) {
        if (target_id(target) == target_id(lst$task$target)) {
          edges <<- append(edges, list(list(from = lst$id, to = other_lst$id)))
        }
      })
      NULL
    })
  })

  graph <- list(nodes = nodes, edges = edges)
  class(graph) <- c("graph", class(graph))
  graph
}
