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

Restart your shell

exec -l $SHELL

Run shellcheck tests

```sh
$ make test
```

## Command Line Tools

sudo apt-get install -y \
    jq \
    lm-sensors \
    ngrep \
    pinentry-curses \
    ranger \
    rxvt \
    shellcheck \
    silversearcher-ag \
    sysstat \
    tree \
    uncrustify \
    wavemon \
    xclip

## NPM Tools

npm install -g \
  gulp \
  git-run

## Help

Sometimes in tmux you need to update the GPG_TTY

```sh
$ export GPG_TTY=$(tty)
```

## Flyway

https://flywaydb.org/

## IntelliJ

## Atom.io
