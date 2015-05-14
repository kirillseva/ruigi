context('Unit tests for ruigi_task')

test_that('A simple unit test for one node', {
  tmp1 <- tempfile()
  write.csv(data.frame(a=1, b=2, c=3), tmp1, row.names = FALSE)
  tmp2 <- tempfile()

  task <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp1)),
    target = CSVtarget$new(tmp2),
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  ## We assume the requirement is fulfilled (scheduler should take care of that)
  expect_true(task$requires[[1]]$exists())
  ## And the target is not yet created
  expect_false(task$target$exists())
  ## But if we run!
  task$runner(task$requires, task$target)
  ## The target now exists!
  expect_true(task$target$exists())
  ## And, as we hoped when we were implementing, it's identical to the requirement
  expect_identical(task$target$read(), task$requires[[1]]$read())
  unlink(tmp1)
  unlink(tmp2)
})

test_that('Need a valid target', {
  expect_error(ruigi_task$new(
    requires = list(Rtarget$new("yay")),
    target = c("Error"),
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  ))
})
