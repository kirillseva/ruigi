context('Unit tests for R target')

test_that('Test write, read and exists', {
  tmp <- data.frame(a = c(1,2,3), b = c(NA, NA, 4))
  trgt <- Rtarget$new("test")
  expect_false(trgt$exists())
  trgt$write(tmp)
  expect_true(trgt$exists())
  expect_equal(tmp, trgt$read())
})
