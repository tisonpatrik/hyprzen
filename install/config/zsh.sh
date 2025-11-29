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
    if sudo usermod -s "$zsh_path" "$USER" 2>/dev/null; then
      echo "Default shell changed to $zsh_path"
      
      # Verify the change
      local new_shell
      new_shell=$(getent passwd "$USER" | cut -d: -f7)
      if [ "$new_shell" = "$zsh_path" ]; then
        echo "✓ Shell successfully changed to $zsh_path"
        echo "Note: Open a new terminal or restart to use zsh"
      else
        echo "Warning: Shell change may have failed. Current shell: $new_shell"
      fi
    else
      echo "Error: Failed to change shell. You may need to run manually:"
      echo "  sudo usermod -s $zsh_path $USER"
      echo "  or"
      echo "  chsh -s $zsh_path"
    fi
  else
    echo "zsh is already the default shell ($zsh_path)"
  fi
}

set_default_zsh

# Final verification
verify_zsh_setup() {
  echo ""
  echo "=== zsh Setup Verification ==="
  
  local zsh_path
  zsh_path=$(which zsh 2>/dev/null || echo "/usr/bin/zsh")
  
  # Check 1: Is zsh installed?
  if [ -f "$zsh_path" ]; then
    echo "✓ zsh is installed at: $zsh_path"
  else
    echo "✗ zsh is NOT installed"
    return 1
  fi
  
  # Check 2: Is zsh in /etc/shells?
  if grep -q "^$zsh_path$" /etc/shells 2>/dev/null; then
    echo "✓ zsh is in /etc/shells"
  else
    echo "✗ zsh is NOT in /etc/shells"
    return 1
  fi
  
  # Check 3: Is zsh the default shell?
  local current_shell
  current_shell=$(getent passwd "$USER" | cut -d: -f7)
  if [ "$current_shell" = "$zsh_path" ]; then
    echo "✓ zsh is set as default shell for $USER"
  else
    echo "✗ zsh is NOT the default shell (current: $current_shell)"
    return 1
  fi
  
  # Check 4: Are dotfiles applied?
  if [ -f "$HOME/.zshrc" ]; then
    echo "✓ .zshrc exists (dotfiles applied)"
  else
    echo "⚠ .zshrc not found (dotfiles may not be applied)"
  fi
  
  echo "=== Verification Complete ==="
  echo ""
  echo "To use zsh:"
  echo "  1. Open a NEW terminal window/tab, OR"
  echo "  2. Run: $zsh_path, OR"
  echo "  3. Restart your system"
  echo ""
}

verify_zsh_setup

