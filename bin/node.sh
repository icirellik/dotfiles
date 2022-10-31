#!/usr/bin/env bash
# Bash script installing node.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

NODE_VERSION_LTS=12.15.0
# NODE_VERSION_STABLE=13.8.0

NODE_VERSION=${NODE_VERSION_LTS}

is_osx() {
  local platform
  platform=$(uname)
  [ "${platform}" == "Darwin" ]
}

nvm_check() {
  [ -d "${HOME}/.nvm" ]
}

node_check() {
  [ -d "${HOME}/tool/node" ]
}

install_osx() {
  local version=${1}

  if [[ -n "${version}" ]]; then
    NODE_VERSION="${version}"
  fi

  if node_check; then
    echo "Node is installed."
    exit 1
  fi

  if [[ ! -d "${HOME}/.nvm" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  fi
  (
  # shellcheck source=/dev/null
  . "${NVM_DIR}"/nvm.sh
  nvm install "${NODE_VERSION}"
  nvm use "${NODE_VERSION}"
  )
}

install_linux() {
  local version=${1}

  if [[ -n "${version}" ]]; then
    NODE_VERSION="${version}"
  fi

  if nvm_check; then
    echo "NVM is installed."
    exit 1
  fi

  curl -s -o /tmp/node-v"${NODE_VERSION}"-linux-x64.tar.xz https://nodejs.org/dist/v"${NODE_VERSION}"/node-v"${NODE_VERSION}"-linux-x64.tar.xz;
  tar xf /tmp/node-v"${NODE_VERSION}"-linux-x64.tar.xz -C "${HOME}"/tools;
  ln -svfn "${HOME}"/tools/node-v"${NODE_VERSION}"-linux-x64 "${HOME}"/tools/node;
  rm -f /tmp/node-v"${NODE_VERSION}"-linux-x64.tar.xz;
}

main() {
  if is_osx; then
    install_osx "$@"
  else
    install_linux "$@"
  fi

  # Tools that I frequently use.
  (
  npm install -g \
      create-react-app \
      eslint \
      gulp \
      git-run \
      kill-tabs \
      npm \
      yarn;
  )
}

main "$@"
