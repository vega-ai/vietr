
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
#  [1] "Ông"              "Nguyễn_Khắc_Chúc" "đang"             "làm_việc"         "tại"              "Đại_học"         
#  [7] "Quốc_gia"         "Hà_Nội"           "."                "Bà"               "Lan"              ","               
# [13] "vợ"               "ông"              "Chúc"             ","                "cũng"             "làm_việc"        
# [19] "tại"              "đây"              "."           
```

### PoS Tag

```{r}
> library(vietr)
>
> v <- vncorenlp$new("pos")
> text <- "Ông Nguyễn Khắc Chúc  đang làm việc tại Đại học Quốc gia Hà Nội. Bà Lan, vợ ông Chúc, cũng làm việc tại đây."
> tags <- v$postag(text)
> tags
#      [,1]  [,2]               [,3]   [,4]       [,5]  [,6]      [,7]       [,8]     [,9] [,10] [,11] [,12] [,13] [,14]
# word "Ông" "Nguyễn_Khắc_Chúc" "đang" "làm_việc" "tại" "Đại_học" "Quốc_gia" "Hà_Nội" "."  "Bà"  "Lan" ","   "vợ"  "ông"
# tag  "Nc"  "Np"               "R"    "V"        "E"   "N"       "N"        "Np"     "CH" "Nc"  "Np"  "CH"  "N"   "Nc" 
#      [,15]  [,16] [,17]  [,18]      [,19] [,20] [,21]
# word "Chúc" ","   "cũng" "làm_việc" "tại" "đây" "."  
# tag  "Np"   "CH"  "R"    "V"        "E"   "P"   "CH" 
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
> entities
#      [,1]  [,2]               [,3]   [,4]       [,5]  [,6]      [,7]       [,8]     [,9] [,10] [,11]   [,12] [,13] [,14]
# word "Ông" "Nguyễn_Khắc_Chúc" "đang" "làm_việc" "tại" "Đại_học" "Quốc_gia" "Hà_Nội" "."  "Bà"  "Lan"   ","   "vợ"  "ông"
# ner  "O"   "B-PER"            "O"    "O"        "O"   "B-ORG"   "I-ORG"    "I-ORG"  "O"  "O"   "B-PER" "O"   "O"   "O"  
#      [,15]  [,16] [,17]  [,18]      [,19] [,20] [,21]
# word "Chúc" ","   "cũng" "làm_việc" "tại" "đây" "."  
# ner  "O"    "O"   "O"    "O"        "O"   "O"   "O"  
> 
```

### Dependence Parse

```{r}
> options(java.parameters = "-Xmx4g")
> gc()
> rJava::J("java.lang.Runtime")$getRuntime()$gc()
>
> library(vietr)
>
> v <- vncorenlp$new("parse")
> text <- "Ông Nguyễn Khắc Chúc  đang làm việc tại Đại học Quốc gia Hà Nội. Bà Lan, vợ ông Chúc, cũng làm việc tại đây."
> v$depparse(text)
#      [,1]  [,2]               [,3]   [,4]       [,5]  [,6]      [,7]       [,8]     [,9]    [,10] [,11]  [,12]   [,13] 
# word "Ông" "Nguyễn_Khắc_Chúc" "đang" "làm_việc" "tại" "Đại_học" "Quốc_gia" "Hà_Nội" "."     "Bà"  "Lan"  ","     "vợ"  
# head 4     1                  4      0          4     5         6          6        4       9     1      1       1     
# dep  "sub" "nmod"             "adv"  "root"     "loc" "pob"     "nmod"     "nmod"   "punct" "sub" "nmod" "punct" "nmod"
#      [,14]  [,15]  [,16]   [,17]  [,18]      [,19] [,20] [,21]  
# word "ông"  "Chúc" ","     "cũng" "làm_việc" "tại" "đây" "."    
# head 4      5      1       9      0          9     10    9      
# dep  "nmod" "nmod" "punct" "adv"  "root"     "loc" "pob" "punct"
```

## Run as service 

### Start server
```bash
$ cd vietr
$ ln -s models R/models
$ R -e 'plumber::plumb(file="R/api.R")$run(port=39000, docs=FALSE)'
```

### Request annotation using curl 

```bash
curl -X POST http://localhost:39000/tokenize -H "content-type: application/json" --data "{\"text\": \"Một lãnh đạo Bệnh viện Đa khoa khu vực Thủ Đức đã xác nhận trên Tuổi trẻ online việc, một người đàn ông dương tính với SARS-CoV-2 đang được điều trị tại Bệnh viện Đa khoa khu vực Thủ Đức (phường Linh Trung, TP Thủ Đức, TP.HCM) đã trốn ra ngoài rồi về nhà ở quận 10\"}" 

