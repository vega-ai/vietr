.onLoad <- function(libname, pkgname) {
  p <- system.file("java", "", package="vietr")
  Sys.setenv(user.dir=substr(p, 1, nchar(p) - 1))
  .jpackage(pkgname, lib.loc = libname)
}
