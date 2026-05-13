# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Window size
shopt -s checkwinsize

# Linux/Debian-template configuration (no-op on macOS)
if [ "$(uname)" != "Darwin" ]; then
    # make less more friendly for non-text input files
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # set variable identifying the chroot you work in
    if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    # color prompt
    case "$TERM" in
        xterm-color) color_prompt=yes;;
    esac
    force_color_prompt=yes
    if [ -n "$force_color_prompt" ]; then
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
            color_prompt=yes
        else
            color_prompt=
        fi
    fi
    if [ "$color_prompt" = yes ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
    unset color_prompt force_color_prompt

    case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    esac

    # ls colorization (GNU coreutils only)
    if [ -x /usr/bin/dircolors ]; then
        # shellcheck disable=SC2015
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias dir='dir --color=auto'
        alias vdir='vdir --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

    # Long-running command alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

    # Programmable completion
    if ! shopt -oq posix; then
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
    fi
fi

export EDITOR=vim

# Circular source removed: .bash_profile is the entry point for login shells;
# .bashrc handles non-login interactive shells. They should not source each
# other. If a non-login interactive shell needs login-shell content, configure
# the terminal emulator to start a login shell (`bash -l`) instead.

# Double check for TPM
if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
  echo "Please browse to https://github.com/tmux-plugins/tpm#installation"
  echo "and install TPM for Tmux"
fi

# GPG TTY for commit signing
GPG_TTY=$(tty)
export GPG_TTY
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
  gpg-connect-agent /bye >/dev/null 2>&1
  gpg-connect-agent updatestartuptty /bye >/dev/null
fi

# Use gpg-agent for SSH (Linux uses /run/user; macOS uses gpgconf-listed socket)
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  if [ "$(uname)" = "Darwin" ]; then
    SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket 2>/dev/null)"
    [ -n "$SSH_AUTH_SOCK" ] && export SSH_AUTH_SOCK
  else
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  fi
fi

alias ssh="gpg-connect-agent updatestartuptty /bye >/dev/null; ssh"
