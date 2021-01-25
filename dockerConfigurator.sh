#!/bin/bash

#Update apt-get and install dependencies
apt update && apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Add Docker public GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Verify Docker key is valid
apt-key fingerprint 0EBFCD88

# Add Docker's repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#Update OS and install docker
apt-get update && apt-get install docker-ce docker-ce-cli containerd.io

# Start docker and check if it is running (Print container information)
/etc/init.d/docker start && docker ps

# install docker compose and make it executable
curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Print docker compose version
docker-compose --version

# Create a user-defined bridged network. Unlike the already existing bridge network, the user defined one will have container name DNS resolution for containers within that network. This is useful if later we want to setup additional containers which need to speak with the GoShimmer container.
docker network create --driver=bridge shimmer
