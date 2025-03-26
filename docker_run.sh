#!/bin/sh

# Allow Docker to connect to the X11 server
xhost +local:docker

# Build the Docker image
docker build \
    -t geckos \
    misc/docker/. \
    2>&1 | tee -a misc/docker/docker.log

# Run the container interactively
docker run \
    -it --rm \
    --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$(pwd):/GeckOS" \
    --device=/dev/kvm \
    --privileged \
    geckos
