library(assertthat)

tok <- NULL
pos <- NULL
ner <- NULL
dep <- NULL

validate_input <- function(res, text) {
  msg <- validate_that(is.string(text), is.scalar(text))
  if (msg != TRUE) {
    res$status <- 400
    stop(jsonlite::unbox(msg), call. = FALSE)
  }
}

#* Tokenize text
#* @param text:str Text to be tokenize
#* @parser json
#* @serializer unboxedJSON
#* @post /tokenize
function(req, res, text) {
  validate_input(res, text)

  if (is.null(tok)) {
      tok <<- vietr::vncorenlp$new("wseg")
  }

  tok$tokenize(text)
}


#* PosTag text
#* @param text:str Text to be annotated with PoS Tags
#* @parser json
#* @serializer unboxedJSON
#* @post /postag
function(req, res, text) {
  validate_input(res, text)

  if (is.null(pos)) {
    pos <<- vietr::vncorenlp$new("pos")
  }
  as.data.frame(t(pos$postag(text)))
}

#* NER
#* @param text:str Text to be annotated with NER
#* @parser json
#* @serializer unboxedJSON
#* @post /ner
function(req, res, text) {
  validate_input(res, text)

  if (is.null(ner)) {
    options(java.parameters = "-Xmx5g")
    rJava::J("java.lang.Runtime")$getRuntime()$gc()
    ner <<- vietr::vncorenlp$new("ner")
  }
  as.data.frame(t(ner$ner(text)))
}

#* Dependence parse
#* @param text:str Text to be annotated with Depenece Parsing
#* @parser json
#* @serializer unboxedJSON
#* @post /depparse
function(req, res, text) {
  validate_input(res, text)

  if (is.null(dep)) {
    options(java.parameters = "-Xmx5g")
    rJava::J("java.lang.Runtime")$getRuntime()$gc()
    dep <<- vietr::vncorenlp$new("parse")
  }
  as.data.frame(t(dep$depparse(text)))
}
