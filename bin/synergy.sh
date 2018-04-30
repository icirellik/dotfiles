#!/bin/bash
# Bash script installing the synergy core from source.
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

is_osx() {
  local platform
  platform=$(uname)
  [ "$platform" == "Darwin" ]
}

install_linux() {
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

  if [ -d "synergy-core" ]; then
    rm -rf "synergy-core"
  fi
  if [ -d "${HOME}/tools/synergy" ]; then
    rm -rf "${HOME}/tools/synergy"
  fi
  git clone https://github.com/symless/synergy-core.git synergy-core
  (
    cd synergy-core
    mkdir build
    cd build
    cmake ..
    make
    mkdir -p "${HOME}/tools/synergy"
    mv bin "${HOME}/tools/synergy/"
  )
  rm -rf synergy-core
  sudo ln -sf "${HOME}/tools/synergy/bin/synergy-core /usr/local/bin/synergy-core"
}

install_macos() {
  brew install cmake

  git clone https://github.com/symless/synergy-core.git synergy-core
  (
  cd synergy-core
  mkdir build
  cmake -DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 -DCMAKE_OSX_ARCHITECTURES=x86_64
  make
  )
  rm -rf synergy-core

}

main() {
  if is_osx; then
    install_macos
  else
    install_linux
  fi
}

main "$@"
