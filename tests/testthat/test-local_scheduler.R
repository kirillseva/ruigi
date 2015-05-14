context('Unit tests for ruigi_scheduler interface')

test_that('Executes a trivial 1-node pipeline', {
  tmp1 <- tempfile()
  write.csv(data.frame(a=1, b=2, c=3), tmp1, row.names = FALSE)
  tmp2 <- tempfile()

  task <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp1)),
    target = CSVtarget$new(tmp2),
    name = "Your ad could be here",
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  g <- ruigi:::build_task_graph(list(task))
  scheduler <- local_scheduler$new(g)
  # run first time
  expect_false(task$target$exists())
  expect_that(scheduler$run(), prints_text("Running task:  Your ad could be here ✓"))
  expect_true(task$target$exists())
  expect_equal(task$requires[[1]]$read(), task$target$read())

  # this will not recompute
  expect_that(scheduler$run(), prints_text("Skipping:  Your ad could be here"))

  unlink(tmp1)
  unlink(tmp2)
})


test_that('Errors on cyclic dependencies', {
  task1 <- ruigi_task$new(
    requires = list(Rtarget$new("node2")),
    target = Rtarget$new("node1"),
    name = "I require task 2",
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  task2 <- ruigi_task$new(
    requires = list(Rtarget$new("node3")),
    target = Rtarget$new("node2"),
    name = "I require task 3",
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  task3 <- ruigi_task$new(
    requires = list(Rtarget$new("node1")),
    target = Rtarget$new("node3"),
    name = "I require task 1",
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  g <- ruigi:::build_task_graph(list(task1, task2, task3))
  expect_error(topological_sort(g), "You have cyclic dependencies!")
})
