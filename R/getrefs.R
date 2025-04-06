
getrefs <- function(x, vars = NULL, reader_options = NULL) {
  if (is.null(vars)) stop("must specificy 'vars'")
  reticulate::py_require("virtualizarr")
  reticulate::py_require("s3fs")

  virtualizarr <- reticulate::import("virtualizarr")

  ds <- virtualizarr$open_virtual_dataset(x, reader_options = reader_options)

  out <- vector("list", length(vars))
  for (i in seq_along(vars)) {
    m <- ds$variables[vars[i]]$data$manifest
    out[[i]] <- do.call(rbind, lapply(m$dict(), tibble::as_tibble))
    out[[i]][["index"]] <-  names(m$dict())
    out[[i]][["varname"]]  <-  vars[i]
  }
  do.call(rbind, out)
}


