#!/bin/bash

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{bash_prompt,functions,aliases,path,dockerfunc,gitfunc,exports}; do
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
