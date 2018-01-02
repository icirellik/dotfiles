#!/bin/bash
# Bash script installing docker.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

sudo apt-get remove -y docker docker-engine docker.io

sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install -y docker-ce

# Setup the docker groups for your normal user.

sudo groupadd docker
sudo usermod -aG docker "${USER}"
