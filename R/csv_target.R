#' @export
CSVtarget <- function(requires, location, name = paste0("Write to ", sQuote(".csv"))) {
  trgt <- ruigi_target$new(
    name = name,
    requires = requires,
    write = function(obj) write.csv(obj, self$location, row.names = FALSE),
    exists = function() file.exists(self$location),
    location = location
  )
  class(trgt) <- c("CSVtarget", class(trgt))
  trgt
}
