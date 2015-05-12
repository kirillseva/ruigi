context('Unit tests for building dependency graph')

test_that('A trivial dependency graph', {
  tmp1 <- tempfile()
  write.csv(data.frame(a=1, b=2, c=3), tmp1, row.names = FALSE)
  tmp2 <- tempfile()

  node1 <- ruigi_node$new(
    requires = list(CSVtarget$new(tmp1)),
    target = CSVtarget$new(tmp2),
    runner = function(requires, target) {
      tmpvalue <- requires[[1]]$read()
      target$write(tmpvalue)
    }
  )

  g <- build_node_graph(list(node1))
  print(g)

  unlink(tmp1)
  unlink(tmp2)
})