{"tokens":["Một","lãnh_đạo","Bệnh_viện","Đa_khoa","khu_vực","Thủ_Đức","đã","xác_nhận","trên","Tuổi_trẻ","online","việc",",","một","người","đàn_ông","dương_tính","với","SARS-CoV","-2","đang","được","điều_trị","tại","Bệnh_viện","Đa_khoa","khu_vực","Thủ_Đức","(","phường","Linh_Trung",",","TP","Thủ_Đức",",","TP.","HCM",")","đã","trốn","ra","ngoài","rồi","về","nhà","ở","quận","10"]}
```

```bash
curl -X POST http://localhost:39000/postag -H "content-type: application/json" --data "{\"text\": \"Một lãnh đạo Bệnh viện Đa khoa khu vực Thủ Đức đã xác nhận trên Tuổi trẻ online việc, một người đàn ông dương tính với SARS-CoV-2 đang được điều trị tại Bệnh viện Đa khoa khu vực Thủ Đức (phường Linh Trung, TP Thủ Đức, TP.HCM) đã trốn ra ngoài rồi về nhà ở quận 10\"}" 

[{"word":"Một","tag":"M"},{"word":"lãnh_đạo","tag":"N"},{"word":"Bệnh_viện","tag":"N"},{"word":"Đa_khoa","tag":"Np"},{"word":"khu_vực","tag":"N"},{"word":"Thủ_Đức","tag":"Np"},{"word":"đã","tag":"R"},{"word":"xác_nhận","tag":"V"},{"word":"trên","tag":"E"},{"word":"Tuổi_trẻ","tag":"N"},{"word":"online","tag":"V"},{"word":"việc","tag":"N"},{"word":",","tag":"CH"},{"word":"một","tag":"M"},{"word":"người","tag":"Nc"},{"word":"đàn_ông","tag":"N"},{"word":"dương_tính","tag":"A"},{"word":"với","tag":"E"},{"word":"SARS-CoV","tag":"Nc"},{"word":"-2","tag":"Np"},{"word":"đang","tag":"R"},{"word":"được","tag":"V"},{"word":"điều_trị","tag":"V"},{"word":"tại","tag":"E"},{"word":"Bệnh_viện","tag":"Np"},{"word":"Đa_khoa","tag":"Np"},{"word":"khu_vực","tag":"N"},{"word":"Thủ_Đức","tag":"Np"},{"word":"(","tag":"CH"},{"word":"phường","tag":"N"},{"word":"Linh_Trung","tag":"Np"},{"word":",","tag":"CH"},{"word":"TP","tag":"Ny"},{"word":"Thủ_Đức","tag":"Np"},{"word":",","tag":"CH"},{"word":"TP.","tag":"Ny"},{"word":"HCM","tag":"Np"},{"word":")","tag":"CH"},{"word":"đã","tag":"R"},{"word":"trốn","tag":"V"},{"word":"ra","tag":"V"},{"word":"ngoài","tag":"N"},{"word":"rồi","tag":"C"},{"word":"về","tag":"V"},{"word":"nhà","tag":"N"},{"word":"ở","tag":"E"},{"word":"quận","tag":"N"},{"word":"10","tag":"M"}]
```

### Request annotations using `vnlp` R client 

```{r}
> library(vietr)
>
> vc <- vnlpc("http://localhost:39000")
> text <- "Một lãnh đạo Bệnh viện Đa khoa khu vực Thủ Đức đã xác nhận trên Tuổi trẻ online việc, một người đàn ông dương tính với SARS-CoV-2 đang được điều trị tại Bệnh viện Đa khoa khu vực Thủ Đức (phường Linh Trung, TP Thủ Đức, TP.HCM) đã trốn ra ngoài rồi về nhà ở quận 10"
>
> vc$tokenize(text)
# [1] "Một"        "lãnh_đạo"   "Bệnh_viện"  "Đa_khoa"    "khu_vực"    "Thủ_Đức"    "đã"         "xác_nhận"   "trên"      
# [10] "Tuổi_trẻ"   "online"     "việc"       ","          "một"        "người"      "đàn_ông"    "dương_tính" "với"       
# [19] "SARS-CoV"   "-2"         "đang"       "được"       "điều_trị"   "tại"        "Bệnh_viện"  "Đa_khoa"    "khu_vực"   
# [28] "Thủ_Đức"    "("          "phường"     "Linh_Trung" ","          "TP"         "Thủ_Đức"    ","          "TP."       
# [37] "HCM"        ")"          "đã"         "trốn"       "ra"         "ngoài"      "rồi"        "về"         "nhà"       
# [46] "ở"          "quận"       "10"   
>
> ps <- vc$postag(text)
> unlist(ps)
#         word          tag         word          tag         word          tag         word          tag         word          tag 
#        "Một"          "M"   "lãnh_đạo"          "N"  "Bệnh_viện"          "N"    "Đa_khoa"         "Np"    "khu_vực"          "N" 
#         word          tag         word          tag         word          tag         word          tag         word          tag 
#    "Thủ_Đức"         "Np"         "đã"          "R"   "xác_nhận"          "V"       "trên"          "E"   "Tuổi_trẻ"          "N" 
#         word          tag         word          tag         word          tag         word          tag         word          tag 
#     "online"          "V"       "việc"          "N"          ","         "CH"        "một"          "M"      "người"         "Nc" 
#         word          tag         word          tag         word          tag         word          tag         word          tag 
#    "đàn_ông"          "N" "dương_tính"          "A"        "với"          "E"   "SARS-CoV"         "Nc"         "-2"         "Np" 
#         word          tag         word          tag         word          tag         word          tag         word          tag 
#       "đang"          "R"       "được"          "V"   "điều_trị"          "V"        "tại"          "E"  "Bệnh_viện"         "Np" 
#         word          tag         word          tag         word          tag         word          tag         word          tag 
#    "Đa_khoa"         "Np"    "khu_vực"          "N"    "Thủ_Đức"         "Np"          "("         "CH"     "phường"          "N" 
#         word          tag         word          tag         word          tag         word          tag         word          tag 
# "Linh_Trung"         "Np"          ","         "CH"         "TP"         "Ny"    "Thủ_Đức"         "Np"          ","         "CH" 
#         word          tag         word          tag         word          tag         word          tag         word          tag 
#        "TP."         "Ny"        "HCM"         "Np"          ")"         "CH"         "đã"          "R"       "trốn"          "V" 
#         word          tag         word          tag         word          tag         word          tag         word          tag 
#         "ra"          "V"      "ngoài"          "N"        "rồi"          "C"         "về"          "V"        "nhà"          "N" 
#         word          tag         word          tag         word          tag 
#          "ở"          "E"       "quận"          "N"         "10"          "M" 
```

### Request annotations using `vnlp` Python client

This package has a sample of python client to make annotation request to vncorenlp above. See `vnlp.py`

```python
>>> import vnlpc
>>> vc = vnlpc.VNLPClient("http://localhost:39000")
>>> text = "Ông Nguyễn Khắc Chúc  đang làm việc tại Đại học Quốc gia Hà Nội. Bà Lan, vợ ông Chúc, cũng làm việc tại đây."
>>>
>>> vc.tokenize(text)
['Ông', 'Nguyễn_Khắc_Chúc', 'đang', 'làm_việc', 'tại', 'Đại_học', 'Quốc_gia', 'Hà_Nội', '.', 'Bà', 'Lan', ',', 'vợ', 'ông', 'Chúc', ',', 'cũng', 'làm_việc', 'tại', 'đây', '.']
>>> 
>>> vc.postag(text)
[{'word': 'Ông', 'tag': 'Nc'}, {'word': 'Nguyễn_Khắc_Chúc', 'tag': 'Np'}, {'word': 'đang', 'tag': 'R'}, {'word': 'làm_việc', 'tag': 'V'}, {'word': 'tại', 'tag': 'E'}, {'word': 'Đại_học', 'tag': 'N'}, {'word': 'Quốc_gia', 'tag': 'N'}, {'word': 'Hà_Nội', 'tag': 'Np'}, {'word': '.', 'tag': 'CH'}, {'word': 'Bà', 'tag': 'Nc'}, {'word': 'Lan', 'tag': 'Np'}, {'word': ',', 'tag': 'CH'}, {'word': 'vợ', 'tag': 'N'}, {'word': 'ông', 'tag': 'Nc'}, {'word': 'Chúc', 'tag': 'Np'}, {'word': ',', 'tag': 'CH'}, {'word': 'cũng', 'tag': 'R'}, {'word': 'làm_việc', 'tag': 'V'}, {'word': 'tại', 'tag': 'E'}, {'word': 'đây', 'tag': 'P'}, {'word': '.', 'tag': 'CH'}]
>>> 
```

## Notes on Memory Usage

Note doing NER or Dep Parsing requires memory > 4G.

API server uses default memory of 5G when using ner/depparse and the _first_ request of these kinds will take times.

## License 

MIT

## VNCoreNLP License

https://github.com/vncorenlp/VnCoreNLP/blob/master/LICENSE.md 

VnCoreNLP-1.1.1.jar and all model resources in models dir belongs to `VNCoreNLP`

