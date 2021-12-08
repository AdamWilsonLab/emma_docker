Bootstrap: docker
From: adamwilsonlab/emma:latest

%labels
  Author Adam M. Wilson
  Version 0.0.1

%apprun rserver
    exec rserver "${@}"

%runscript
    exec rserver "${@}"

%startscript
    echo "Container was created $NOW"
    echo "RUNNING rserver startscript"
    echo "Arguments received: $*"
    echo user = $USER      password = $PASSWORD     port = $PORT
    rserver  "$@"

%post

  # Save date - not sure if this is needed
        NOW=`date`
        echo "export NOW=\"${NOW}\"" >> $SINGULARITY_ENVIRONMENT
