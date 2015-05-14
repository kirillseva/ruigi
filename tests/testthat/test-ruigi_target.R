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
  ), "Please specify the location for the target.")

  expect_error(ruigi_target$new(
    name = "Test target",
    read = function() "test",
    exists = function() TRUE,
    location = "hello"
  ), "Must implement ‘write’ for a target.")

  expect_error(ruigi_target$new(
    name = "Test target",
    read = function() "test",
    exists = function() TRUE,
    write = function(a, b) TRUE,
    location = "hello"
  ), "‘write’ should have only one input.")

  expect_error(ruigi_target$new(
    name = "Test target",
    read = function() "test",
    exists = function(a) TRUE,
    write = function(obj) TRUE,
    location = "hello"
  ), "‘exists’ should not have any inputs.")

  expect_error(ruigi_target$new(
    name = "Test target",
    read = function(a) "test",
    exists = function() TRUE,
    write = function(obj) TRUE,
    location = "hello"
  ), "‘read’ should not have any inputs.")
})
