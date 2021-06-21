
tokenize <- function(sen) {
  ann_args <- .jarray("wseg")
  pipe <- .jnew("vn.pipeline.VnCoreNLP", ann_args)
  ann <- .jnew("vn.pipeline.Annotation", sen)
  pipe$annotate(ann)
  words <- ann$getWords()
  ws <- words$toArray()
  vapply(.jevalArray(ws),
         function(x) {
           .jcall(x, returnSig="S", method="getForm")},
         character(1))
}

pos_tag <- function(sen) {
  ann_args <- .jarray(c("wseg","pos"))
  pipe <- .jnew("vn.pipeline.VnCoreNLP", ann_args)
  ann <- .jnew("vn.pipeline.Annotation", sen)
  pipe$annotate(ann)
  words <- ann$getWords() #
  ws <- words$toArray()
  vapply(.jevalArray(ws),
         function(x) {
           list(word=.jcall(x, returnSig="S", method="getForm"),
                tag=.jcall(x, returnSig="S", method="getPosTag"))},
         list(word="", tag=""))
}

ner <- function(sen) {
  ann_args <- .jarray(c("wseg","ner"))
  pipe <- .jnew("vn.pipeline.VnCoreNLP", ann_args)
  ann <- .jnew("vn.pipeline.Annotation", sen)
  pipe$annotate(ann)
  words <- ann$getWords() #
  ws <- words$toArray()
  vapply(.jevalArray(ws),
         function(x) {
           list(word=.jcall(x, returnSig="S", method="getForm"),
                ner=.jcall(x, returnSig="S", method="getNerLabel"))},
         list(word="", ner=""))
}

#gc()
#J("java.lang.Runtime")$getRuntime()$gc()

