# EMMA Docker Container


# Instructions


## Quickstart
```
docker run --rm -p 8787:8787 -e PASSWORD=yourpasswordhere adamwilsonlab/emma:latest
```

Visit `localhost:8787` in your browser and log in with username rstudio and the password you set. NB: Setting a password is now REQUIRED. Container will error otherwise.


## Local machine (no password)

If you are running on a local machine with other security mechanisms, you can use the following:

```
docker run --rm \
  -p 127.0.0.1:8787:8787 \
  -e DISABLE_AUTH=true \
  adamwilsonlab/emma:latest
```

## Singularity

There are two methods to pull the docker image into Singularity as explained below.  

### Set some useful environment variables

If you don't do this you're likely to run out of space because the home directory doesn't have much room.

```
# mount project folder inside container:
export PROJECT_FOLDER="/projects/academic/adamw/"
# path to singularity container file.  If you want to use a different image, you'll need
# to update this line.
export DOCKER_PATH="docker://adamwilsonlab/emma:latest"
export CONTAINER_PATH="/panasas/scratch/grp-adamw/singularity/$USER/AdamWilsonLab-emma_docker:latest.sif"
# to use for ssh:
export SERVER_URL="horae.ccr.buffalo.edu"
# folder to hold temporary singularity files - unique for each user:
# export SINGULARITY_LOCALCACHEDIR="/panasas/scratch/grp-adamw/singularity/"$USER
export SINGULARITY_LOCALCACHEDIR="/ssd_data/singularity/"$USER

# name the resulting sif file
export SIF_PATH=$SINGULARITY_LOCALCACHEDIR/"AdamWilsonLab-emma_docker-latest.sif"

# define a few more folders used by singularity
export SINGULARITY_CACHEDIR=$SINGULARITY_LOCALCACHEDIR
export SINGULARITY_TMPDIR=$SINGULARITY_LOCALCACHEDIR

# Create the folders if they don't already exist
mkdir -p $SINGULARITY_LOCALCACHEDIR/tmp
mkdir -p $SINGULARITY_LOCALCACHEDIR/run
mkdir -p $SINGULARITY_LOCALCACHEDIR/rstudio



```

### Build directly from Docker image locally

Build the .sif directly from the docker image.

```
# build the singularity image - note this takes about 3 hours on horae!
nohup singularity build --force $SIF_PATH $DOCKER_PATH &
```

The `nohup` simply allows it to keep running if the SSH connection is broken.

Then follow the [`singularity_start.sh`](singularity_start.sh) script.


### Use the precompiled .sif from Github

A .sif file is compiled using github actions when the version number of the image is updated in this repository.  These can be found [here](https://github.com/AdamWilsonLab/emma_docker/releases).  However, they are only produced if turned on in the GitHub actions `builder.yml` file.

You will only need to run the following once (unless the image changes).

```
cd /panasas/scratch/grp-adamw/singularity/adamw
rm AdamWilsonLab-emma_docker-latest.sif
wget -O $SIF_PATH https://github.com/AdamWilsonLab/emma_docker/releases/download/0.0.530/AdamWilsonLab-emma_docker-latest.sif.zip
unzip $SIF_PATH
```

Then follow the [`singularity_start.sh`](singularity_start.sh) script.
