#!/bin/bash

# Purpose:  pull and run an NVIDIA container 
# Notes:    this is specific to my NVIDIA Jetson
# Date:     2022-06-23 

export CONTAINER_NAME="l4t-ml:r32.6.1-py3"

# OPTIONS
export JUPYTER_TOKEN="notAPassword"
export JUPYTER_ENABLE_LAB=yes
export CHOWN_HOME=yes
export USER=root
export NB_USER=nvidia
export WORK_PATH=/home/nvidia/work/
export NOTEBOOKS_PATH=/home/nvidia/Notebooks/

run_me() {
  sudo docker pull nvcr.io/nvidia/${CONTAINER_NAME}
  sudo docker run -it --rm --runtime nvidia --network host -p 8888:8888 \
	  --user $USER -e NB_USER=$NB_USER \
	  -e CHOWN_HOME=$CHOWN_HOME -e JUPYTER_ENABLE_LAB=$JUPYTER_ENABLE_LAB -e JUPYTER_TOKEN=$JUPYTER_TOKEN \
	  -v ${NOTEBOOKS_PATH}:/Notebooks -v ${WORK_PATH}:/work \
	  nvcr.io/nvidia/${CONTAINER_NAME}
}

run_me() {
  sudo docker pull nvcr.io/nvidia/${CONTAINER_NAME}
  sudo docker run -it --rm --runtime nvidia --network host -p 8888:8888 \
          -e CHOWN_HOME=$CHOWN_HOME -e JUPYTER_ENABLE_LAB=$JUPYTER_ENABLE_LAB -e JUPYTER_TOKEN=$JUPYTER_TOKEN \
          -v /home/nvidia/Notebooks:/Notebooks nvcr.io/nvidia/${CONTAINER_NAME}
}

run_me

exit 0

## References
Browse to http://<hostname or IP>:8888/?token=<whatever you set JUPYTER_TOKEN to>

https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-ml
https://github.com/dusty-nv/jetson-containers

sudo docker pull jupyter/datascience-notebook:latest << this doesn't work on ARM

# the original method I used
sudo docker pull nvcr.io/nvidia/l4t-ml:r34.1.0-py3
sudo docker run -it --rm --runtime nvidia --network host -v /home/nvidia/Notebooks:/ nvcr.io/nvidia/l4t-ml:r34.1.0-py3


