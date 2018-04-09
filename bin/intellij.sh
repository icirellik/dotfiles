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

  ln -svfn "${HOME}/tools/ideaIC-${INTELLIJ_VERSION}" "${HOME}/tools/idea"

  sudo ln -svfn "${HOME}/tools/idea/bin/idea.sh" /usr/local/bin/idea

  (
  if [[ "$(basename "${PWD}")" != dotfiles ]]; then
    cd ..
  fi

  # Codestyles
  mkdir -p "${HOME}/.IdeaIC2017.1/config/codestyles/"
  ln -svfn "${PWD}/idea/config/codestyles/Custom.xml" "${HOME}/.IdeaIC2017.1/config/codestyles/Custom.xml"

  # External tools
  mkdir -p "${HOME}/.IdeaIC2017.1/config/tools/"
  ln -svfn "${PWD}/idea/config/tools/External Tools.xml" "${HOME}/.IdeaIC2017.1/config/tools/External Tools.xml"

  # Editor options
  mkdir -p "${HOME}/.IdeaIC2017.1/config/options/"
  ln -svfn "${PWD}/idea/config/options/code.style.schemes.xml" "${HOME}/.IdeaIC2017.1/config/options/code.style.schemes.xml"
  ln -svfn "${PWD}/idea/config/options/editor.xml" "${HOME}/.IdeaIC2017.1/config/options/editor.xml"
  ln -svfn "${PWD}/idea/config/options/editor.codeinsight.xml" "${HOME}/.IdeaIC2017.1/config/options/editor.codeinsight.xml"
  ln -svfn "${PWD}/idea/config/options/ide.general.xml" "${HOME}/.IdeaIC2017.1/config/options/ide.general.xml"
  ln -svfn "${PWD}/idea/config/options/keymap.xml" "${HOME}/.IdeaIC2017.1/config/options/keymap.xml"

  # Keymaps
  mkdir -p "${HOME}/.IdeaIC2017.1/config/keymaps/"
  ln -svfn "${PWD}/idea/config/keymaps/Custom.xml" "${HOME}/.IdeaIC2017.1/config/keymaps/Custom.xml"

  )

}

main "$@"
