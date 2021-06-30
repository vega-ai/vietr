library(assertthat)
library(httr)

#' @export
vnlpc <- function(url) {
  self <- NA

  #' @importFrom R6 R6Class
  obj <- R6::R6Class("vnlpc",
    public = list(

      #' @field url URL vncorenlp server
      url = NULL,

      #' @description
      #' Create vnlpclient object
      #' @param url URL of vncorenlp server
      #' @return A new `vnlpc` object.
      initialize = function(url) {
        self$url = url
        private$url_tokenize = paste0(self$url, "/", "tokenize")
        private$url_postag   = paste0(self$url, "/", "postag")
        private$url_ner      = paste0(self$url, "/", "ner")
        private$url_depparse = paste0(self$url, "/", "depparse")
        self
      },

      tokenize = function(text) {
        unlist(private$request(private$url_tokenize, text))
      },

      postag = function(text) {
        private$request(private$url_postag, text)
      },

      ner = function(text) {
        private$request(private$url_ner, text)
      },

      depparse = function(text) {
        private$request(private$url_depparse, text)
      }
    ),


   private = list(
     url_tokenize = NULL,
     url_postag = NULL,
     url_ner = NULL,
     url_depparse = NULL,

     request = function(url, text) {
       msg <- validate_that(is.string(text))
       if (msg != TRUE) {
         stop(msg, call. = FALSE)
       }

       rv <- POST(url, body=list(text=text), encode = 'json')
       if (status_code(rv) != 200) {
         stop(content(rv))
       }
       content(rv)
     })
  )
  obj$new(url)
}

