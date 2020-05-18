#!/usr/bin/env bash

# Bash script silently installing osx applications.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set +e
set -x

is_osx() {
  local platform
  platform=$(uname)
  [ "$platform" == "Darwin" ]
}

bash() {
  # echo "Upgrade bash"
  # brew install bash
  # sudo bash -c "echo $(brew --prefix)/bin/bash >> /private/etc/shells"
  # cd; curl -#L https://github.com/barryclark/bashstrap/tarball/master | tar -xzv --strip-components 1 --exclude={README.md,screenshot.png}
  echo "TBD"
}

brews() {
  echo "Install packages"
  brew install bash-completion
  brew install coreutils
  brew install dfc
  brew install findutils
  brew install fontconfig
  brew install fpp
  brew install fzf
  brew install git
  brew install git-extras
  brew install git-fresh
  brew install git-lfs
  brew install gnu-sed
  brew install gnuplot
  brew install go
  brew install gpg
  brew install hh
  brew install htop
  brew install httpie
  brew install iftop
  brew install imagemagick
  brew install lnav
  brew install m-cli
  brew install mas
  brew install micro
  brew install moreutils
  brew install mtr
  brew install ncdu
  brew install nmap
  brew install osquery
  brew install poppler
  brew install pv
  brew install ranger
  brew install sbt
  brew install stormssh
  brew install syncthing
  brew install thefuck
  brew install tmux
  brew install trash
  brew install tree
  brew install vim
  brew install wget
}

# Things I don't want auto installed
# docker
# firefox
# google-chrome
# satellite-eyes
# slack
# spotify
# sidekick
# visual-studio-code
casks() {
  echo "Install software"
  brew tap homebrew/cask-versions

  brew cask install airdroid
  brew cask install commander-one
  brew cask install geekbench
  brew cask install iina
  brew cask install licecap
  brew cask install macdown
  brew cask install muzzle
  brew cask install private-eye
  brew cask install qlcolorcode
  brew cask install qlimagesize
  brew cask install qlmarkdown
  brew cask install qlstephen
  brew cask install qlvideo
  brew cask install quicklook-csv
  brew cask install quicklook-json
  brew cask install quicklookase
  brew cask install suspicious-package
  brew cask install webpquicklook
}

pips() {
  echo "Installing secondary packages"

  sudo pip3 install --upgrade pip
  pip3 install --upgrade glances

  echo "Update packages"
  pip3 install --upgrade setuptools wheel
}

main() {
  if test ! "$(command -v brew)"; then
    echo "Install Xcode"
    xcode-select --install

    echo "Install Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "Update Homebrew"
    brew update
    brew upgrade
  fi
  brew doctor

  echo "Install Java"
  brew cask install java

  brews
  casks
  pips
  bash

  echo "Cleanup"
  brew cleanup

  echo "Colors"
  git clone git@github.com:dracula/iterm ~/.itermcolors

  echo "Done!"
}

if is_osx; then
  main "$@"
else
  echo 'Skipping osx installations.'
fi
