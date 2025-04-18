FROM rocker/geospatial:latest
MAINTAINER "Adam M. Wilson" adamw@buffalo.edu

# set display port to avoid crash
ENV DISPLAY=:99

## RUN apt-get remove $(tasksel --task-packages desktop) # from https://unix.stackexchange.com/questions/56316/can-i-remove-gui-from-debian
RUN apt-get update \
  && apt-get install -y \
      libv8-dev \
    lbzip2 \
    libfftw3-dev \
    libgdal-dev \
    libgeos-dev \
    libgsl0-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libjq-dev \    
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libnetcdf-dev \
    libsqlite3-dev \
    libssl-dev \
    libudunits2-dev \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev \
    unixodbc-dev \
    
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

# https://github.com/csaybar/rgee-docker/blob/master/Dockerfile    
RUN apt-get install -y \
		python3-pip \
		python3-dev \
	&& pip3 install virtualenv

RUN pip3 install coveralls \
    oauth2client \
    numpy \
    requests_toolbelt \
    earthengine-api \
    pyasn1
    
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash #from https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md
RUN sudo apt-get install -f git-lfs
RUN git lfs install
RUN sudo find / -name "libtinfo.so.6"
#RUN pip3 install google-api-python-client #https://www.earthdatascience.org/tutorials/intro-google-earth-engine-python-api/
#RUN pip3 install earthengine-api

RUN install2.r --error \
    testthat \
    remotes \
    globals \
    fs \
    writexl \
    rio \
    tidyverse \
    listenv \
    RCurl \
    questionr \
    posterior \
    bayesplot \
    stringr \
    knitr \
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
    jose \
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
    xts \
    rgee
    
## install cmdstanr - note the path below is important for loading library in container
###RUN R -e "remotes::install_github('stan-dev/cmdstanr')"
##RUN R -e "install.packages('cmdstanr', repos = c('https://stan-dev.r-universe.dev', getOption('repos')))" 
#RUN R -e "remotes::install_github('futureverse/parallelly', ref='master')"
#RUN R -e "dir.create('/home/rstudio/.cmdstanr', recursive=T); cmdstanr::install_cmdstan(dir='/home/rstudio/.cmdstanr')"
#RUN R -e "remotes::install_github('ropensci/stantargets')"
#RUN R -e "install.packages('geotargets', repos = c('https://ropensci.r-universe.dev', 'https://cran.r-project.org'))"
#RUN R -e "install.packages('https://gitlab.rrz.uni-hamburg.de/helgejentsch/climdatdownloadr/-/archive/master/climdatdownloadr-master.tar.gz', repos = NULL, type = 'source')"
#RUN R -e "webshot::install_phantomjs()" # to make pngs from html output
#RUN R -e "devtools::install_github('JoshOBrien/gdalUtilities')"
# Install rgee Python dependencies
RUN R -e "library(rgee); \
          HOME <- Sys.getenv('HOME'); \ 
          reticulate::install_miniconda(); \ 
          system('find . -name \'libtinfo*\''); \
          system('curl -sSL https://sdk.cloud.google.com | bash'); \
          Sys.setenv('RETICULATE_PYTHON' = sprintf('/root/.local/share/r-miniconda/bin/python3', HOME)); \   
          Sys.setenv('EARTHENGINE_GCLOUD' = sprintf('%s/google-cloud-sdk/bin/', HOME)); \
          ee_install()" 
