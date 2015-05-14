context('Unit tests for building dependency graph')

test_that('A small dependency graph', {
  tmp1 <- tempfile()
  write.csv(data.frame(a=1, b=2, c=3), tmp1, row.names = FALSE)
  tmp2 <- tempfile()
  tmp3 <- tempfile()

  node0 <- ruigi_node$new(
    requires = list(),
    name = "node0",
    target = CSVtarget$new(tmp3),
    runner = function(requires, target) {
      target$write(data.frame(a = 1, d = 4))
    }
  )

  node1 <- ruigi_node$new(
    requires = list(CSVtarget$new(tmp1), CSVtarget$new(tmp3)),
    name = "node1",
    target = CSVtarget$new(tmp2),
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  node2 <- ruigi_node$new(
    requires = list(CSVtarget$new(tmp3)),
    name = "node2",
    target = CSVtarget$new(tmp2),
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  g <- ruigi:::build_node_graph(list(node1, node0))
  expect_equal(length(g$edges), 1)
  expect_equal(length(g$nodes), 2)
  expect_is(g, "graph")

  unlink(tmp1)
  unlink(tmp2)
  unlink(tmp3)
})
