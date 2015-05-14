context('Unit tests for ruigi_task')

test_that('A simple unit test for one node', {
  tmp1 <- tempfile()
  write.csv(data.frame(a=1, b=2, c=3), tmp1, row.names = FALSE)
  tmp2 <- tempfile()

  node1 <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp1)),
    target = CSVtarget$new(tmp2),
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  ## We assume the requirement is fulfilled (scheduler should take care of that)
  expect_true(node1$requires[[1]]$exists())
  ## And the target is not yet created
  expect_false(node1$target$exists())
  ## But if we run!
  node1$runner(node1$requires, node1$target)
  ## The target now exists!
  expect_true(node1$target$exists())
  ## And, as we hoped when we were implementing, it's identical to the requirement
  expect_identical(node1$target$read(), node1$requires[[1]]$read())
  unlink(tmp1)
  unlink(tmp2)
})
