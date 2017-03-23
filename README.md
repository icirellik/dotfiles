# My Dotfiles

Buyer beware

## Command Line Tools

sudo apt-get install -y \
    ranger \
    rxvt \
    shellcheck \
    silversearcher-ag \
    uncrustify \
    wavemon

## Manual Install

ln -s $(pwd)/.bash_completion.d ~/.bash_completion.d
ln -s $(pwd)/.bash_profile ~/.bash_profile
ln -s $(pwd)/.bash_prompt ~/.bash_prompt
ln -s $(pwd)/.bashrc ~/.bashrc
ln -s $(pwd)/.exports ~/.exports
ln -s $(pwd)/.todo ~/.todo
ln -s $(pwd)/bin ~/bin

