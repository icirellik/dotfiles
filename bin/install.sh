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
    apache2-utils \
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
    moreutils \
    mount \
    net-tools \
    network-manager \
    ngrep \
    openvpn \
    pinentry-curses \
    powertop \
    pylint \
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
    tmux \
    tree \
    tzdata \
    uncrustify \
    unzip \
    vim \
    wavemon \
    xclip \
    xcompmgr \
    xz-utils \
    zip \
    --no-install-recommends


  # Install Postgres Client
  sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install -y postgresql-client-9.6

  # install tlp with recommends
  apt-get install -y tlp tlp-rdw

  setup_sudo

  apt-get remove -y --purge nano

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

# Automatically install and verify Githubs ssh fingerprints.
# https://help.github.com/articles/github-s-ssh-key-fingerprints/
setup_github_ssh_fingerprint() {
  echo "TODO: Not implemented"
}

# Automatically install and verify Bitbuckets ssh fingerprints
# https://confluence.atlassian.com/bitbucket/use-the-ssh-protocol-with-bitbucket-cloud-221449711.html
setup_bitbucket_ssh_fingerprint() {
  echo "TODO: Not implemented"
}

# install/update golang from source
install_golang() {
	export GO_VERSION=1.8.1
	export GO_SRC=/usr/local/go

	# if we are passing the version
	if [[ ! -z "$1" ]]; then
		export GO_VERSION=$1
	fi

	# purge old src
	if [[ -d "$GO_SRC" ]]; then
		sudo rm -rf "$GO_SRC"
		sudo rm -rf "$GOPATH"
	fi

	# subshell
	(
	curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | sudo tar -v -C /usr/local -xz
	local user="$USER"
	# rebuild stdlib for faster builds
	sudo chown -R "${user}" /usr/local/go/pkg
	CGO_ENABLED=0 go install -a -installsuffix cgo std
	)

	# get commandline tools
	(
	set -x
	set +e
	go get github.com/golang/lint/golint
	go get golang.org/x/tools/cmd/cover
	go get golang.org/x/review/git-codereview
	go get golang.org/x/tools/cmd/goimports
	go get golang.org/x/tools/cmd/gorename
	go get golang.org/x/tools/cmd/guru
	)
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

# install photograph tools.
# https://github.com/ibaaj/awesome-OpenSourcePhotography
install_photo() {
  apt-get update
  apt-get -y upgrade

  apt-get install -y \
    darktable \
    --no-install-recommends
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

install_java() {
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    openjdk-8-jdk

  intellij.sh
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
  echo -e "install.sh\\n\\tThis script installs my basic setup for an ubuntu laptop\\n"
  echo "Usage:"
  echo "  sources                     - setup sources & install base pkgs"
  echo "  java                        - setup java & grails & maven"
  echo "  golang                      - install golang and packages"
  echo "  photo                       - install photography packages"
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
  elif [[ $cmd == "java" ]]; then
    install_java
  elif [[ $cmd == "golang" ]]; then
		install_golang "$2"
  elif [[ $cmd == "wifi" ]]; then
    install_wifi "$2"
  elif [[ $cmd == "photo" ]]; then
    install_photo
  elif [[ $cmd == "graphics" ]]; then
    check_is_sudo

    install_graphics "$2"
  else
    usage
  fi
}

main "$@"
