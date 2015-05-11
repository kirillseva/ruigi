#' @export
S3target <- R6::R6Class("S3target",
  inherit = ruigi_target,
  public = list(
    name = paste0("Write to an s3 bucket"),
    initialize = function(location, name) {
      if (missing(location)) stop("Need to specify the filename for ", sQuote("CSVtarget"))
      self$location <- location
      self$name <- if (!missing(name)) name else paste(self$name, location)

      self$exists <- function() s3mpi::s3exists(self$location)
      self$write <- function(obj) s3mpi::s3store(obj, self$location)
      self$read <- function() s3mpi::s3read(self$location)
    }
  )
)
