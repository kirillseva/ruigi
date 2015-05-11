context('Unit tests for CSV target')

test_that('Test write and exists', {
  tmp <- data.frame(a = c(1,2,3), b = c(NA, NA, 4))
  tmpfile <- tempfile()
  trgt <- CSVtarget$new(tmpfile)
  expect_false(trgt$exists())
  trgt$write(tmp)
  expect_true(trgt$exists())
  expect_equal(tmp, trgt$read())
  unlink(tmpfile)
})
