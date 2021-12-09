FROM rocker/geospatial
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
    libglu1-mesa-dev \
    ca-certificates \
    netcat\
    libsecret-1-0 \
    jags \
    libcurl4-openssl-dev \
    libssl-dev \
    libzmq3-dev \
    python3 \
    python3-pip \
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
    googleCloudStorageR \
    ## install cmdstanr - note the path below is important for loading library in container
    && R -e "remotes::install_github('stan-dev/cmdstanr')" \
    && R -e "dir.create('/home/rstudio/.cmdstanr', recursive=T); cmdstanr::install_cmdstan(dir='/home/rstudio/.cmdstanr')"
