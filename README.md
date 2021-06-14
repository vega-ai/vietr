
# vietr

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`vietr` is a wrapper of words tokenizer using VNCoreNLP.

## Installation

This package requires JDK 1.8+

``` r
install.packages("rJava")
```

```bash
$ git clone 
$ R CMD INSTALL --no-multiarch --with-keep.source vietr


## Example

This is a basic example which shows you how to solve a common problem:

```{r}
> library(vietr)
>
> text <- "Ông Nguyễn Khắc Chúc  đang làm việc tại Đại học Quốc gia Hà Nội. Bà Lan, vợ ông Chúc, cũng làm việc tại đây."
> tks <- tokenize(text)
> tks
 [1] "Ông"              "Nguyễn_Khắc_Chúc" "đang"             "làm_việc"         "tại"              "Đại_học"         
 [7] "Quốc_gia"         "Hà_Nội"           "."                "Bà"               "Lan"              ","               
[13] "vợ"               "ông"              "Chúc"             ","                "cũng"             "làm_việc"        
[19] "tại"              "đây"              "."           
```

## VNCoreNLP License 

https://github.com/vncorenlp/VnCoreNLP/blob/master/LICENSE.md 

