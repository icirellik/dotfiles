#!/usr/bin/env bash

# Bash script silently installing macOS applications.
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
  # brew install go
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
  # brew install stormssh
  # brew install syncthing
  brew install thefuck
  brew install tmux
  brew install trash
  brew install tree
  brew install vim
  brew install wget

  # Modern CLI tools
  brew install delta       # syntax-highlighted git diffs (wired into .gitconfig)
  brew install direnv      # per-directory env vars; great for project secrets
  brew install gh          # GitHub CLI (PRs, issues, releases from the terminal)
  brew install mise        # runtime version manager (replaces nvm; adds python/ruby/go)
  brew install ripgrep     # fast grep replacement; .vimrc grep config can fall back to it
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
  echo "Install software (casks)"

  # Note: `brew cask install` was removed in Homebrew 2.6 (Dec 2020).
  # Use `brew install --cask <name>` instead.
  brew install muzzle --cask
  brew install suspicious-package --cask

  # Other casks I've used; uncomment as needed.
  # brew install airdroid --cask
  # brew install commander-one --cask
  # brew install geekbench --cask
  # brew install iina --cask
  # brew install licecap --cask
  # brew install macdown --cask
  # brew install private-eye --cask
  # brew install qlcolorcode --cask
  # brew install qlimagesize --cask
  # brew install qlmarkdown --cask
  # brew install qlstephen --cask
  # brew install qlvideo --cask
  # brew install quicklook-csv --cask
  # brew install quicklook-json --cask
  # brew install quicklookase --cask
  # brew install webpquicklook --cask
}

awesome_apps() {
  echo "These are awesome apps, please check them out"
  echo "DBeaver"
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
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Update Homebrew"
    brew update
    brew upgrade
  fi
  brew doctor

  echo "Install Terminal"
  brew install alacritty --cask

  brews
  casks
  pips
  bash

  echo "Cleanup"
  brew cleanup

  echo "Done!"
}

if is_osx; then
  main "$@"
else
  echo 'Skipping osx installations.'
fi
