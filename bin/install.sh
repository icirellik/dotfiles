#!/bin/bash
set -e

# install.sh
#  This script installs my basic setup for a debian laptop

# get the user that is not root
# TODO: makes a pretty bad assumption that there is only one other user
USERNAME="$USER"
export DEBIAN_FRONTEND=noninteractive

check_is_sudo() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit
  fi
}

is_osx() {
  local platform
  platform=$(uname)
  [ "$platform" == "Darwin" ]
}

# sets up apt sources
# assumes you are going to use debian stretch
setup_sources() {
  apt-get update
  apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    dirmngr \
    --no-install-recommends

  # turn off translations, speed up apt-get update
  mkdir -p /etc/apt/apt.conf.d
  echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations
}

# installs base packages
# the utter bare minimal shit
base() {
  apt-get update
  apt-get -y upgrade

  apt-get install -y \
    adduser \
    alsa-utils \
    apparmor \
    automake \
    bash-completion \
    bc \
    bridge-utils \
    bzip2 \
    ca-certificates \
    cgroupfs-mount \
    coreutils \
    curl \
    dnsutils \
    file \
    findutils \
    gcc \
    git \
    gnupg \
    gnupg-agent \
    gnupg2 \
    grep \
    gzip \
    hostname \
    iptables \
    jq \
    less \
    libapparmor-dev \
    libc6-dev \
    libltdl-dev \
    libseccomp-dev \
    lm-sensors \
    locales \
    lsof \
    make \
    meld \
    mount \
    net-tools \
    network-manager \
    ngrep \
    openvpn \
    pinentry-curses \
    ranger \
    rxvt \
    rxvt-unicode-256color \
    s3cmd \
    scdaemon \
    shellcheck \
    silversearcher-ag \
    ssh \
    strace \
    sudo \
    sysstat \
    tar \
    tree \
    tzdata \
    uncrustify \
    unzip \
    wavemon \
    xclip \
    xcompmgr \
    xz-utils \
    zip \
    --no-install-recommends

  # install tlp with recommends
  apt-get install -y tlp tlp-rdw

  setup_sudo

  apt-get autoremove
  apt-get autoclean
  apt-get clean

  install_scripts
}

# setup sudo for a user
# because fuck typing that shit all the time
# just have a decent password
# and lock your computer when you aren't using it
# if they have your password they can sudo anyways
# so its pointless
# i know what the fuck im doing ;)
setup_sudo() {
  # add user to sudoers
  adduser "$USERNAME" sudo

  # add user to systemd groups
  # then you wont need sudo to view logs and shit
  gpasswd -a "$USERNAME" systemd-journal
  gpasswd -a "$USERNAME" systemd-network
}

# install graphics drivers
install_graphics() {
  local system=$1

  if [[ -z "$system" ]]; then
    echo "You need to specify whether it's dell, mac or lenovo"
    exit 1
  fi

  local pkgs=( nvidia-kernel-dkms bumblebee-nvidia primus )

  if [[ $system == "mac" ]] || [[ $system == "dell" ]]; then
    pkgs=( xorg xserver-xorg xserver-xorg-video-intel )
  fi

  apt-get install -y "${pkgs[@]}" --no-install-recommends
}

# install custom scripts/binaries
install_scripts() {
  # install speedtest
  curl -sSL https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py  > /usr/local/bin/speedtest
  chmod +x /usr/local/bin/speedtest

  # install icdiff
  curl -sSL https://raw.githubusercontent.com/jeffkaufman/icdiff/master/icdiff > /usr/local/bin/icdiff
  curl -sSL https://raw.githubusercontent.com/jeffkaufman/icdiff/master/git-icdiff > /usr/local/bin/git-icdiff
  chmod +x /usr/local/bin/icdiff
  chmod +x /usr/local/bin/git-icdiff

  # install lolcat
  curl -sSL https://raw.githubusercontent.com/tehmaze/lolcat/master/lolcat > /usr/local/bin/lolcat
  chmod +x /usr/local/bin/lolcat
}

# install wifi drivers
install_wifi() {
  local system=$1

  if [[ -z "$system" ]]; then
    echo "You need to specify whether it's broadcom or intel"
    exit 1
  fi

  if [[ $system == "broadcom" ]]; then
    local pkg="broadcom-sta-dkms"

    apt-get install -y "$pkg" --no-install-recommends
  else
    update-iwlwifi
  fi
}

get_dotfiles() {
  # create subshell
  (
  cd "$HOME"

  # install dotfiles from repo
  git clone git@github.com:icirellik/dotfiles.git "${HOME}/dotfiles"
  cd "${HOME}/dotfiles"

  # installs all the things
  make
  )
}

usage() {
  echo -e "install.sh\n\tThis script installs my basic setup for an ubuntu laptop\n"
  echo "Usage:"
  echo "  sources                     - setup sources & install base pkgs"
  echo "  wifi {broadcom,intel}       - install wifi drivers"
  echo "  graphics {dell,mac,lenovo}  - install graphics drivers"
}

main() {
  local cmd=$1

  if [[ -z "$cmd" ]]; then
    usage
    exit 1
  fi

  if [[ $cmd == "sources" ]]; then
    check_is_sudo

    # setup /etc/apt/sources.list
    setup_sources

    base
  elif [[ $cmd == "wifi" ]]; then
    install_wifi "$2"
  elif [[ $cmd == "graphics" ]]; then
    check_is_sudo

    install_graphics "$2"
  else
    usage
  fi
}

main "$@"
