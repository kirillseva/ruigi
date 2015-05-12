## The mission of the pipeline is to take a list of nodes,
## build the dependency graph and give it to the scheduler.
## The scheduler, in turn, should take this graph and execute the unfinished nodes.
build_node_graph <- function(nodes) {
  if (! all(sapply(nodes, is.ruigi_node)))
    stop("You must provide a flat list of nodes for luigi to execute.")

  nodes_and_targets <- lapply(nodes, function(node) {
    list(node = node, target = node$target, requirements = node$requires)
  })
}
