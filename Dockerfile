# This Dockerfile is based on the rocker/binder example Dockerfile from https://github.com/rocker-org/binder/
# We use 3.6.0 because it is a recent version of R that has a fixed MRAN date in the Rocker image.
FROM rocker/binder:3.6.0

## Declares build arguments
ARG NB_USER
ARG NB_UID

## Run install.R script
COPY install.R ${HOME}
RUN R --quiet -f install.R

## Copies all repo files into the Docker Container
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}

# --- Metadata ---
LABEL maintainer="carlos.granell@uji.es" \
  Name="TGIS 2020 paper" \
  org.opencontainers.image.created="2020-08" \
  org.opencontainers.image.authors="Carlos Granell" \
  org.opencontainers.image.url="https://github.com/cgranell/ideais-scopingreview-2019" \
  org.opencontainers.image.documentation="https://github.com/cgranell/ideais-scopingreview-2019"

# --- Usage instructions ---
## Build the image
# $ docker build --tag tgis2020-paper .
#
## Run the image for interactive UI
# $ docker run -it -p 8888:8888 tgis2020-paper
# Next, open a browser at http://localhost:8888 or click on the login link shown in the console.
# It will show the Jupyter start page and you can now open RStudio via the menu "New".
#
## Run the image to run the R analysis
# $ docker run -i -v $(pwd): --user $UID tgis2020-paper 