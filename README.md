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

# HPC
To use this container in an HPC environment like UB's CCR, you need to use singularity (a wrapper for docker that keeps things secure in a networked environment).

## Singularity on UB's HPC


If you don't set these temp/cache folders you're likely to run out of space because the home directory doesn't have much room.

First log into a compute node.  For example:

```
salloc --cluster=faculty --qos=adamw --partition=adamw  --job-name "InteractiveJob" --nodes=1 --ntasks=2 --mem=5G -C INTEL --time=05:20:00
```

```
# define groupname for paths
export GROUP="adamw"

# mount project folder inside container:
export PROJECT_FOLDER="/projects/academic/"$GROUP

# define local working folder to build the SIF file (this is faster than network storage)
export APPTAINER_CACHEDIR="/scratch/"$USER"/apptainer"
export APPTAINER_TMPDIR=$APPTAINER_CACHEDIR"/tmp"
export APPTAINER_LOCALCACHEDIR=$APPTAINER_CACHEDIR"/tmp"

# set singularity cache and tmp directories to the same as apptainer
# needed because CCR is still using singularity and it will use these directories
export SINGULARITY_CACHEDIR=$APPTAINER_CACHEDIR
export SINGULARITY_TMPDIR=$APPTAINER_TMPDIR
export SINGULARITY_LOCALCACHEDIR=$APPTAINER_LOCALCACHEDIR

# path to singularity container file.  If you want to use a different image, you'll need
# to update this line.
export DOCKER_PATH="docker://adamwilsonlab/emma:latest"
export SIF_FILE="AdamWilsonLab-emma_docker-latest.sif"
export SIF_PATH=$PROJECT_FOLDER"/users/"$USER"/apptainer/"

# Create the folders if they don't already exist
mkdir -p $PROJECT_FOLDER"/users/"$USER"/apptainer" # create project folder
mkdir -p $APPTAINER_CACHEDIR/tmp # create apptainer cache directory
mkdir -p $APPTAINER_CACHEDIR/run # create apptainer run directory
mkdir -p $APPTAINER_CACHEDIR/rstudio # create apptainer RStudio directory

# go to cachedir for faster build
cd $APPTAINER_CACHEDIR

## Build the singularity image (.SIF) directly from Docker image locally
### If it takes too long, you can use `nohup` first to allow it to keep running if the SSH connection is broken.
singularity build --force $SIF_FILE $DOCKER_PATH &

# Move it to its permanent home
mkdir -p $SIF_PATH # create SIF path if it doesn't exist
mv $SIF_FILE $SIF_PATH # move the SIF file to its permanent location


```


## Accessing the image for interactive computation

1. SSH to vortex.ccr.buffalo.edu and then request an interactive job with something like: 

```
salloc --cluster=faculty --qos=adamw --partition=adamw  --job-name "InteractiveJob" --nodes=1 --ntasks=2 --mem=5G -C INTEL --time=05:20:00
```

Then run the following to start using R from the container:

```
export PROJECT_FOLDER="/projects/academic/adamw/"
export APPTAINER_CACHEDIR="/scratch/"$USER"/singularity"
export SIF_PATH=$PROJECT_FOLDER"/users/"$USER"/singularity"
export SIF_FILE="AdamWilsonLab-emma_docker-latest.sif"


singularity run \
      --bind $PROJECT_FOLDER:$PROJECT_FOLDER \
      --bind $APPTAINER_CACHEDIR/tmp:/tmp \
      --bind $APPTAINER_CACHEDIR/run:/run \
      $SIF_PATH/$SIF_FILE R
```

2. Use [CCR's OnDemand portal](https://ondemand.ccr.buffalo.edu/pun/sys/dashboard/)
