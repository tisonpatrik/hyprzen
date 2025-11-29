#!/bin/bash

# Set zsh as default shell
set_default_zsh() {
  local zsh_path
  zsh_path=$(which zsh 2>/dev/null || echo "/usr/bin/zsh")
  
  if [ ! -f "$zsh_path" ]; then
    echo "Warning: zsh not found, skipping shell setup"
    return 1
  fi
  
  # Check if zsh is in /etc/shells
  if ! grep -q "^$zsh_path$" /etc/shells 2>/dev/null; then
    echo "Adding zsh to /etc/shells..."
    echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
  fi
  
  # Set zsh as default shell if not already set
  local current_shell
  current_shell=$(getent passwd "$USER" | cut -d: -f7)
  
  if [ "$current_shell" != "$zsh_path" ]; then
    echo "Setting zsh as default shell for $USER..."
    chsh -s "$zsh_path"
    echo "Default shell changed to $zsh_path"
    echo "Note: The change will take effect after you restart or run: $zsh_path"
  else
    echo "zsh is already the default shell"
  fi
}

set_default_zsh

