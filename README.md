
# vietr

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`vietr` is a wrapper of VNCoreNLP.

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
> v <- vncorenlp$new("wseg")
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
> v <- vncorenlp$new("pos")
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
> v <- vncorenlp$new("ner")
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

### Dependence Parse

```
> options(java.parameters = "-Xmx4g")
> gc()
> rJava::J("java.lang.Runtime")$getRuntime()$gc()
>
> library(vietr)
>
> v <- vncorenlp$new("parse")
> text <- "Ông Nguyễn Khắc Chúc  đang làm việc tại Đại học Quốc gia Hà Nội. Bà Lan, vợ ông Chúc, cũng làm việc tại đây."
> v$dep_parse(text)
     [,1]  [,2]               [,3]   [,4]       [,5]  [,6]      [,7]       [,8]     [,9]    [,10] [,11]  [,12]   [,13] 
word "Ông" "Nguyễn_Khắc_Chúc" "đang" "làm_việc" "tại" "Đại_học" "Quốc_gia" "Hà_Nội" "."     "Bà"  "Lan"  ","     "vợ"  
head 4     1                  4      0          4     5         6          6        4       9     1      1       1     
dep  "sub" "nmod"             "adv"  "root"     "loc" "pob"     "nmod"     "nmod"   "punct" "sub" "nmod" "punct" "nmod"
     [,14]  [,15]  [,16]   [,17]  [,18]      [,19] [,20] [,21]  
word "ông"  "Chúc" ","     "cũng" "làm_việc" "tại" "đây" "."    
head 4      5      1       9      0          9     10    9      
dep  "nmod" "nmod" "punct" "adv"  "root"     "loc" "pob" "punct"
```

## Run as service 

1. Start server
```
$ cd vietr
$ R -e 'plumber::plumb(file="R/api.R")$run(port=39000)'
```

2. Request annotation

```
curl -X POST http://localhost:39000/tokenize -H "content-type: application/json" --data "{\"text\": \"Một lãnh đạo Bệnh viện Đa khoa khu vực Thủ Đức đã xác nhận trên Tuổi trẻ online việc, một người đàn ông dương tính với SARS-CoV-2 đang được điều trị tại Bệnh viện Đa khoa khu vực Thủ Đức (phường Linh Trung, TP Thủ Đức, TP.HCM) đã trốn ra ngoài rồi về nhà ở quận 10\"}" 

{"tokens":["Một","lãnh_đạo","Bệnh_viện","Đa_khoa","khu_vực","Thủ_Đức","đã","xác_nhận","trên","Tuổi_trẻ","online","việc",",","một","người","đàn_ông","dương_tính","với","SARS-CoV","-2","đang","được","điều_trị","tại","Bệnh_viện","Đa_khoa","khu_vực","Thủ_Đức","(","phường","Linh_Trung",",","TP","Thủ_Đức",",","TP.","HCM",")","đã","trốn","ra","ngoài","rồi","về","nhà","ở","quận","10"]}
```

```
curl -X POST http://localhost:39000/postag -H "content-type: application/json" --data "{\"text\": \"Một lãnh đạo Bệnh viện Đa khoa khu vực Thủ Đức đã xác nhận trên Tuổi trẻ online việc, một người đàn ông dương tính với SARS-CoV-2 đang được điều trị tại Bệnh viện Đa khoa khu vực Thủ Đức (phường Linh Trung, TP Thủ Đức, TP.HCM) đã trốn ra ngoài rồi về nhà ở quận 10\"}" 

[{"word":"Một","tag":"M"},{"word":"lãnh_đạo","tag":"N"},{"word":"Bệnh_viện","tag":"N"},{"word":"Đa_khoa","tag":"Np"},{"word":"khu_vực","tag":"N"},{"word":"Thủ_Đức","tag":"Np"},{"word":"đã","tag":"R"},{"word":"xác_nhận","tag":"V"},{"word":"trên","tag":"E"},{"word":"Tuổi_trẻ","tag":"N"},{"word":"online","tag":"V"},{"word":"việc","tag":"N"},{"word":",","tag":"CH"},{"word":"một","tag":"M"},{"word":"người","tag":"Nc"},{"word":"đàn_ông","tag":"N"},{"word":"dương_tính","tag":"A"},{"word":"với","tag":"E"},{"word":"SARS-CoV","tag":"Nc"},{"word":"-2","tag":"Np"},{"word":"đang","tag":"R"},{"word":"được","tag":"V"},{"word":"điều_trị","tag":"V"},{"word":"tại","tag":"E"},{"word":"Bệnh_viện","tag":"Np"},{"word":"Đa_khoa","tag":"Np"},{"word":"khu_vực","tag":"N"},{"word":"Thủ_Đức","tag":"Np"},{"word":"(","tag":"CH"},{"word":"phường","tag":"N"},{"word":"Linh_Trung","tag":"Np"},{"word":",","tag":"CH"},{"word":"TP","tag":"Ny"},{"word":"Thủ_Đức","tag":"Np"},{"word":",","tag":"CH"},{"word":"TP.","tag":"Ny"},{"word":"HCM","tag":"Np"},{"word":")","tag":"CH"},{"word":"đã","tag":"R"},{"word":"trốn","tag":"V"},{"word":"ra","tag":"V"},{"word":"ngoài","tag":"N"},{"word":"rồi","tag":"C"},{"word":"về","tag":"V"},{"word":"nhà","tag":"N"},{"word":"ở","tag":"E"},{"word":"quận","tag":"N"},{"word":"10","tag":"M"}]
```

## License 

MIT

## VNCoreNLP License

https://github.com/vncorenlp/VnCoreNLP/blob/master/LICENSE.md 

VnCoreNLP-1.1.1.jar and all model resources in models dir belongs to `VNCoreNLP`


