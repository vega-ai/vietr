
# vietr

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`vietr` is a wrapper of words tokenizer using VNCoreNLP.

## Installation

This package requires JDK 1.8+

```bash
$ sudo apt install liblzma-dev libpcre2-dev libbz2-dev
$ sudo R CMD javareconf
$ Rscript -e 'install.packages("rJava")'
```

```bash
$ git clone https://github.com/vega-ai/vietr.git 
$ R CMD INSTALL --no-multiarch --with-keep.source vietr
```

NOTE: Because vncorenlp hard-coded the path of model resource you must copy the
models dir to your new R projects:

```bash
$ cd vietr 
$ cp -R models your_r_project_dir 
```

## Examples

### Tokenize 

```{r}
> library(vietr)
>
> v <- vncorenlp$new(c("wseg"))
> text <- "Ông Nguyễn Khắc Chúc  đang làm việc tại Đại học Quốc gia Hà Nội. Bà Lan, vợ ông Chúc, cũng làm việc tại đây."
> tks <- v$tokenize(text)
> tks
 [1] "Ông"              "Nguyễn_Khắc_Chúc" "đang"             "làm_việc"         "tại"              "Đại_học"         
 [7] "Quốc_gia"         "Hà_Nội"           "."                "Bà"               "Lan"              ","               
[13] "vợ"               "ông"              "Chúc"             ","                "cũng"             "làm_việc"        
[19] "tại"              "đây"              "."           
```

### PoS Tag

```{r}
> library(vietr)
>
> v <- vncorenlp$new(c("wseg", "pos"))
> text <- "Ông Nguyễn Khắc Chúc  đang làm việc tại Đại học Quốc gia Hà Nội. Bà Lan, vợ ông Chúc, cũng làm việc tại đây."
> tags <- v$pos_tag(text)
2021-06-21 19:16:30 INFO  WordSegmenter:24 - Loading Word Segmentation model
2021-06-21 19:16:30 INFO  PosTagger:21 - Loading POS Tagging model
> tags
     [,1]  [,2]               [,3]   [,4]       [,5]  [,6]      [,7]       [,8]     [,9] [,10] [,11] [,12] [,13] [,14]
word "Ông" "Nguyễn_Khắc_Chúc" "đang" "làm_việc" "tại" "Đại_học" "Quốc_gia" "Hà_Nội" "."  "Bà"  "Lan" ","   "vợ"  "ông"
tag  "Nc"  "Np"               "R"    "V"        "E"   "N"       "N"        "Np"     "CH" "Nc"  "Np"  "CH"  "N"   "Nc" 
     [,15]  [,16] [,17]  [,18]      [,19] [,20] [,21]
word "Chúc" ","   "cũng" "làm_việc" "tại" "đây" "."  
tag  "Np"   "CH"  "R"    "V"        "E"   "P"   "CH" 
```

### NER (Memory Greed!!!)

```{r} 
> # Clean up mem usage first
> options(java.parameters = "-Xmx4g")
> gc()
> rJava::J("java.lang.Runtime")$getRuntime()$gc()
>
> library(vietr)
>
> v <- vncorenlp$new(c("wseg", "ner"))
> text <- "Ông Nguyễn Khắc Chúc  đang làm việc tại Đại học Quốc gia Hà Nội. Bà Lan, vợ ông Chúc, cũng làm việc tại đây."
> entities <- v$ner(text)
2021-06-21 19:20:28 INFO  WordSegmenter:24 - Loading Word Segmentation model
2021-06-21 19:20:28 INFO  NerRecognizer:33 - Loading NER model
> entities
     [,1]  [,2]               [,3]   [,4]       [,5]  [,6]      [,7]       [,8]     [,9] [,10] [,11]   [,12] [,13] [,14]
word "Ông" "Nguyễn_Khắc_Chúc" "đang" "làm_việc" "tại" "Đại_học" "Quốc_gia" "Hà_Nội" "."  "Bà"  "Lan"   ","   "vợ"  "ông"
ner  "O"   "B-PER"            "O"    "O"        "O"   "B-ORG"   "I-ORG"    "I-ORG"  "O"  "O"   "B-PER" "O"   "O"   "O"  
     [,15]  [,16] [,17]  [,18]      [,19] [,20] [,21]
word "Chúc" ","   "cũng" "làm_việc" "tại" "đây" "."  
ner  "O"    "O"   "O"    "O"        "O"   "O"   "O"  
> 
```

## License 

MIT

## VNCoreNLP License

https://github.com/vncorenlp/VnCoreNLP/blob/master/LICENSE.md 


