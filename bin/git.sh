#!/bin/bash
# Bash script installing the latest version of git, it is required for
# usign conditional includes.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

is_osx() {
  local platform
  platform=$(uname)
  [ "$platform" == "Darwin" ]
}

if is_osx; then
  echo "This script does not run on OSX"
  exit
fi

if [[ $(id -u) -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update
sudo apt install -y git
