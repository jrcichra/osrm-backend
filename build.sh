#!/bin/bash
sudo apt purge -y docker-ce
export DOCKER_CLI_EXPERIMENTAL=enabled
curl -fsSL https://get.docker.com/ -o docker-install.sh
CHANNEL=nightly sh docker-install.sh
export DOCKER_CLI_EXPERIMENTAL=enabled
docker version
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
docker buildx --help
docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3
cat /proc/sys/fs/binfmt_misc/qemu-aarch64
docker buildx create --name testbuilder
docker buildx use testbuilder
docker buildx inspect --bootstrap
# Phase 2 - sign in
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin 
# Phase 3 - build a container
if [ "$1" == "DEBUG" ];then
    docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --build-arg DOCKER_TAG=jrcichra/osrm-backend-rpi-debug -t jrcichra/osrm-backend-rpi-debug --push .
    docker buildx imagetools inspect jrcichra/osrm-backend-rpi
else
    docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --build-arg DOCKER_TAG=jrcichra/osrm-backend-rpi -t jrcichra/osrm-backend-rpi --push .
    docker buildx imagetools inspect jrcichra/osrm-backend-rpi
fi