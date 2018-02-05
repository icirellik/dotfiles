#!/bin/bash
# Bash script installing boostnote.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

curl -sSLo /tmp/boostnote.deb https://github.com/BoostIO/boost-releases/releases/download/v0.8.20/boostnote_0.8.20_amd64.deb

sudo dpkg -i /tmp/boostnote.deb

rm /tmp/boostnote.deb
