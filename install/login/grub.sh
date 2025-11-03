#!/bin/bash

# Clone catppuccin grub theme repository
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

git clone https://github.com/catppuccin/grub.git "$TEMP_DIR/grub"

# Copy all themes from src to both theme directories
sudo mkdir -p /usr/share/grub/themes
sudo mkdir -p /boot/grub/themes
sudo cp -r "$TEMP_DIR/grub/src"/* /usr/share/grub/themes/
sudo cp -r "$TEMP_DIR/grub/src"/* /boot/grub/themes/

# Modify /etc/default/grub to set GRUB theme
if [ -f /etc/default/grub ]; then
  # Set GRUB_THEME
  if grep -q "^GRUB_THEME=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/catppuccin-mocha-grub-theme/theme.txt"|' /etc/default/grub
  else
    echo 'GRUB_THEME="/boot/grub/themes/catppuccin-mocha-grub-theme/theme.txt"' | sudo tee -a /etc/default/grub > /dev/null
  fi

  # Set GRUB_GFXMODE
  if grep -q "^GRUB_GFXMODE=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_GFXMODE=.*|GRUB_GFXMODE=1920x1080|' /etc/default/grub
  else
    echo 'GRUB_GFXMODE=1920x1080' | sudo tee -a /etc/default/grub > /dev/null
  fi

  # Set GRUB_GFXPAYLOAD_LINUX
  if grep -q "^GRUB_GFXPAYLOAD_LINUX=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_GFXPAYLOAD_LINUX=.*|GRUB_GFXPAYLOAD_LINUX=keep|' /etc/default/grub
  else
    echo 'GRUB_GFXPAYLOAD_LINUX=keep' | sudo tee -a /etc/default/grub > /dev/null
  fi

  # Comment out GRUB_TERMINAL_OUTPUT if it exists
  if grep -q "^GRUB_TERMINAL_OUTPUT=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_TERMINAL_OUTPUT=|# GRUB_TERMINAL_OUTPUT=|' /etc/default/grub
  fi

  # Comment out GRUB_TERMINAL if it exists
  if grep -q "^GRUB_TERMINAL=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_TERMINAL=|# GRUB_TERMINAL=|' /etc/default/grub
  fi
fi

# Update grub config
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Verify theme is applied
echo "Verifying GRUB theme configuration:"
grep -n "theme" /boot/grub/grub.cfg

