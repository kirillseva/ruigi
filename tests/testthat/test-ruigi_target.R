context('Unit tests for ruigi_target')

test_that('Test write, read and exists', {
  # positive case
  target <- ruigi_target$new(
    name = "Test target",
    read = function() "test",
    exists = function() TRUE,
    write = function(...) TRUE,
    location = "hello"
  )
  expect_true(target$exists())
  # negative cases
  expect_error(ruigi_target$new(
    name = "Test target",
    read = function() "test",
    exists = function() TRUE,
    write = function(...) TRUE
  ))

  expect_error(ruigi_target$new(
    name = "Test target",
    read = function() "test",
    exists = function() TRUE,
    location = "hello"
  ))

  expect_error(ruigi_target$new(
    name = "Test target",
    read = function() "test",
    exists = function() TRUE,
    write = function(a, b) TRUE,
    location = "hello"
  ))

  expect_error(ruigi_target$new(
    name = "Test target",
    read = function() "test",
    exists = function(a) TRUE,
    write = function(obj) TRUE,
    location = "hello"
  ))

  expect_error(ruigi_target$new(
    name = "Test target",
    read = function(a) "test",
    exists = function() TRUE,
    write = function(obj) TRUE,
    location = "hello"
  ))
})
