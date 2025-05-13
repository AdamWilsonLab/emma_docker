FROM rocker/geospatial
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
    tk-dev 

## Install Quarto library
RUN wget https://quarto.org/download/latest/quarto-linux-amd64.deb && \
    sudo dpkg -i quarto-linux-amd64.deb

# Install git-lfs #from https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
    apt-get install -f git-lfs && \
    git lfs install

# Install Miniconda
ENV MINICONDA_VERSION=py39_24.1.2-0
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh

ENV PATH=/opt/conda/bin:$PATH
ENV CONDA_PATH=/opt/conda/bin/conda

# Create a conda environment with Python 3.9 and compatible OpenSSL (default python was giving problems with openssl 3.3
RUN conda create -y -n r-reticulate python=3.9 openssl=3.0 \
    numpy pyopenssl

# Activate conda env and set it as default for reticulate
ENV RETICULATE_PYTHON=/opt/conda/envs/r-reticulate/bin/python
ENV RETICULATE_ENV=/opt/conda/envs/r-reticulate


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
    reticulate \
    cowplot


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
RUN R -e "options(reticulate.conda_binary = Sys.getenv('CONDA_PATH')); \
          reticulate::use_condaenv(Sys.getenv('RETICULATE_ENV')); \
          print(reticulate::py_config()); \
          reticulate::conda_install(c('ncurses','pyCrypto','fermipy','numpy','earthengine-api','pyOpenSSL>=0.11'),envname='r-reticulate'); \
          print(reticulate::py_config())"

RUN R -e "remotes::install_github('r-spatial/rgee',upgrade='always'); \
          print(reticulate::py_config()); \
          rgee::ee_install_set_pyenv(py_path = Sys.getenv('RETICULATE_PYTHON'),py_env = 'r-reticulate'); \
          print(reticulate::py_config()); \
	  HOME <- Sys.getenv('HOME'); \
          system('curl -sSL https://sdk.cloud.google.com | bash'); \
          Sys.setenv('EARTHENGINE_GCLOUD' = sprintf('%s/google-cloud-sdk/bin/', HOME))"


# Install rgee Python dependencies
#RUN R -e "Sys.setenv('RETICULATE_MINICONDA_PATH' = '/root/miniconda3'); \
#          reticulate::install_miniconda(path=Sys.getenv('RETICULATE_MINICONDA_PATH')); \
#          options(reticulate.conda_binary = paste0(Sys.getenv('RETICULATE_MINICONDA_PATH'),'/bin/conda')); \
#	  reticulate::conda_create(envname = 'r-reticulate', python_version = '3.9'); \
#          reticulate::use_condaenv('/root/miniconda3/envs/r-reticulate'); \
#          print(reticulate::py_config()); \
#          print(reticulate::py_discover_config()); \
#          reticulate::conda_install(c('pyCrypto','fermipy','numpy','earthengine-api','pyOpenSSL>=0.11'),envname='r-reticulate'); \
#          print(reticulate::py_discover_config()); \
#          reticulate::conda_list(); \
#          print(reticulate::py_config()); \
#          remotes::install_github('r-spatial/rgee',upgrade='always'); \
#          print(reticulate::py_config()); \
#          rgee::ee_install_set_pyenv(py_path = '/root/miniconda3/envs/r-reticulate/bin/python',py_env = 'r-reticulate'); \
#          print(reticulate::py_config()); \
#          HOME <- Sys.getenv('HOME'); \
#          system('curl -sSL https://sdk.cloud.google.com | bash'); \
#          Sys.setenv('EARTHENGINE_GCLOUD' = sprintf('%s/google-cloud-sdk/bin/', HOME)); \
#          rgee::ee_check()"

#           reticulate::use_condaenv('/root/miniconda3/envs/r-reticulate'); \
#           reticulate::conda_install('numpy',envname='/root/miniconda3/envs/r-reticulate'); \
#          reticulate::conda_install('earthengine-api', envname='/root/miniconda3/envs/r-reticulate'); \
# rgee::ee_install(py_env = 'rgee', confirm = FALSE); \
# Sys.setenv('RETICULATE_PYTHON' = '/root/miniconda3/bin/python'); \
#          Sys.setenv('RETICULATE_MINICONDA_PATH' = '/root/miniconda3/bin/python'); \
#          Sys.setenv('RETICULATE_PYTHON' = '/root/miniconda3/bin/python'); \
#         rgee::ee_install_set_pyenv(py_path = '/root/miniconda3/bin/python'); \
#rgee::ee_clean_pyenv(); \
