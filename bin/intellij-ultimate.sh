#!/bin/bash
# Bash script installing IntelliJ Ultimate.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

INTELLIJ_VERSION=2017.2

main() {

  local cmd="$1"

  if [[ "${cmd}" != "--force" ]] && [[ -d "${HOME}/tools/idea-ultimate" ]]; then
    echo "IntelliJ Ultimate is already installed, use --force to reinstall it."
    exit
  fi

  if [[ "${cmd}" == "--force" ]]; then
    echo "Removing old IntelliJ Utlimate installation."
    rm -rf "${HOME}/tools/ideaIU-${INTELLIJ_VERSION}"
    rm -f "${HOME}/tools/idea-ultimate"
    sudo rm -f /usr/local/bin/idea-ultimate
  fi

  echo "Downloading IntelliJ Ultimate"
  mkdir -p "/tmp/ideaIU-${INTELLIJ_VERSION}"
  curl -SL "https://download.jetbrains.com/idea/ideaIU-${INTELLIJ_VERSION}.tar.gz" > "/tmp/ideaIU-${INTELLIJ_VERSION}.tar.gz"
  tar xf "/tmp/ideaIU-${INTELLIJ_VERSION}.tar.gz" -C "/tmp/ideaIU-${INTELLIJ_VERSION}/" --strip-components 1
  mv "/tmp/ideaIU-${INTELLIJ_VERSION}" "${HOME}/tools"
  rm -f "/tmp/ideaIU-${INTELLIJ_VERSION}.tar.gz"

  ln -sf "${HOME}/tools/ideaIU-${INTELLIJ_VERSION}" "${HOME}/tools/idea-ultimate"

  sudo ln -s "${HOME}/tools/idea-ultimate/bin/idea.sh" /usr/local/bin/idea-ultimate

  (
  if [[ "$(basename "${PWD}")" != dotfiles ]]; then
    cd ..
  fi
  )

}

main "$@"
