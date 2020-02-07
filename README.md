# My Dotfiles

[![Travis CI](https://travis-ci.org/icirellik/dotfiles.svg?branch=master)](https://travis-ci.org/icirellik/dotfiles)

Buyer beware

All of these install scripts have been tested to Ubuntu 16.04.

## Installation (Ubuntu 16.04)

Install deps

sudo apt-get install build-essential curl python jq vim

```sh
$ make
```

Install tmux plugins, this is currently manual.

```sh
$ tmux
# prefix-key, I
```

Restart your shell

```sh
exec -l $SHELL
```

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

## Video (X11)

When using nvidia gpu's and X!! make sure the do the following to ensure that
settings are saved to the correct config.

Create a xorg.conf file by:

```sh
sudo nvidia-xconfig
```

Look for the Section "Device" part in the xorg.conf file And add this line
inside the section:

```sh
Option "RegistryDwords" "PowerMizerEnable=0x1; PerfLevelSrc=0x3322"
```
