context('Unit tests for ruigi_scheduler interface')

test_that('A scheduler needs to be implemented', {
  sc <- ruigi_scheduler$new()
  expect_error(sc$run())
})
