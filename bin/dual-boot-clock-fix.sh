#!/usr/bin/env bash
# Bash script for correcting the hardware clock on dual-boot machines.
#
# By default windows stores the time in the hardware clock using localtime. All
# other operating systems use UTC time. This script will update linux to store
# local instead of UTC in the hardware clock allowign windows and linux to both
# have the correct time at boot.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

is_osx() {
  local platform
  platform=$(uname)
  [ "${platform}" == "Darwin" ]
}


install_linux() {
  read -p "Are you sure you want to update the hardware clock? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo 'Exiting'
  else
    sudo timedatectl set-local-rtc 1
    echo 'Updated'
  fi
}

main() {
  if is_osx; then
    echo 'Not supported on osx'
  else
    install_linux "$@"
  fi
}

main "$@"
