# My Dotfiles

[![Travis CI](https://travis-ci.org/icirellik/dotfiles.svg?branch=master)](https://travis-ci.org/icirellik/dotfiles)

Buyer beware

All of these install scripts have been tested to Ubuntu 16.04.

## Installation (Ubuntu 16.04)

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

## Installlation (OSX)

```sh
$ make all-osx
```

## Help

Sometimes in tmux you need to update the GPG_TTY

```sh
$ export GPG_TTY=$(tty)
```

## Flyway

https://flywaydb.org/

## IntelliJ

## Atom.io
