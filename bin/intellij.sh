#!/bin/bash
# Bash script installing IntelliJ.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

INTELLIJ_VERSION=2017.1.5

main() {

  local cmd="$1"

  if [[ "${cmd}" != "--force" ]] && [[ -d "${HOME}/tools/idea" ]]; then
    echo "IntelliJ is already installed, use --force to reinstall it."
    exit
  fi

  if [[ "${cmd}" == "--force" ]]; then
    echo "Removing old IntelliJ installation."
    rm -rf "${HOME}/tools/ideaIC-${INTELLIJ_VERSION}"
    rm -f "${HOME}/tools/idea"
    sudo rm -f /usr/local/bin/idea
  fi

  echo "Downloading IntelliJ"
  mkdir -p "/tmp/ideaIC-${INTELLIJ_VERSION}"
  curl -SL "https://download-cf.jetbrains.com/idea/ideaIC-${INTELLIJ_VERSION}.tar.gz" > "/tmp/ideaIC-${INTELLIJ_VERSION}.tar.gz"
  tar xf "/tmp/ideaIC-${INTELLIJ_VERSION}.tar.gz" -C "/tmp/ideaIC-${INTELLIJ_VERSION}/" --strip-components 1
  mv "/tmp/ideaIC-${INTELLIJ_VERSION}" "${HOME}/tools"
  rm -f "/tmp/ideaIC-${INTELLIJ_VERSION}.tar.gz"

  ln -sf "${HOME}/tools/ideaIC-${INTELLIJ_VERSION}" "${HOME}/tools/idea"

  sudo ln -s "${HOME}/tools/idea/bin/idea.sh" /usr/local/bin/idea

  (
  if [[ "$(basename "${PWD}")" != dotfiles ]]; then
    cd ..
  fi

  mkdir -p "${HOME}/.IdeaIC2017.1/config/codestyles/"
  ln -sfn "${PWD}/idea/config/codestyles/Default.xml" "${HOME}/.IdeaIC2017.1/config/codestyles/Default.xml"

  mkdir -p "${HOME}/.IdeaIC2017.1/config/tools/"
  ln -sfn "${PWD}/idea/config/tools/External Tools.xml" "${HOME}/.IdeaIC2017.1/config/tools/External Tools.xml"

  mkdir -p "${HOME}/.IdeaIC2017.1/config/otions/"
  ln -sfn "${PWD}/idea/config/options/editor.xml" "${HOME}/.IdeaIC2017.1/config/options/editor.xml"
  ln -sfn "${PWD}/idea/config/options/editor.codeinsight.xml" "${HOME}/.IdeaIC2017.1/config/options/editor.codeinsight.xml"
  )

}

main "$@"
