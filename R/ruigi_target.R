`ruigi_target&initialize` <- function(name, write, read, exists, location) {
  if (!missing(name)) self$name <- name
  ## A target must implement two methods: *exists* and *write*
  ## The scheduler will determine which nodes need to be computed depending on the
  ## target of every node. Namely, if `target$exists()`` is **TRUE**, then the
  ## node is assumed to have finished running. Otherwise, `target$write(obj)`
  ## the node writer should use `target$write(obj)` in the node runner.
  ## It is a useful abstraction, because it allows to reuse the same node processing
  ## logic and change the way artifacts are created.
  if (missing(exists)) stop("Must implement ", sQuote("exists"), " for a target.")
  if (!is.function(exists) | length(exists) != 1)
    stop(sQuote("exists"), " must be a function")
  if (!is.null(formals(exists))) stop(sQuote("exists"), " should not have any inputs.")
  self$exists <- exists

  if (!is.function(read) | length(read) != 1)
    stop(sQuote("read"), " must be a function")
  if (!is.null(formals(read))) stop(sQuote("read"), " should not have any inputs.")
  self$read <- read

  if (missing(write)) stop("Must implement ", sQuote("write"), " for a target.")
  if (!is.function(write) | length(write) != 1)
    stop(sQuote("write"), " must be a function")
  if (length(formals(write)) != 1) stop(sQuote("write"), " should have only one input.")
  self$write <- write

  if (missing(location)) stop("Please specify the location for the target.")
  self$location <- location
}

#' A minimal deliverable in ruigi. A target is an interface to an object (file, RAM address,
#' database table, s3 bucket, etc.), with \code{read} and \code{write} methods.
#'
#' @export
ruigi_target <- R6::R6Class("ruigi_target",
  public = list(
    ## Defaults
    name = "ruigi target",
    write = NULL,
    read = NULL,
    location = NULL,
    exists = NULL,
    ## This initialize ensures that all the inputs are valid in a very verbose way
    ## since this is the primary interface with the user.
    ## It is important to check early because execution of the node may happen
    ## on another machine, or it will start late and cause errors in a huge batch job.
    initialize = `ruigi_target&initialize`
  )
)

is.ruigi_target <- function(obj) inherits(obj, "ruigi_target")
