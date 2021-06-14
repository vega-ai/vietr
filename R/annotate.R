
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
