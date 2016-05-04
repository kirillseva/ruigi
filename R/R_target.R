`Rtarget&initialize` <- function(location, name) {
  if (missing(location)) stop("Need to specify the R object name for ", sQuote("Rtarget"))
  self$location <- location
  self$name <- if (!missing(name)) name else paste(self$name, location)

  self$exists <- function() { location %in% ls(.ruigi_env) }
  self$write <- function(obj) { .ruigi_env[[location]] <- obj }
  self$read <- function() .ruigi_env[[location]]
}

#' R target specifies an object with a given name in .ruigi_env
#'
#' @export
Rtarget <- R6::R6Class("Rtarget",
  inherit = ruigi_target,
  public = list(
    name = paste0("Save an object in ", sQuote(".ruigi_env")),
    initialize = `Rtarget&initialize`
  )
)
