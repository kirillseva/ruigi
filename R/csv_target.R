`CSVtarget&initialize` <- function(location, name) {
  if (missing(location)) stop("Need to specify the filename for ", sQuote("CSVtarget"))
  self$location <- location
  self$name <- if (!missing(name)) name else paste(self$name, location)

  self$exists <- function() file.exists(self$location)
  self$write <- function(obj) write.csv(obj, self$location, row.names = FALSE)
  self$read <- function() read.csv(self$location)
}

#' @export
CSVtarget <- R6::R6Class("CSVtarget",
  inherit = ruigi_target,
  public = list(
    name = paste0("Write to ", sQuote("csv")),
    initialize = `CSVtarget&initialize`
  )
)
