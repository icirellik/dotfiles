#!/bin/bash

# Suppress macOS bash 3.2 deprecation warning (set early so subsequent
# `bash` invocations also see it).
export BASH_SILENCE_DEPRECATION_WARNING=1

# Load the shell dotfiles.
# Per-machine secrets live in ~/.exports.local etc. (sourced by .exports).
for file in ~/.{functions,functions.level20,aliases,path,dockerfunc,gitfunc,exports}; do
    if [[ -r "$file" ]] && [[ -f "$file" ]]; then
        # shellcheck source=/dev/null
        source "$file"
    fi
done
unset file

# Source completion files
for f in ~/.bash_completion.d/*; do
  # shellcheck source=/dev/null
  source "$f"
done
unset f

# Homebrew (macOS Apple Silicon path)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Oh My Posh prompt
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init bash --config "$HOME/code/dotfiles/posh.json")"
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Android SDK platform tools (for adb)
if [[ -d "$HOME/Library/Android/sdk/platform-tools" ]]; then
  export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
fi
