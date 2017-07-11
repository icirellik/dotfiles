#!/bin/bash
# Bash script installing lastpass cli.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

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

git clone git@github.com:lastpass/lastpass-cli.git

(
cd lastpass-cli
make
sudo make install
sudo make install-doc
)

rm -rf lastpass-cli
