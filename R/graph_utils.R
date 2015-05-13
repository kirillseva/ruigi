## [Who would have thought that data structures are useful](http://en.wikipedia.org/wiki/Topological_sorting)
topological_sort <- function(graph) {
  stopifnot(is(graph, 'graph'))
  sorted <- list(nodes = list(), edges = graph$edges)
  graph <- graph

  g_visit <- function(idx) {
    if (! is.null(graph$nodes[[idx]]$mark)) {
      if (graph$nodes[[idx]]$mark == "temporary") stop("You have cyclic dependencies!")
    }
    if (is.null(graph$nodes[[idx]]$mark)) {
      graph$nodes[[idx]]$mark <<- "temporary"
    }
    for (i in seq_along(graph$edges)) {
      if (graph$edges[[i]]$from == graph$nodes[[idx]]$id) g_visit(i)
    }
    graph$nodes[[idx]]$mark <<- "marked"
    sorted$nodes <<- append(list(graph$nodes[[idx]]), sorted$nodes)
  }

  repeat {
    node_i <- (function (nodes) {
      for (i in seq_along(nodes)) {
        if (!is.null(nodes[[i]]$mark)) {
          if (nodes[[i]]$mark != "marked") return(i)
        } else return(i)
      }
    })(graph$nodes)
    ## no unmarked nodes left
    if (is.null(node_i)) break
    ## visit(node)
    g_visit(node_i)
  }

  sorted
}
