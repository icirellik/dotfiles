#!/usr/bin/env bash
# Bash script installing inkscape.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

is_osx() {
  local platform
  platform=$(uname)
  [ "${platform}" == "Darwin" ]
}

install_osx() {
  echo "OSX installer not currently implmented."
}

install_linux() {
  sudo add-apt-repository -y ppa:inkscape.dev/stable
  sudo apt-get update

  sudo apt-get install -y inkscape
}

main() {
  if is_osx; then
    install_osx "$@"
  else
    install_linux "$@"
  fi
}

main "$@"
