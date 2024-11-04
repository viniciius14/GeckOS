#!/bin/sh

# Delete the last log file
rm -f misc/docker/docker.log

# Requirements
sudo apt install docker.io              && \
sudo systemctl start docker             && \
sudo apt-get install x11-xserver-utils  && \
xhost +local:docker                 >> misc/docker/docker.log 2>&1 # Redirect output to a log file

# Make the Image
sudo docker build           \
    misc/docker/.           \
    --tag geckos_container          >> misc/docker/docker.log 2>&1

# Run the container
container_id=$(                                 \
    sudo docker run                             \
    -d -it --rm                                 \
    --env="DISPLAY"                             \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$(pwd):/root/env"                 \
    --device=/dev/kvm                           \
    --privileged                                \
    geckos_container
)

docker exec -it "$container_id" bash -c "make > misc/build/make.log"
# docker exec -it "$container_id" bash
