#!/bin/bash

# Bash script that contains a function for detecting the platform.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

is_osx() {
  local platform
  platform=$(uname)
  [ "$platform" == "Darwin" ]
}
