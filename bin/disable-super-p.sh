#!/usr/bin/env bash
# Bash script for disablign super+p
#
# By default pressing super+p changes the display layout on linux, this is
# highly inconvenient as super+p is how you browse code on macOS so it gets
# pressed by accident all the time.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

is_osx() {
  local platform
  platform=$(uname)
  [ "${platform}" == "Darwin" ]
}


install_linux() {
  read -p "Are you sure you want to disable super+p? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo 'Exiting'
  else
    sudo gconftool-2 -t boolean -s /apps/gnome_settings_daemon/plugins/xrandr/active false
    sudo dconf write /org/gnome/settings-daemon/plugins/media-keys/video-out "''"
    echo 'Disabled'
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



