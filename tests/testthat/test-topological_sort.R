context('Unit tests for topological sort of a graph')

test_that('A linear graph', {
  tmp1 <- tempfile()
  write.csv(data.frame(a=1, b=2, c=3), tmp1, row.names = FALSE)
  tmp2 <- tempfile()
  tmp3 <- tempfile()
  tmp4 <- tempfile()

  task0 <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp1)),
    name = "task0",
    target = CSVtarget$new(tmp2),
    runner = function(requires, target) {
      target$write(data.frame(a = 1, d = 4))
    }
  )

  task1 <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp2)),
    name = "task1",
    target = CSVtarget$new(tmp3),
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  task2 <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp3)),
    name = "task2",
    target = CSVtarget$new(tmp4),
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  g <- ruigi:::build_node_graph(list(task1, task0, task2))
  expect_is(g, "graph")

  sorted <- topological_sort(g)
  ordering <- c("task0", "task1", "task2")
  expect_equal(ordering, sapply(sorted$nodes, function(node) {
    node$task$name
  }))

  unlink(tmp1)
  unlink(tmp2)
  unlink(tmp3)
  unlink(tmp4)
})
