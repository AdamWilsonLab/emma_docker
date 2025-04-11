FROM rocker/geospatial:latest
MAINTAINER "Adam M. Wilson" adamw@buffalo.edu

# set display port to avoid crash
ENV DISPLAY=:99

## RUN apt-get remove $(tasksel --task-packages desktop) # from https://unix.stackexchange.com/questions/56316/can-i-remove-gui-from-debian
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    locales \
    libssl-dev \
    libxml2-dev \
    libcairo2-dev \
    libxt-dev \
    libcgal-dev \
    ca-certificates \
    libtbbmalloc2 \
    netcat-traditional \
    libsecret-1-0 \
    jags \
    libcurl4-openssl-dev \
    libssl-dev \
    libzmq3-dev \
    python3 \
    python3-dev \
    python3-pip \
    python3-full \
    python3-venv \
    libcurl4-openssl-dev 
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash #from https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md
RUN sudo apt-get install -f git-lfs
RUN git lfs install
#RUN pip3 install google-api-python-client #https://www.earthdatascience.org/tutorials/intro-google-earth-engine-python-api/
#RUN pip3 install earthengine-api

RUN install2.r --error \
    testthat \
    RCurl \
    questionr \
    posterior \
    bayesplot \
    stringr \
    knitr \
    rgee \
    cptcity \
    geojsonio \
    targets \
    tarchetypes \
    visNetwork \
    googleCloudStorageR \
    janitor \
    qpdf \
    RefManageR \
    svMisc \
    geojsonio \
    cubelyr \
    rdryad \
    doParallel \
    piggyback \
    arrow \
    bibtex \
    proto \
    slam \
    ape \ 
    fasterize \
    exactextractr \
    RcppEigen \ 
    jpeg \ 
    interp \ 
    latticeExtra \
    hexbin \
    prioritizr \
    plotly \
    arrow \
    tidyverse \
    dygraphs \
    ggridges \
    GSODR \
    gt \
    leafem \
    leaflet \
    lubridate \
    mapview \
    piggyback \
    plotly \
    quarto \
    raster \
    rinat \
    rmarkdown \
    sf \
    SPEI \
    stars \
    tarchetypes \
    targets \
    terra \
    tidyterra \
    xts
    
## install cmdstanr - note the path below is important for loading library in container
## RUN R -e "remotes::install_github('stan-dev/cmdstanr')"
RUN R -e "install.packages('cmdstanr', repos = c('https://stan-dev.r-universe.dev', getOption('repos')))" 
RUN R -e "dir.create('/home/rstudio/.cmdstanr', recursive=T); cmdstanr::install_cmdstan(dir='/home/rstudio/.cmdstanr')"
RUN R -e "remotes::install_github('ropensci/stantargets')"
RUN R -e "install.packages('geotargets', repos = c('https://ropensci.r-universe.dev', 'https://cran.r-project.org'))"
RUN R -e "install.packages('https://gitlab.rrz.uni-hamburg.de/helgejentsch/climdatdownloadr/-/archive/master/climdatdownloadr-master.tar.gz', repos = NULL, type = 'source')"
RUN R -e "webshot::install_phantomjs()" # to make png's from html output
RUN R -e "devtools::install_github('JoshOBrien/gdalUtilities')"
RUN R -e "reticulate::py_config()" \ # see the name of your conda (python) environment, in my case "r-reticulate" 
RUN R -e "reticulate::py_install('earthengine-api', envname='r-reticulate') #==0.1.370
# Check the installation of "earthengine-api" with 
RUN R -e "reticulate::py_list_packages() 
RUN R -e "reticulate::pyl <- py_list_packages()
RUN R -e "reticulate::pyl[pyl$package == 'earthengine-api', ]
# check python version with
RUN R -e "reticulate::py_run_string("import sys; print(sys.version)")
RUN R -e "devtools::install_github(repo = "bmaitner/rgee", ref = "noninteractive_auth")

#RUN R -e "rgee::ee_install(confirm = FALSE)"
#RUN R -e "reticulate::py_install(packages = c(sprintf('earthengine-api==%s',rgee::ee_version())), envname = Sys.getenv('EARTHENGINE_ENV'))" # rgee::ee_install_upgrade() without menu
