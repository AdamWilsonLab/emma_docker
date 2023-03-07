#! /usr/bin/env bash

# mount project folder inside container:
export PROJECT_FOLDER="/projects/academic/adamw/"
# path to singularity container file.  If you want to use a different image, you'll need
# to update this line.
export CONTAINER_PATH=$PROJECT_FOLDER"/"$USER"/singularity/emma_docker-latest.sif"

# to use for ssh:
export SERVER_URL="horae.ccr.buffalo.edu"

# folder to hold temporary singularity files - unique for each user:
export APPTAINER_CACHEDIR="/scratch/"$USER"/singularity"
export TMPDIR=$APPTAINER_CACHEDIR
export APPTAINER_TMPDIR=$APPTAINER_CACHEDIR


# Create the folders if they don't already exist
mkdir -p $APPTAINER_CACHEDIR/tmp
mkdir -p $APPTAINER_CACHEDIR/run
mkdir -p $APPTAINER_CACHEDIR/rstudio


# Run as particular group to use group storage
newgrp grp-adamw



# Start the instance using variables above
singularity instance start \
      --bind $PROJECT_FOLDER:$PROJECT_FOLDER \
      --bind $APPTAINER_CACHEDIR/tmp:/tmp \
      --bind $APPTAINER_CACHEDIR/run:/run \
      --bind $APPTAINER_CACHEDIR/rstudio:/var/lib/rstudio-server \
      $CONTAINER_PATH rserver

# Start the rserver within the container
singularity exec instance://rserver rserver --server-user=$USER --www-port ${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper &

# write a file with the details (port and password)
echo "
    1. SSH tunnel from your workstation using the following command:

       ssh -N -L 8787:${SERVER_URL}:${PORT} ${USER}@${SERVER_URL}

       and point your web browser to http://localhost:8787

    2. log in to RStudio Server using the following credentials:

       user: ${USER}
       password: ${PASSWORD}

    3. to repeat these instructions:

      cat ~/singularity_status.txt


    When done using RStudio Server, terminate the job by:

    1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
    2. Issue the following command on the login node:

          singularity instance stop rserver


" > ~/singularity_status.txt

cat ~/singularity_status.txt
