FROM rocker/geospatial
MAINTAINER "Adam M. Wilson" adamw@buffalo.edu

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
    python3.8
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash #from https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md
RUN sudo apt-get install -f git-lfs
RUN git lfs install
RUN python -m ensurepip
RUN pip install earthengine-api

RUN install2.r --error \
    testthat \
    RCurl \
    questionr \
    posterior \
    bayesplot \
    stringr \
    knitr \
    rgee
    ## from other places
    && R -e "remotes::install_github('stan-dev/cmdstanr')" \
    && R -e "cmdstanr::install_cmdstan()"
