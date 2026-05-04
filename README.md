# My Dotfiles

Buyer beware.

## Installation (macOS)

```sh
make all-osx
```

This symlinks dotfiles into `$HOME`, runs `bin/macos.sh` (Homebrew + casks),
and installs vim-plug, tmux's TPM, and the Google Cloud SDK.

After install:

```sh
# tmux plugins (one-time): start tmux, then prefix-key + I (capital i)
tmux

# pick up the new shell config
exec -l $SHELL
```

## Per-machine secrets and overrides

The tracked shell config files source `~/.{exports,aliases,functions}.local`
at the end if present. These files are gitignored and intended for per-machine
secrets and overrides. Example `~/.exports.local`:

```sh
export GH_TOKEN="ghp_..."
export JIRA_API_TOKEN="..."
```

`~/.npmrc` is also intentionally outside the repo (npm reads it directly) and
is the right place for `_authToken` lines.

## Installation (Ubuntu)

```sh
sudo apt-get install build-essential curl python3 jq vim
make
```

The Linux installer (`bin/install.sh`) targets Ubuntu — the original
package list was for 16.04 and predates several deprecations. Audit before
running on a current LTS.

## Tests

```sh
make test
```

Runs shellcheck via Docker.

## GPG / tmux

If commit signing fails inside tmux:

```sh
export GPG_TTY=$(tty)
```

## Disabled / archived

The following were once in the bootstrap and are now disabled or moved to
`attic/`:

- Vundle (`.vimrc.bundles` is now vim-plug; old config in `attic/`)
- `.bash_prompt` (oh-my-posh now drives the prompt; old config in `attic/`)
- Travis CI (`attic/travis.yml.disabled`)
- Flyway / Syncthing in the Linux `tools` target (commented in Makefile)

## Video (X11)

When using nvidia GPUs and X11, make sure to do the following so settings
are saved to the correct config:

```sh
sudo nvidia-xconfig
```

Then in the resulting `xorg.conf`, in the `Section "Device"` block, add:

```
Option "RegistryDwords" "PowerMizerEnable=0x1; PerfLevelSrc=0x3322"
```
