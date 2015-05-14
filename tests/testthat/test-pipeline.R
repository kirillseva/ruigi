context("Unit tests for pipeline with local scheduler")

test_that('It can handle more complex pipelines', {
  #write three input data frames and their corresponding tasks
  tmp1 <- tempfile()
  write.csv(data.frame(id = 1, b=2, c=3), tmp1, row.names = FALSE)
  tmp2 <- tempfile()
  write.csv(data.frame(id = c(1,2), d=c(1, 10), e=c(2,5), f=c(3, 5)), tmp2, row.names = FALSE)
  tmp3 <- tempfile()
  write.csv(data.frame(id = 6, g=8, h=7), tmp3, row.names = FALSE)
  tmp4 <- tempfile()

  task1 <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp1), CSVtarget$new(tmp2)),
    target = CSVtarget$new(tmp4),
    name = "Merge tmp1 and tmp2",
    runner = function(requires, target) {
      tmpvalue1 <- requires[[1]]$read()
      tmpvalue2 <- requires[[2]]$read()
      out <- merge(tmpvalue1, tmpvalue2, by = "id", all = T)
      target$write(out)
    }
  )

  task2 <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp3)),
    target = Rtarget$new("tmp3"),
    name = "Read tmp3 into RAM",
    runner = function(requires, target) {
      Sys.sleep(1) #simulate delay to test caching later
      out <- requires[[1]]$read()
      target$write(out)
    }
  )

  task3 <- ruigi_task$new(
    requires = list(CSVtarget$new(tmp4), Rtarget$new("tmp3")),
    target = Rtarget$new("merger"),
    name = "Merge a value from a csv and from R",
    runner = function(requires, target) {
      tmpvalue1 <- requires[[1]]$read()
      tmpvalue2 <- requires[[2]]$read()
      out <- merge(tmpvalue1, tmpvalue2, by = "id", all = T)
      target$write(out)
    }
  )

  task4 <- ruigi_task$new(
    requires = list(Rtarget$new("merger")),
    target = Rtarget$new("final"),
    name = "Only select ids from the data frame",
    runner = function(requires, target) {
      out <- requires[[1]]$read()
      target$write(out$id)
    }
  )

  cat("\n") # it's prettier this way
  pipeline(list(task3, task2, task1))
  expect_equal(dim(.ruigi_env$merger), c(3, 8))
  # we've cached something!
  takes_less_than(.3)(pipeline(list(task4, task3, task2, task1)))
  expect_equal(.ruigi_env$final, c(1, 2, 6))


  unlink(tmp1)
  unlink(tmp2)
  unlink(tmp3)
  unlink(tmp4)
})
