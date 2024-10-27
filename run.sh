# Clear the log file
> misc/docker/docker.log

# Redirect all output to both the console and docker.log
exec > >(tee -a misc/docker/docker.log) 2>&1

# Requirements
sudo apt install docker.io
sudo systemctl start docker
apt-get install x11-xserver-utils
xhost +local:docker

# Make the Image
sudo docker build           \
    misc/docker/.           \
    --tag geckos_container

# Run the container
sudo docker run                                 \
    --rm                                        \
    -it                                         \
    -v                                          \
    --env="DISPLAY"                             \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$(pwd):/root/env"                 \
    --device=/dev/kvm                           \
    --privileged                                \
    --sig-proxy=true                            \
    geckos_container
