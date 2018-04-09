#!/bin/bash
# Bash script installing lastpass cli.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

is_osx() {
	local platform
  platform=$(uname)
	[ "$platform" == "Darwin" ]
}

linux_install() {
  sudo apt-get install -y \
    asciidoc \
    build-essential \
    cmake \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2 \
    libxml2-dev \
    openssl \
    pinentry-curses \
    pkg-config \
    xclip \
    xsltproc

  if [ -d 'lastpass-cli' ]; then
    echo "Removing old install dir"
    rm -rf lastpass-cli
  fi
  git clone git@github.com:lastpass/lastpass-cli.git

  (
  cd lastpass-cli
  make
  sudo make install
  sudo make install-doc
  )

  rm -rf lastpass-cli
}

osx_install() {
  brew update
  brew install lastpass-cli --with-pinentry
}

main () {
  if is_osx; then
    echo 'Installing for OSX'
    osx_install
  else
    echo 'Installing for Linux'
    linux_install
  fi;
}

main "$@"

