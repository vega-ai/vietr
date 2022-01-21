FROM rstudio/plumber
MAINTAINER anh <anhlh2@gmail.com>

RUN apt-get -y update
RUN apt-get -y install openjdk-8-jdk liblzma-dev libpcre2-dev libbz2-dev
RUN R CMD javareconf
RUN R -e 'install.packages("rJava")'
RUN R -e 'install.packages(c("R6", "assertthat", "httr"))'

COPY . /app/vietr
WORKDIR /app/vietr

RUN R CMD INSTALL --no-multiarch --with-keep.source ../vietr
COPY models R/models

CMD ["R/api.R"]
