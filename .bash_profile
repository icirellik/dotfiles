#!/bin/bash

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{bash_prompt,aliases,functions,path,dockerfunc,gitfunc,exports}; do
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

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/$USER/.sdkman"
# shellcheck source=/dev/null
[[ -s "/home/$USER/.sdkman/bin/sdkman-init.sh" ]] && source "/home/$USER/.sdkman/bin/sdkman-init.sh"
