#!/bin/zsh

ZSH_CONFIG_DIR="$HOME/.config/zsh/config.d"

if [[ -d "$ZSH_CONFIG_DIR" ]]; then

    for config_file in "$ZSH_CONFIG_DIR"/*.zsh; do

        if [[ -r "$config_file" ]]; then
            source "$config_file"
        fi

    done
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
