#' Execute all \pkg{test_that} tests in a package.
#'
#' Tests are assumed to be located in a \code{inst/tests/} directory.
#' See \code{\link[testthat]{test_dir}} for the naming convention of test
#' scripts within that directory.
#'
#' @param pkg package description, can be path or package name.  See
#'   \code{\link{as.package}} for more information
#' @inheritParams testthat::test_dir
#' @export
test <- function(pkg = ".", filter = NULL) {
  pkg <- as.package(pkg)

  path_test <- file.path(pkg$path, "inst", "tests")
  if (!file.exists(path_test)) return()

  to_run <- bquote({
    require("devtools", quiet = TRUE)
    require("testthat", quiet = TRUE)

    load_all(.(pkg$path), quiet = TRUE)
    test_dir(.(path_test), filter = .(filter))
  })

  message("Testing ", pkg$package)
  eval_clean(to_run)
}


#' Return the path to one of the packages in the devtools test dir
#'
#' Devtools comes with some simple packages for testing. This function
#' returns the path to them.
#'
#' @param package Name of the test package.
#' @examples
#' devtest("collate-extra")
#'
#' @export
devtest <- function(package) {
  if (is.null(dev_meta("devtools"))) {
    # devtools was loaded the normal way
    system.file(package = "devtools", "tests", package)
  } else {
    # devtools was loaded with load_all
    system.file(package = "devtools", "inst", "tests", package)
  }
}
