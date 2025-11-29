#!/bin/bash

# Install plymouth and catppuccin theme from AUR
yay -S --needed --noconfirm plymouth-git plymouth-theme-catppuccin-mocha-git

# Configure plymouth for LUKS encryption
if [ -f /etc/mkinitcpio.conf ]; then
  # Add plymouth hook if not already present
  if ! grep -q "plymouth" /etc/mkinitcpio.conf; then
    # Add plymouth hook JUST BEFORE encrypt
    if grep -q "encrypt" /etc/mkinitcpio.conf; then
      sudo sed -i 's/\(HOOKS=(.*\)encrypt/\1plymouth encrypt/' /etc/mkinitcpio.conf
    else
      # If encrypt not found, add before filesystems
      if grep -q "filesystems" /etc/mkinitcpio.conf; then
        sudo sed -i 's/\(HOOKS=(.*\)filesystems/\1plymouth filesystems/' /etc/mkinitcpio.conf
      else
        # Add at the end if neither found
        sudo sed -i 's/^HOOKS=(\(.*\))/HOOKS=(\1 plymouth)/' /etc/mkinitcpio.conf
      fi
    fi
  fi
fi

# Add splash parameter to GRUB (after quiet)
if [ -f /etc/default/grub ]; then
  if grep -q "^GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub; then
    # Add splash after quiet if not already present
    if ! grep -q "splash" /etc/default/grub; then
      sudo sed -i 's|\(GRUB_CMDLINE_LINUX_DEFAULT=".*quiet\)"|\1 splash"|' /etc/default/grub
    fi
  else
    echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"' | sudo tee -a /etc/default/grub > /dev/null
  fi
  sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# Set plymouth theme
sudo plymouth-set-default-theme -R catppuccin-mocha