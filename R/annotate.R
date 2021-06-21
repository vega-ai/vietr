#' @export
vncorenlp <- R6::R6Class('vncorenlp',
  public = list(
    annotations = NULL,
    initialize = function(annotations=c("wseg")) {
      self$annotations = annotations
      ann_args <- .jarray(self$annotations)
      private$pipe = .jnew("vn.pipeline.VnCoreNLP", ann_args)
      self
    },

    tokenize = function(sen) {
      ann <- .jnew("vn.pipeline.Annotation", sen)
      private$pipe$annotate(ann)
      words <- ann$getWords()
      ws <- words$toArray()
      vapply(.jevalArray(ws),
         function(x) {
           .jcall(x, returnSig="S", method="getForm")},
         character(1))
    },

    pos_tag = function(sen) {
      ann <- .jnew("vn.pipeline.Annotation", sen)
      private$pipe$annotate(ann)
      words <- ann$getWords() #
      ws <- words$toArray()
      vapply(.jevalArray(ws),
         function(x) {
           list(word=.jcall(x, returnSig="S", method="getForm"),
                tag=.jcall(x, returnSig="S", method="getPosTag"))},
         list(word="", tag=""))
    },

    ner = function(sen) {
      ann <- .jnew("vn.pipeline.Annotation", sen)
      private$pipe$annotate(ann)
      words <- ann$getWords() #
      ws <- words$toArray()
      vapply(.jevalArray(ws),
         function(x) {
           list(word=.jcall(x, returnSig="S", method="getForm"),
                ner=.jcall(x, returnSig="S", method="getNerLabel"))},
         list(word="", ner=""))
  }),
  private = list(
    pipe = NULL
  )
)

