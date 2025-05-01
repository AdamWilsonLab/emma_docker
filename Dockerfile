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
    libssl-dev \
    openssl \
    && openssl version

#    locales \
#    libssl-dev \
#    libxml2-dev \
#    libcairo2-dev \
#    libxt-dev \
#    libcgal-dev \
#    ca-certificates \
#    libtbbmalloc2 \
#    netcat-traditional \
#    libsecret-1-0 \
#    jags \
#    libcurl4-openssl-dev \
#    libssl-dev \
#    libzmq3-dev \
#    python3 \
#    python3-dev \
#    python3-pip \
#    python3-full \
#    python3-venv \
#    python3-oauth2client \
#    python3-coveralls \
#    python3-numpy \
#    python3-requests_toolbelt \
#    python3-earthengine-api \
#    python3-pyasn1 \
#    libcurl4-openssl-dev

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash #from https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md
RUN sudo apt-get install -f git-lfs
RUN git lfs install

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
    arrow \
    tidyverse \
    dygraphs \
    geotargets \
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
    stantargets \
    stars \
    tarchetypes \
    targets \
    terra \
    tidyterra \
    xts


## install additional libraries from custom repos including cmdstanr - note the path below is important for loading library in container
RUN R -e "remotes::install_github('futureverse/parallelly', ref='master'); \
          install.packages('cmdstanr', repos = c('https://stan-dev.r-universe.dev', getOption('repos'))) ; \
          dir.create('/home/rstudio/.cmdstanr', recursive=T); cmdstanr::install_cmdstan(dir='/home/rstudio/.cmdstanr'); \
          remotes::install_github('ropensci/stantargets'); \
          install.packages('geotargets', repos = c('https://ropensci.r-universe.dev', 'https://cran.r-project.org')); \
          install.packages('https://gitlab.rrz.uni-hamburg.de/helgejentsch/climdatdownloadr/-/archive/master/climdatdownloadr-master.tar.gz', repos = NULL, type = 'source'); \
          webshot::install_phantomjs(); \
          devtools::install_github('JoshOBrien/gdalUtilities')"

# Install rgee Python dependencies
RUN R -e "Sys.setenv('RETICULATE_MINICONDA_PATH' = '/root/miniconda3'); \
          reticulate::install_miniconda(path=Sys.getenv('RETICULATE_MINICONDA_PATH')); \
          options(reticulate.conda_binary = paste0(Sys.getenv('RETICULATE_MINICONDA_PATH'),'/bin/conda')); \
          reticulate::use_condaenv('/root/miniconda3/envs/r-reticulate'); \
          print(reticulate::py_config()); \
          print(reticulate::py_discover_config()); \
          reticulate::conda_install(c('fermipy','numpy','earthengine-api','openssl>=3.3.0'),envname='r-reticulate'); \
          print(reticulate::py_discover_config()); \
          reticulate::conda_list(); \
          print(reticulate::py_config()); \
          remotes::install_github('r-spatial/rgee'); \
          print(reticulate::py_config()); \
          rgee::ee_install_set_pyenv(py_path = '/root/miniconda3/envs/r-reticulate/bin/python',py_env = 'r-reticulate'); \
          print(reticulate::py_config()); \
          HOME <- Sys.getenv('HOME'); \
          system('curl -sSL https://sdk.cloud.google.com | bash'); \
          Sys.setenv('EARTHENGINE_GCLOUD' = sprintf('%s/google-cloud-sdk/bin/', HOME)); \
          rgee::ee_check()"

#           reticulate::use_condaenv('/root/miniconda3/envs/r-reticulate'); \
#           reticulate::conda_install('numpy',envname='/root/miniconda3/envs/r-reticulate'); \
#          reticulate::conda_install('earthengine-api', envname='/root/miniconda3/envs/r-reticulate'); \
# rgee::ee_install(py_env = 'rgee', confirm = FALSE); \
# Sys.setenv('RETICULATE_PYTHON' = '/root/miniconda3/bin/python'); \
#          Sys.setenv('RETICULATE_MINICONDA_PATH' = '/root/miniconda3/bin/python'); \
#          Sys.setenv('RETICULATE_PYTHON' = '/root/miniconda3/bin/python'); \
#         rgee::ee_install_set_pyenv(py_path = '/root/miniconda3/bin/python'); \
#rgee::ee_clean_pyenv(); \
