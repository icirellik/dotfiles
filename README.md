# My Dotfiles

[![Travis CI](https://travis-ci.org/icirellik/dotfiles.svg?branch=master)](https://travis-ci.org/icirellik/dotfiles)

Buyer beware

## Installation

```sh
$ make
```

Install tmux plugins, this is currently manual.

```sh
$ tmux
# prefix-key, I
```

Run shellcheck tests

```sh
$ make test
```

## Command Line Tools

sudo apt-get install -y \
    ranger \
    rxvt \
    shellcheck \
    silversearcher-ag \
    uncrustify \
    wavemon

## NPM Tools

npm install -g \
  gulp \
  git-run

## Help

Sometimes in tmux you need to update the GPG_TTY

```sh
$ export GPG_TTY=$(tty)
```
