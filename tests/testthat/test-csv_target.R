context('Unit tests for CSV target')

test_that('Test write and exists', {
  tmp <- data.frame(a = c(1,2,3), b = c(NA, NA, 4))
  tmpfile <- tempfile()
  mock_node <- structure(42, class = "ruigi_node")
  trgt <- CSVtarget(mock_node, tmpfile)
  expect_false(trgt$exists())
  trgt$write(tmp)
  expect_true(trgt$exists())
  unlink(tmpfile)
})
