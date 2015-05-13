## [Who would have thought that data structures are useful](http://en.wikipedia.org/wiki/Topological_sorting)
topological_sort <- function(graph) {
  stopifnot(is(graph, 'graph'))
  sort_env <- new.env()
  sort_env$sorted <- list(nodes = list(), edges = graph$edges)
  sort_env$graph <- graph

  g_visit <- function(idx) {
    if (! is.null(sort_env$graph$nodes[[idx]]$mark)) {
      if (sort_env$graph$nodes[[idx]]$mark == "temporary") stop("You have cyclic dependencies!")
    }
    if (is.null(sort_env$graph$nodes[[idx]]$mark)) {
      sort_env$graph$nodes[[idx]]$mark <- "temporary"
    }
    for (i in seq_along(graph$edges)) {
      if (sort_env$graph$edges[[i]]$from == sort_env$graph$nodes[[idx]]$id) g_visit(i)
    }
    sort_env$graph$nodes[[idx]]$mark <- "marked"
    sort_env$sorted$nodes <- append(sort_env$sorted$nodes, list(sort_env$graph$nodes[[idx]]))
  }

  repeat {
    node_i <- (function (nodes) {
      for (i in seq_along(nodes)) {
        if (!is.null(nodes[[i]]$mark)) {
          if (nodes[[i]]$mark != "marked") return(i)
        } else return(i)
      }
    })(sort_env$graph$nodes)
    ## no unmarked nodes left
    if (is.null(node_i)) break
    ## visit(node)
    g_visit(node_i)
  }

  sort_env$sorted
}
