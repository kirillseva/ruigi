context('Unit tests for topological sort of a graph')

test_that('A linear graph', {
  tmp1 <- tempfile()
  write.csv(data.frame(a=1, b=2, c=3), tmp1, row.names = FALSE)
  tmp2 <- tempfile()
  tmp3 <- tempfile()
  tmp4 <- tempfile()

  node0 <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp1)),
    name = "node0",
    target = CSVtarget$new(tmp2),
    runner = function(requires, target) {
      target$write(data.frame(a = 1, d = 4))
    }
  )

  node1 <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp2)),
    name = "node1",
    target = CSVtarget$new(tmp3),
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  node2 <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp3)),
    name = "node2",
    target = CSVtarget$new(tmp4),
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  g <- ruigi:::build_node_graph(list(node1, node0, node2))
  expect_is(g, "graph")

  sorted <- topological_sort(g)
  ordering <- c("node0", "node1", "node2")
  expect_equal(ordering, sapply(sorted$nodes, function(node) {
    node$node$name
  }))

  unlink(tmp1)
  unlink(tmp2)
  unlink(tmp3)
  unlink(tmp4)
})
