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
    jags


RUN install2.r --error \
    posterior \
    bayesplot \
    stringr \
    knitr \
    ## from other places
    && R -e "remotes::install_github('stan-dev/cmdstanr')" \
    && R -e "cmdstanr::install_cmdstan()"
