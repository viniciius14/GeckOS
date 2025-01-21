#!/bin/sh

# Delete the last log file
rm -f misc/docker/docker.log

# Install docker
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Requirements
sudo apt install docker.io
sudo systemctl start docker
sudo apt-get install x11-xserver-utils
xhost +local:docker

# Make the Image
sudo docker build           \
    misc/docker/.           \
    --tag geckos_container  2>&1 | tee -a misc/docker/docker.log

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

# docker exec -it "$container_id" bash -c "make 2>&1 | tee -a misc/build/make.log"
docker exec -it "$container_id" bash

# Clear out bin directory
# rm -rf bin/*
