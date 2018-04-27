#!/bin/bash
# Bash script installing the synergy core from source.
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

if [[ $(id -u) -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  cmake \
  g++ \
  git \
  libavahi-compat-libdnssd-dev \
  libcurl4-openssl-dev \
  libqt4-dev \
  libssl-dev \
  libx11-dev \
  make \
  xorg-dev

git clone https://github.com/symless/synergy-core.git synergy-core
(
cd synergy-core
mkdir build
cmake -DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 -DCMAKE_OSX_ARCHITECTURES=x86_64
make
)
rm -rf synergy-core
