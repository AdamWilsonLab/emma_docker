FROM rocker/geospatial:latest
MAINTAINER "Adam M. Wilson" adamw@buffalo.edu

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
    netcat\
    libsecret-1-0 \
    jags \
    libcurl4-openssl-dev \
    libssl-dev \
    libzmq3-dev \
    python3 \
    python3-pip \
    python3-venv \
    libcurl4-openssl-dev \
    libtbb2
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash #from https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md
RUN sudo apt-get install -f git-lfs
RUN git lfs install
RUN pip install google-api-python-client #https://www.earthdatascience.org/tutorials/intro-google-earth-engine-python-api/
RUN pip3 install earthengine-api

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
    ## install cmdstanr - note the path below is important for loading library in container
    #&& R -e "remotes::install_github('stan-dev/cmdstanr')" \
    && R -e "install.packages('cmdstanr', repos = c('https://mc-stan.org/r-packages/', getOption('repos')))" \
    && R -e "dir.create('/home/rstudio/.cmdstanr', recursive=T); cmdstanr::install_cmdstan(dir='/home/rstudio/.cmdstanr')" \
    && R -e "webshot::install_phantomjs()" # to make png's from html output \
    && R -e "devtools::install_github("JoshOBrien/gdalUtilities")
RUN R -e "remotes::install_github('ropensci/stantargets')"
RUN R -e "rgee::ee_install(confirm = FALSE)"
RUN R -e "reticulate::py_install(packages = c(sprintf('earthengine-api==%s',rgee::ee_version())), envname = Sys.getenv('EARTHENGINE_ENV'))" # rgee::ee_install_upgrade() without menu
RUN R -e "install.packages('https://gitlab.rrz.uni-hamburg.de/helgejentsch/climdatdownloadr/-/archive/master/climdatdownloadr-master.tar.gz', repos = NULL, type = 'source')"
